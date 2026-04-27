import bisect
import json
import os
import re
import struct
import tempfile
import zlib

from kitty.boss import Boss
from kitty.fast_data_types import Color, cell_size_for_window, get_options
from kitty.rgb import color_as_sharp, color_from_int
from kitty.utils import which
from kittens.tui.handler import result_handler


def raw_to_png(data: bytes, width: int, height: int, is_rgba: bool) -> bytes:
    bpp = 4 if is_rgba else 3
    color_type = 6 if is_rgba else 2
    raw_rows = []
    stride = width * bpp
    for y in range(height):
        raw_rows.append(b"\x00" + data[y * stride : (y + 1) * stride])
    compressed = zlib.compress(b"".join(raw_rows))

    def chunk(tag: bytes, body: bytes) -> bytes:
        return struct.pack(">I", len(body)) + tag + body + struct.pack(">I", zlib.crc32(tag + body) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", width, height, 8, color_type, 0, 0, 0)
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", compressed) + chunk(b"IEND", b"")


def main():
    """Required entry point for kitty's kitten protocol, even with no_ui=True."""
    raise SystemExit("Must be run as kitten kitty_scrollback")


@result_handler(type_of_input=None, no_ui=True, has_ready_notification=False)
def handle_result(_args, _result, target_window_id: int, boss: Boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        raise Exception(f"Failed to get window with id: {target_window_id}")
    if w.title.startswith("kitty-scrollback"):
        return

    kitty_path = which("kitty")
    if not kitty_path:
        boss.show_error("kitty_scrollback", "Cannot find kitty in PATH")
        return
    # Try mise/asdf-managed nvim first, then fall back to system PATH.
    nvim_path = None
    mise_path = which("mise")
    if mise_path:
        import subprocess
        try:
            result = subprocess.run(
                [mise_path, "which", "nvim"],
                capture_output=True, text=True, timeout=5,
            )
            if result.returncode == 0 and result.stdout.strip():
                nvim_path = result.stdout.strip()
        except Exception:
            pass
    if not nvim_path:
        nvim_path = which("nvim")
    if not nvim_path:
        boss.show_error("kitty_scrollback", "Cannot find nvim in PATH")
        return

    # Gather colors directly from kitty's API (avoids deadlock from subprocess)
    opts = get_options()
    color_dict = {
        k: getattr(opts, k) for k in opts if isinstance(getattr(opts, k), Color)
    }
    for k, v in w.current_colors.items():
        if v is None:
            color_dict.pop(k, None)
        elif isinstance(v, int):
            color_dict[k] = color_from_int(v)
    kitty_colors = {k: color_as_sharp(v) for k, v in color_dict.items()}

    screen = w.screen
    metadata = {
        "nvim_path_used": nvim_path,
        "kitty_path": kitty_path,
        "scrolled_by": screen.scrolled_by,
        "cursor_x": screen.cursor.x + 1,
        "cursor_y": screen.cursor.y + 1,
        "lines": screen.lines + 1,
        "columns": screen.columns,
        "window_id": target_window_id,
        "colors": kitty_colors,
    }

    text = w.as_text(as_ansi=True, add_history=True, add_wrap_markers=True)

    # Split on \r\n (real newlines). Remaining \r within a row = soft wraps to rejoin.
    raw_rows = text.split("\r\n")
    if raw_rows and raw_rows[-1] == "":
        raw_rows.pop()

    # Single forward pass: rejoin soft-wrapped sub-rows, track count per line.
    strip_ansi = re.compile(r"\x1b\[[^A-Za-z]*[A-Za-z]|\x1b\].*?(?:\x07|\x1b\\)").sub
    result_lines = []
    sub_row_counts = []
    for raw_row in raw_rows:
        sub_rows = raw_row.split("\r")
        if sub_rows and sub_rows[-1] == "":
            sub_rows.pop()
        if not sub_rows:
            sub_rows = [""]
        result_lines.append("".join(sub_rows))
        sub_row_counts.append(len(sub_rows))

    # Backward scan for cursor position (bounded by screen.lines).
    rows_from_end = screen.lines - 1 - screen.cursor.y
    cursor_buf_line = len(result_lines) - 1
    cursor_buf_col = screen.cursor.x + 1
    for i in range(len(sub_row_counts) - 1, -1, -1):
        if rows_from_end < sub_row_counts[i]:
            cursor_buf_line = i
            preceding = sub_row_counts[i] - rows_from_end - 1
            if preceding > 0:
                parts = raw_rows[i].split("\r")
                if parts and parts[-1] == "":
                    parts.pop()
                plain = strip_ansi("", "".join(parts[:preceding]))
                cursor_buf_col = len(plain.encode("utf-8")) + screen.cursor.x + 1
            break
        rows_from_end -= sub_row_counts[i]

    metadata["cursor_buf_line"] = cursor_buf_line + 1
    metadata["cursor_buf_col"] = cursor_buf_col

    text = "\n".join(line + "\x1b[0m" for line in result_lines)

    # Extract images from the graphics manager
    images_meta = []
    grman = screen.grman
    if grman.image_count > 0:
        cell_width, cell_height = cell_size_for_window(w.os_window_id)
        total_rows = sum(sub_row_counts)
        num_cols = screen.columns

        # Build internal_id -> image data by probing client numbers
        # (image_for_client_number is read-only; image_for_client_id has a
        # destructive side effect that creates empty images on miss)
        images_by_internal = {}
        found = 0
        for num in range(0, grman.image_count * 10 + 1):
            if found >= grman.image_count:
                break
            img = grman.image_for_client_number(num)
            if img is not None and img["internal_id"] not in images_by_internal:
                images_by_internal[img["internal_id"]] = img
                found += 1

        if images_by_internal:
            # Get all placements covering the full scrollback
            dx = 2.0 / num_cols
            dy = 2.0 / total_rows
            scrolled_by = max(0, total_rows - screen.lines)
            layers = grman.update_layers(
                scrolled_by, -1.0, 1.0, dx, dy,
                num_cols, total_rows, cell_width, cell_height,
            )
            # Cumulative sub_row_counts for physical-row -> buffer-line mapping
            cumulative = []
            acc = 0
            for c in sub_row_counts:
                acc += c
                cumulative.append(acc)

            tmpdir = tempfile.mkdtemp(prefix="ksb_img_")
            written_pngs = {}

            for placement in layers:
                iid = placement["image_id"]
                img = images_by_internal.get(iid)
                if img is None:
                    continue

                dr = placement["dest_rect"]
                col = round((dr["left"] + 1.0) / dx) + 1
                row_top = round((1.0 - dr["top"]) / dy)
                width_cells = round((dr["right"] - dr["left"]) / dx)
                height_cells = round((dr["top"] - dr["bottom"]) / dy)
                if width_cells <= 0 or height_cells <= 0:
                    continue

                buf_line = bisect.bisect_right(cumulative, row_top) + 1

                if img["width"] > 0 and img["height"] > 0:
                    pixel_w = width_cells * cell_width
                    pixel_h = pixel_w * img["height"] / img["width"]
                    height_cells = max(1, round(pixel_h / cell_height))

                if iid not in written_pngs:
                    is_rgba = len(img["data"]) == img["width"] * img["height"] * 4
                    png = raw_to_png(img["data"], img["width"], img["height"], is_rgba)
                    path = os.path.join(tmpdir, f"img_{iid}.png")
                    with open(path, "wb") as pf:
                        pf.write(png)
                    written_pngs[iid] = path

                images_meta.append({
                    "png_path": written_pngs[iid],
                    "buf_line": buf_line,
                    "buf_col": col,
                    "width": width_cells,
                    "height": height_cells,
                    "zindex": placement["z_index"],
                })

            if not images_meta:
                os.rmdir(tmpdir)
                tmpdir = None
            metadata["image_tmpdir"] = tmpdir

    metadata["images"] = images_meta

    fd, meta_path = tempfile.mkstemp(prefix="ksb_", suffix=".json")
    text_path = meta_path.replace(".json", ".ansi")
    with os.fdopen(fd, "w") as f:
        json.dump({"metadata": metadata, "text_path": text_path}, f)
    with open(text_path, "w") as f:
        f.write(text)

    lua_cmd = (
        " lua"
        " vim.opt.runtimepath:append(vim.fn.expand('~/.config/kitty'))"
        f" require('scrollback').launch([[{meta_path}]])"
    )

    cmd = (
        "launch",
        "--copy-env",
        "--type",
        "overlay",
        "--title",
        "kitty-scrollback",
        nvim_path,
        "--clean",
        "--noplugin",
        "-n",
        "-c",
        "let g:mapleader = ','",
        "--cmd",
        lua_cmd,
    )
    boss.call_remote_control(w, cmd)
