#!/usr/bin/env python3
"""Check engine release selection and the browser pair's report-only policy."""

import importlib.util
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("update_pins", Path(__file__).with_name("update-pins.py"))
assert spec and spec.loader
updater = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = updater
spec.loader.exec_module(updater)


def release(version, *, draft=False, arch="x86_64"):
    return {
        "tag_name": f"v{version}",
        "draft": draft,
        "prerelease": "beta" in version,
        "assets": [{
            "name": f"camoufox-{version}-lin.{arch}.zip",
            "browser_download_url": f"https://example.com/{version}.zip",
        }],
    }


class BrowserPinsTest(unittest.TestCase):
    def test_beta_releases_are_ordered_numerically_and_require_matching_assets(self):
        releases = [release("152.0.4-beta.9"), release("152.0.4-beta.30"),
                    release("156.0.1-beta.32"), release("157.0.0-beta.1", draft=True),
                    release("158.0.0-beta.1", arch="aarch64")]
        with patch.object(updater, "http_json", return_value=releases):
            candidate = updater.camoufox_release_candidate()
        self.assertEqual(candidate.value, "156.0.1-beta.32")
        self.assertEqual(candidate.fields["url"], "https://example.com/156.0.1-beta.32.zip")
        with patch.object(updater, "http_json", return_value=[release("156.0.1-beta.32"), release("156.0.1")]):
            self.assertEqual(updater.camoufox_release_candidate().value, "156.0.1")

    def test_neither_browser_pin_can_be_applied_even_with_reviewed_flag(self):
        entries = updater.select_entries(["camofox-browser", "camoufox"])
        pins = {entry.group: {entry.pin_name: {entry.value_field: "1.0.0"}} for entry in entries}
        self.assertTrue(all(entry.policy == "report" for entry in entries))
        with patch.object(updater, "find_candidate", return_value=updater.Candidate(value="2.0.0")), \
             patch.object(updater, "replace_pin_fields") as replace:
            results = updater.apply_entries(entries, pins, reviewed=True, selected=True)
        self.assertTrue(all(result.action == "skipped-report-only" for result in results))
        replace.assert_not_called()


if __name__ == "__main__":
    unittest.main()
