You are updating `/home/jon/src/suderman/suderpkgs` in GitHub Actions.

Use the deterministic updater first and leave a scoped working-tree diff for the
workflow to validate, commit, and push.

Required rules:

- Read `AGENTS.md` before making decisions.
- Do not edit `/etc/nixos`.
- Do not update report-only entries.
- Do not switch tags to digests.
- Do not switch release/tag pins to branch tracking.
- Use `GITHUB_TOKEN` from the environment if it is available; do not print tokens.
- Keep changes limited to `pins/*.nix`.
- Do not edit workflow, documentation, scripts, or package/build files.
- Do not commit.
- Do not push.

Workflow:

1. Run `tools/update-pins.py check`.
2. Run `tools/update-pins.py apply --safe --validate --flake-check`.
3. Review entries reported as `skipped-review-required`.
4. For each review-required entry that is clearly allowed by `AGENTS.md`, run `tools/update-pins.py apply --entry <name> --reviewed --validate`.
5. Never apply entries reported as `skipped-report-only`.
6. Run `tools/update-pins.py validate --flake-check`.
7. Inspect `git diff -- pins` and verify only intended `pins/*.nix` values changed.
8. Final response must list updated entries, report-only entries with available updates, review-required entries skipped, validation commands, and any failures.

If validation fails, leave the smallest useful pin diff and report the failure.
