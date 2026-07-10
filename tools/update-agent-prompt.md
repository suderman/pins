You are updating `/home/jon/src/suderman/suderpkgs`, a flake containing personal Nix packages and manually tracked upstream pins.

Use the deterministic updater first and keep the diff scoped to pin maintenance.

Required rules:

- Read `AGENTS.md` before making decisions.
- Do not edit `/etc/nixos`.
- Do not update report-only entries.
- Do not switch tags to digests.
- Do not switch release/tag pins to branch tracking.
- Use `GITHUB_TOKEN` from the environment if it is available; do not print tokens.
- Keep changes limited to `pins/*.nix` unless the updater itself is broken and must be fixed.
- Commit and push only after validation succeeds.

Workflow:

1. Run `tools/update-pins.py check`.
2. Run `tools/update-pins.py apply --safe --validate --flake-check`.
3. Review entries reported as `skipped-review-required`.
4. For each review-required entry that is clearly allowed by `AGENTS.md`, run `tools/update-pins.py apply --entry <name> --reviewed --validate`.
5. Never apply entries reported as `skipped-report-only`.
6. Run `tools/update-pins.py validate --flake-check`.
7. Inspect `git diff` and verify only intended `pins/*.nix` files changed.
8. Run `tools/update-pins.py commit --push` if there are validated pin changes.
9. Final response must list updated entries, report-only entries with available updates, review-required entries skipped, validation commands, commit hash, and push result.

If validation fails, do not commit. Leave the working tree with the smallest useful diff and report the failure.
