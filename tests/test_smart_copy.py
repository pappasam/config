from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path
from types import ModuleType


def load_smart_copy() -> ModuleType:
    path = (
        Path(__file__).parents[1] / "dotfiles" / ".config" / "kitty" / "smart-copy.py"
    )
    spec = importlib.util.spec_from_file_location("smart_copy", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


smart_copy = load_smart_copy()


class SmartUnwrapTests(unittest.TestCase):
    def assert_preserved(self, text: str, columns: int = 40) -> None:
        self.assertEqual(smart_copy.smart_unwrap(text, columns), text)

    def test_joins_hard_wrapped_prose(self) -> None:
        text = """This sentence was deliberately rendered
across two hard lines by an application."""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 40),
            "This sentence was deliberately rendered across two hard lines by an application.",
        )

    def test_joins_prose_wrapped_below_twenty_four_columns(self) -> None:
        text = """This prose was
wrapped inside a
very narrow pane."""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 20),
            "This prose was wrapped inside a very narrow pane.",
        )

    def test_joins_a_single_word_at_the_end_of_prose(self) -> None:
        text = """A prose line can wrap with just one
word"""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 40),
            "A prose line can wrap with just one word",
        )

    def test_joins_prose_continuation_beginning_with_with(self) -> None:
        text = """  The PROCESSOR column should show mostly or entirely GPU. If it reports CPU, the model will still run
  with your 12-core processor, but much more slowly. All these local variants are free to run; electricity
  is the only ongoing cost."""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 160),
            "  The PROCESSOR column should show mostly or entirely GPU. If it reports CPU, the model will still run with your 12-core processor, but much more slowly. All these local variants are free to run; electricity is the only ongoing cost.",
        )

    def test_preserves_python_with_statement(self) -> None:
        self.assert_preserved(
            'with open("first.txt") as first:\n    contents = first.read()'
        )

    def test_preserves_short_single_value_lines(self) -> None:
        self.assert_preserved(
            """hello
world
yolo
sabe

the above words are super cool"""
        )

    def test_joins_wrapped_unicode_bullets_but_preserves_items(self) -> None:
        text = """• This first bullet was deliberately wrapped
  onto another application-rendered line.
• This is a separate bullet."""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 40),
            """• This first bullet was deliberately wrapped onto another application-rendered line.
• This is a separate bullet.""",
        )

    def test_preserves_long_single_value_lines(self) -> None:
        self.assert_preserved(
            """this-is-a-deliberately-long-value
another-deliberately-long-value
third-deliberately-long-value"""
        )

    def test_preserves_filenames_paths_and_hashes(self) -> None:
        self.assert_preserved(
            """src/components/deliberately-long-component.tsx
src/components/another-deliberately-long-component.tsx
4a44dc15364204a80fe80e9039455cc1608281820fe2b24c11c24b8917ae17de
f5ca38f748a1d6e4af726b8a42fb575c3c71b24b3788fca7d4e7561d34cfd223"""
        )

    def test_preserves_urls(self) -> None:
        self.assert_preserved(
            """https://example.com/one/long/resource
https://example.com/two/long/resource"""
        )

    def test_preserves_repeated_commands(self) -> None:
        self.assert_preserved(
            """ollama pull qwen3.6:35b-a3b
ollama pull qwen3.6:35b-a3b-coding
ollama pull qwen3.6:27b
ollama pull qwen3.5:9b
ollama pull gpt-oss:20b"""
        )

    def test_preserves_the_full_ollama_clipboard_sample(self) -> None:
        self.assert_preserved(
            """• Start Ollama, then download all five models:

  sudo systemctl enable --now ollama

  ollama pull qwen3.6:35b-a3b
  ollama pull qwen3.6:35b-a3b-coding
  ollama pull qwen3.6:27b
  ollama pull qwen3.5:9b
  ollama pull gpt-oss:20b

  Confirm installation:

  ollama list

  Run any model with:

  ollama run qwen3.6:35b-a3b

  Expect roughly 85 GB of downloads before any shared-layer savings."""
        )

    def test_preserves_commands_with_different_prefixes(self) -> None:
        self.assert_preserved(
            """docker build --tag example-image .
kubectl apply --filename deployment.yaml"""
        )

    def test_repeated_prose_prefix_is_not_a_command(self) -> None:
        text = """there are many ways to configure this
there are also several important options"""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 40),
            "there are many ways to configure this there are also several important options",
        )

    def test_command_names_used_as_prose_still_join(self) -> None:
        cases = {
            "make sure the configuration is valid\nbefore restarting the application": (
                "make sure the configuration is valid before restarting the application"
            ),
            "find the relevant file in the project\nand inspect its current contents": (
                "find the relevant file in the project and inspect its current contents"
            ),
            "go to the project directory first\nand then inspect the configuration": (
                "go to the project directory first and then inspect the configuration"
            ),
        }
        for text, expected in cases.items():
            with self.subTest(text=text):
                self.assertEqual(smart_copy.smart_unwrap(text, 40), expected)

    def test_preserves_tab_and_space_aligned_tables(self) -> None:
        self.assert_preserved("NAME\tSTATUS\nalpha\trunning")
        self.assert_preserved("NAME       STATUS\nalpha      running")
        self.assert_preserved(
            """NAME STATUS RESTARTS AGE
api-server Running 0 4d
worker Pending 3 2h"""
        )

    def test_uppercase_heading_does_not_turn_prose_into_a_table(self) -> None:
        text = """IMPORTANT INFORMATION
This paragraph was deliberately rendered
across two hard lines by an application."""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 40),
            """IMPORTANT INFORMATION
This paragraph was deliberately rendered across two hard lines by an application.""",
        )

    def test_preserves_yaml_and_environment_assignments(self) -> None:
        self.assert_preserved("host: localhost\nport: 5432")
        self.assert_preserved("APP_ENV=production\nDEBUG=false")

    def test_preserves_all_lines_inside_fenced_code(self) -> None:
        self.assert_preserved(
            """```text
this is deliberately a long otherwise-prose-looking code line
this is another long otherwise-prose-looking code line
```"""
        )

    def test_preserves_likely_verse(self) -> None:
        self.assert_preserved(
            """I wandered lonely as a cloud,
That floats on high o'er vales and hills,
When all at once I saw a crowd,""",
            columns=100,
        )
        self.assert_preserved(
            """roses are red
violets are blue
sugar is sweet
and so are you""",
            columns=80,
        )

    def test_preserves_shared_indentation(self) -> None:
        text = """    This indented prose was deliberately
    wrapped across two application lines."""
        self.assertEqual(
            smart_copy.smart_unwrap(text, 40),
            "    This indented prose was deliberately wrapped across two application lines.",
        )


if __name__ == "__main__":
    unittest.main()
