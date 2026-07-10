# Agent Instructions

## Repo Purpose

This repository is focused on maintaining personal Nix packages and manually
tracked upstream pins that do not fit well as separate flake inputs.

Service policy stays in the consuming NixOS flake. This flake carries reusable
package definitions and centralized release metadata.

## Dependency Update Workflow

Update dependencies in this flake that are intentionally tracked outside a
normal `flake.lock` input.

Examples include:

- `pins/containers.nix` image tags
- `pins/fetchurl.nix` AppImage URLs and hashes
- `pins/github.nix` `fetchFromGitHub` revisions and hashes
- `pins/firefox.nix` XPI URLs and hashes
- `pins/chromium.nix` CRX release URLs

## Required Registry

Before editing dependency pins, read the matching entry in the Manual Dependency
Registry section below.

Treat the registry as the source of truth for dependency shape, upstream lookup
URL, update policy, hash refresh method, and validation target. Treat
`pins/*.nix` as the source of truth for current pinned values.

If the registry and Nix files disagree about current values, trust the Nix files
and update the registry notes only if the dependency shape changed.

## Workflow

1. Identify the dependency or dependency family in scope.
2. Read the matching entry in the Manual Dependency Registry section.
3. Read the relevant `pins/*.nix`, `packages/*.nix`, and `builders/*.nix` files.
4. Check upstream according to the documented update rule.
5. Update the smallest coherent set of fields: version/tag/rev, URL/image, and hash.
6. Run the lightest useful validation command from the registry.
7. Report old and new values, refreshed hashes, validation, and skipped entries.

## Scheduled Container Checks

For scheduled maintenance, enumerate every entry under `## Container Tags`, then
compare its current value in `pins/containers.nix` with the newest acceptable
upstream tag.

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
- Do not duplicate current versions in this file; keep current values in `pins/*.nix`.

## Useful Validation

```sh
nix flake check
nix build .#mpd-url
nix build .#honcho-src
nix eval .#pins.containers.home-assistant.image
nix eval .#pins.containers.whoami.image
```

# Manual Dependency Registry

This section documents how to update each manual dependency in `suderpkgs`.

Current pinned values live in `pins/*.nix`. This registry should describe shape,
policy, hash refresh behavior, and validation without repeating current versions.

## AppImages

### citron

- kind: `fetchurl-release`
- pins: `pins/fetchurl.nix`, `citron`
- package: `packages/citron.nix` using `builders/appimage-path.nix` via `packages.${system}.citron`
- upstream: https://github.com/citron-neo/CI/releases
- update rule: use the latest acceptable Linux AppImage from the `nightly-linux` release; preserve the existing `_v3` CPU baseline unless intentionally changed
- hash rule: after changing `url`, refresh `sha256` for the downloaded AppImage
- validate: `nix build .#citron`

### eden

- kind: `fetchurl-release`
- pins: `pins/fetchurl.nix`, `eden`
- package: `packages/eden.nix` using `builders/appimage-path.nix` via `packages.${system}.eden`
- upstream: https://git.eden-emu.dev/eden-emu/eden/releases
- update rule: use the latest acceptable Linux AppImage release; be explicit before changing RC-versus-stable policy
- hash rule: after changing `url`, refresh `sha256` for the downloaded AppImage
- validate: `nix build .#eden`

## GitHub Sources

### honcho

- kind: `fetch-github-rev`
- pins: `pins/github.nix`, `honcho`
- package: `packages/honcho-src.nix` using `builders/github-source.nix` via `packages.${system}.honcho-src`
- upstream: https://github.com/plastic-labs/honcho/releases
- update rule: use the newest tagged release, not branch head
- hash rule: after changing `rev`, refresh `hash` for the fetched source
- validate: `nix build .#honcho-src`

### mpd-url

- kind: `fetch-github-rev`
- pins: `pins/github.nix`, `mpd-url`
- package: `packages/mpd-url.nix` using `builders/mpd-url.nix` via `packages.${system}.mpd-url`
- upstream: https://github.com/suderman/mpd-url
- update rule: track the latest default-branch commit only while that remains intentional
- hash rule: after changing `rev`, refresh `hash` for the fetched source
- validate: `nix build .#mpd-url`
- notes: branch-based pins are higher risk than tagged releases

## Browser Extensions

### easy-container-shortcuts

- kind: `firefox-xpi`
- pins: `pins/firefox.nix`, `easy-container-shortcuts`
- package: `packages/easy-container-shortcuts.nix` using `builders/easy-container-shortcuts.nix` via `packages.${system}.easy-container-shortcuts`
- upstream: https://addons.mozilla.org/en-US/firefox/addon/easy-container-shortcuts/
- update rule: use the newest stable addon release matching the existing XPI download pattern
- hash rule: after changing `url`, refresh `sha256` for the downloaded XPI
- validate: `nix build .#easy-container-shortcuts`
- notes: keep `addonId` unchanged unless upstream identity changed

### chromium-web-store

- kind: `manual-version`
- pins: `pins/chromium.nix`, `chromium-web-store`
- upstream: https://github.com/NeverDecaf/chromium-web-store/releases
- update rule: use the newest stable CRX release URL preserving the existing download pattern
- hash rule: no inline source hash; update only `version` or `url` unless pinning changes later
- validate: `nix eval .#pins.chromium.chromium-web-store.url`

## Container Tags

Scheduled checks should inspect every entry in this section. For Docker Hub, the
API endpoint is `https://hub.docker.com/v2/repositories/<namespace>/<repository>/tags?page_size=25`.
For GHCR package pages, use the linked package versions page or GitHub API.
Ignore floating tags such as `latest` unless the entry explicitly tracks one.

### backblaze-personal-wine

- kind: `container-tag`
- pins: `pins/containers.nix`, `backblaze-personal-wine`
- upstream: https://hub.docker.com/r/tessypowder/backblaze-personal-wine/tags
- update rule: intentionally conservative; confirm image behavior before jumping far past v1.9
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.backblaze-personal-wine.image`

### codex-lb

- kind: `container-tag`
- pins: `pins/containers.nix`, `codex-lb`
- upstream: https://github.com/Soju06/codex-lb/pkgs/container/codex-lb
- update rule: use the newest tagged container version compatible with the consuming service module
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.codex-lb.image`

### home-assistant

- kind: `container-tag`
- pins: `pins/containers.nix`, `home-assistant`
- upstream: https://github.com/home-assistant/core/pkgs/container/home-assistant/versions?filters%5Bversion_type%5D=tagged
- update rule: use the newest tagged container version matching the consuming repo policy
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.home-assistant.image`

### immich

- kind: `manual-version`
- pins: `pins/containers.nix`, `immich`
- upstream: https://github.com/immich-app/immich/releases
- update rule: use the newest stable tagged release unless prerelease tracking is explicitly requested
- hash rule: no source hash; keep server, machine-learning, and CUDA image refs aligned
- validate: `nix eval .#pins.containers.immich.serverImage`

### rsshub

- kind: `container-tag`
- pins: `pins/containers.nix`, `rsshub`
- upstream: https://hub.docker.com/r/diygod/rsshub/tags
- update rule: keep the `chromium-bundled` flavor unless intentionally changed
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.rsshub.image`

### rsshub-redis

- kind: `container-tag`
- pins: `pins/containers.nix`, `rsshub-redis`
- upstream: https://hub.docker.com/_/redis/tags
- update rule: use a Redis tag compatible with RSSHub; treat major-version changes as higher risk
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.rsshub-redis.image`

### unifi

- kind: `container-tag`
- pins: `pins/containers.nix`, `unifi`
- upstream: https://hub.docker.com/r/jacobalberty/unifi/tags
- update rule: intentionally conservative; check and report newer Docker Hub tags, but do not bump from the 7.5 controller line without explicit approval
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.unifi.image`

### whoami

- kind: `container-tag`
- pins: `pins/containers.nix`, `whoami`
- upstream: https://hub.docker.com/r/traefik/whoami/tags
- update rule: use the newest full semver tag; ignore `latest` and arch-specific tags such as `*-amd64`, `*-arm64`, and `*-armv7`
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.whoami.image`

### whoogle-search

- kind: `container-tag`
- pins: `pins/containers.nix`, `whoogle-search`
- upstream: https://github.com/benbusby/whoogle-search/releases
- update rule: use the newest tagged release compatible with the consuming service module
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.whoogle-search.image`

### zwave-js-ui

- kind: `container-tag`
- pins: `pins/containers.nix`, `zwave-js-ui`
- upstream: https://github.com/zwave-js/zwave-js-ui/pkgs/container/zwave-js-ui/versions?filters%5Bversion_type%5D=tagged
- update rule: use the newest tagged container version matching the Home Assistant module expectations
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#pins.containers.zwave-js-ui.image`
