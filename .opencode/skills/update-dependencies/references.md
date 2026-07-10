# Manual Dependency Registry

This file documents how to update each manual dependency in `suderpkgs`.

Current pinned values live in `pins/*.nix`. This registry should describe shape,
policy, hash refresh behavior, and validation without repeating current versions.

## AppImages

### citron

- kind: `fetchurl-release`
- pins: `pins/fetchurl.nix`, `citron`
- package: `pkgs/appimage-path.nix` via `packages.${system}.citron`
- upstream: https://git.citron-emu.org/Citron/Emulator/releases
- update rule: use the latest acceptable Linux AppImage release matching the existing stable Citron filename pattern
- hash rule: after changing `url`, refresh `sha256` for the downloaded AppImage
- validate: `nix build .#citron`

### eden

- kind: `fetchurl-release`
- pins: `pins/fetchurl.nix`, `eden`
- package: `pkgs/appimage-path.nix` via `packages.${system}.eden`
- upstream: https://git.eden-emu.dev/eden-emu/eden/releases
- update rule: use the latest acceptable Linux AppImage release; be explicit before changing RC-versus-stable policy
- hash rule: after changing `url`, refresh `sha256` for the downloaded AppImage
- validate: `nix build .#eden`

## GitHub Sources

### honcho

- kind: `fetch-github-rev`
- pins: `pins/github.nix`, `honcho`
- package: `pkgs/github-source.nix` via `packages.${system}.honcho-src`
- upstream: https://github.com/plastic-labs/honcho/releases
- update rule: use the newest tagged release, not branch head
- hash rule: after changing `rev`, refresh `hash` for the fetched source
- validate: `nix build .#honcho-src`

### mpd-url

- kind: `fetch-github-rev`
- pins: `pins/github.nix`, `mpd-url`
- package: `pkgs/mpd-url.nix` via `packages.${system}.mpd-url`
- upstream: https://github.com/suderman/mpd-url
- update rule: track the latest default-branch commit only while that remains intentional
- hash rule: after changing `rev`, refresh `hash` for the fetched source
- validate: `nix build .#mpd-url`
- notes: branch-based pins are higher risk than tagged releases

## Browser Extensions

### easy-container-shortcuts

- kind: `firefox-xpi`
- pins: `pins/firefox.nix`, `easy-container-shortcuts`
- package: `pkgs/easy-container-shortcuts.nix` via `packages.${system}.easy-container-shortcuts`
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
- validate: `nix eval .#lib.pins.chromium.chromium-web-store.url`

## Container Tags

### backblaze-personal-wine

- kind: `container-tag`
- pins: `pins/containers.nix`, `backblaze-personal-wine`
- upstream: https://hub.docker.com/r/tessypowder/backblaze-personal-wine/tags
- update rule: intentionally conservative; confirm image behavior before jumping far past v1.9
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.backblaze-personal-wine.image`

### codex-lb

- kind: `container-tag`
- pins: `pins/containers.nix`, `codex-lb`
- upstream: https://github.com/Soju06/codex-lb/pkgs/container/codex-lb
- update rule: use the newest tagged container version compatible with the consuming service module
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.codex-lb.image`

### home-assistant

- kind: `container-tag`
- pins: `pins/containers.nix`, `home-assistant`
- upstream: https://github.com/home-assistant/core/pkgs/container/home-assistant/versions?filters%5Bversion_type%5D=tagged
- update rule: use the newest tagged container version matching the consuming repo policy
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.home-assistant.image`

### immich

- kind: `manual-version`
- pins: `pins/containers.nix`, `immich`
- upstream: https://github.com/immich-app/immich/releases
- update rule: use the newest stable tagged release unless prerelease tracking is explicitly requested
- hash rule: no source hash; keep server, machine-learning, and CUDA image refs aligned
- validate: `nix eval .#lib.pins.containers.immich.serverImage`

### rsshub

- kind: `container-tag`
- pins: `pins/containers.nix`, `rsshub`
- upstream: https://hub.docker.com/r/diygod/rsshub/tags
- update rule: keep the `chromium-bundled` flavor unless intentionally changed
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.rsshub.image`

### rsshub-redis

- kind: `container-tag`
- pins: `pins/containers.nix`, `rsshub-redis`
- upstream: https://hub.docker.com/_/redis/tags
- update rule: use a Redis tag compatible with RSSHub; treat major-version changes as higher risk
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.rsshub-redis.image`

### whoogle-search

- kind: `container-tag`
- pins: `pins/containers.nix`, `whoogle-search`
- upstream: https://github.com/benbusby/whoogle-search/releases
- update rule: use the newest tagged release compatible with the consuming service module
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.whoogle-search.image`

### zwave-js-ui

- kind: `container-tag`
- pins: `pins/containers.nix`, `zwave-js-ui`
- upstream: https://github.com/zwave-js/zwave-js-ui/pkgs/container/zwave-js-ui/versions?filters%5Bversion_type%5D=tagged
- update rule: use the newest tagged container version matching the Home Assistant module expectations
- hash rule: no source hash; update tag metadata only unless digest pinning is introduced later
- validate: `nix eval .#lib.pins.containers.zwave-js-ui.image`

## Explicit Non-Tracked Policies

- Unifi remains in the consuming NixOS flake for now and should stay pinned at `7.5` unless explicitly revisited.
