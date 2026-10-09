"""Regression checks for missing apps, installation variants, and profile selection."""

import importlib.util
from itertools import combinations
from pathlib import Path
import unittest


spec = importlib.util.spec_from_file_location("shortcuts", Path(__file__).with_name("gnome-app-shortcuts.py"))
shortcuts = importlib.util.module_from_spec(spec)
spec.loader.exec_module(shortcuts)

FIREFOX = "firefox.desktop"
SLACK = "slack.desktop"
KITTY = "kitty.desktop"
MEET = "chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-Profile_6.desktop"
FILES = "org.gnome.Nautilus.desktop"


class ShortcutPlanTests(unittest.TestCase):
    def test_missing_apps_never_redirect_shortcuts_to_files(self):
        apps = [FIREFOX, SLACK, KITTY, MEET]
        expected_keys = dict(zip(apps, "bsim"))
        for count in range(5):
            for available in combinations(apps, count):
                with self.subTest(available=available):
                    selected, favorites, bindings = shortcuts.make_plan(
                        {*available, FILES}, apps + [FILES], {}
                    )
                    self.assertEqual(favorites, list(available) + [FILES])
                    self.assertEqual(len(bindings), len(available))
                    for slot, binding in bindings.items():
                        target = favorites[slot - 1]
                        self.assertIn(target, available)
                        self.assertEqual(binding, f"<Control><Alt>{expected_keys[target]}")
                    self.assertEqual(sum(app is not None for app in selected.values()), len(available))

    def test_snap_and_flatpak_launchers(self):
        installed = {"firefox_firefox.desktop", "com.slack.Slack.desktop", KITTY}
        selected, favorites, bindings = shortcuts.make_plan(installed, [FILES], {})
        self.assertEqual(selected["firefox"], "firefox_firefox.desktop")
        self.assertEqual(selected["slack"], "com.slack.Slack.desktop")
        self.assertEqual(favorites[2], KITTY)
        self.assertEqual(bindings[3], "<Control><Alt>i")

    def test_keep_existing_installation_and_other_favorites(self):
        flatpak = "org.mozilla.firefox.desktop"
        _, favorites, _ = shortcuts.make_plan(
            {FIREFOX, flatpak, KITTY, FILES}, [FILES, flatpak, "missing.desktop", FILES], {}
        )
        self.assertEqual(favorites, [flatpak, KITTY, FILES])

    def test_meet_profile_selection(self):
        another = MEET.replace("Profile_6", "Profile_2")
        selected, _, _ = shortcuts.make_plan({another}, [], {})
        self.assertEqual(selected["meet"], another)
        selected, _, _ = shortcuts.make_plan({MEET, another}, [], {})
        self.assertIsNone(selected["meet"])
        selected, _, _ = shortcuts.make_plan({MEET, another}, [another], {})
        self.assertEqual(selected["meet"], another)

    def test_override_and_validation(self):
        custom = "local-browser.desktop"
        selected, _, _ = shortcuts.make_plan({FIREFOX, custom}, [FIREFOX], {"firefox": custom})
        self.assertEqual(selected["firefox"], custom)
        for overrides in ({"firefox": "missing.desktop"}, {"unknown": FIREFOX},
                          {"firefox": []}, {"firefox": FIREFOX, "slack": FIREFOX}):
            with self.subTest(overrides=overrides), self.assertRaises(ValueError):
                shortcuts.make_plan({FIREFOX}, [], overrides)

    def test_rerunning_is_idempotent(self):
        installed = {FIREFOX, KITTY, FILES}
        first = shortcuts.make_plan(installed, [FILES, SLACK, FIREFOX, KITTY], {})
        self.assertEqual(first, shortcuts.make_plan(installed, first[1], {}))


if __name__ == "__main__":
    unittest.main()
