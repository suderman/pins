---
name: update-dependencies
description: Update suderpkgs manual pins, package hashes, container tags, AppImages, GitHub source pins, Firefox XPIs, and Chromium CRX URLs.
compatibility: opencode
metadata:
  audience: maintainers
  repo: suderpkgs
  workflow: dependency-updates
---

## What I do

I update dependencies in this flake that are intentionally tracked outside a
normal `flake.lock` input.

Examples include:

- `pins/containers.nix` image tags
- `pins/fetchurl.nix` AppImage URLs and hashes
- `pins/github.nix` `fetchFromGitHub` revisions and hashes
- `pins/firefox.nix` XPI URLs and hashes
- `pins/chromium.nix` CRX release URLs

## Required Registry

Before editing, read `references.md` in this skill directory.

Treat `references.md` as the registry of dependency shape, upstream lookup URL,
update policy, hash refresh method, and validation target. Treat `pins/*.nix` as
the source of truth for current pinned values.

If the registry and Nix files disagree about current values, trust the Nix files
and update the registry notes only if the dependency shape changed.

## Workflow

1. Identify the dependency or dependency family in scope.
2. Read the matching entry in `references.md`.
3. Read the relevant `pins/*.nix`, `packages/*.nix`, and `builders/*.nix` files.
4. Check upstream according to the documented update rule.
5. Update the smallest coherent set of fields: version/tag/rev, URL/image, and hash.
6. Run the lightest useful validation command from the registry.
7. Report old and new values, refreshed hashes, validation, and skipped entries.

## Scheduled Container Checks

For scheduled maintenance, enumerate every entry under `## Container Tags` in
`references.md`, then compare its current value in `pins/containers.nix` with
the newest acceptable upstream tag.

For Docker Hub entries, prefer the API endpoint shaped like:

```text
https://hub.docker.com/v2/repositories/<namespace>/<repository>/tags?page_size=25
```

For GitHub Container Registry entries, use the package page or GitHub API when
available. Ignore floating tags such as `latest` and architecture-specific tags
unless the registry entry explicitly says otherwise.

Conservative pins should still be checked and reported, but not bumped without
an explicit instruction or an update-policy change.

## Guardrails

- Do not switch a pin from release/tag tracking to branch tracking unless asked.
- Do not switch container tags to digests as part of a routine update.
- Do not update intentionally conservative pins unless the registry says to or the user asks.
- Do not add NixOS service policy here; keep host/service modules in the consuming flake.
- Do not duplicate current versions in `references.md`; keep current values in `pins/*.nix`.

## Useful Validation

```sh
nix flake check
nix build .#mpd-url
nix build .#honcho-src
nix eval .#lib.pins.containers.home-assistant.image
nix eval .#lib.pins.containers.whoami.image
```
