# suderpkgs

Personal Nix packages and manually tracked upstream pins that do not fit well
as separate flake inputs.

This repo is intentionally small. Service policy stays in the consuming NixOS
flake; this flake only carries reusable package definitions and centralized
release metadata.

This flake uses `numtide/blueprint` for output mapping and `treefmt-nix` for
formatting. Package output wrappers live in `packages/`; shared implementation
files live in `builders/`.

## Outputs

- `packages.${system}.easy-container-shortcuts`
- `packages.${system}.honcho-src`
- `packages.${system}.mpd-url`
- `packages.x86_64-linux.citron`
- `packages.x86_64-linux.eden`
- `lib.pins.containers`
- `lib.pins.fetchurl`
- `lib.pins.firefox`
- `lib.pins.github`
- `lib.pins.chromium`
- `overlays.default`

## Consuming

Add this flake once:

```nix
{
  inputs.suderpkgs = {
    url = "github:suderman/suderpkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Use package outputs directly from modules that already receive `flake`:

```nix
flake.inputs.suderpkgs.packages.${pkgs.system}.honcho-src
```

Use centralized image/tag metadata without importing a package set:

```nix
flake.inputs.suderpkgs.lib.pins.containers.home-assistant.image
flake.inputs.suderpkgs.lib.pins.containers.immich.serverImage
flake.inputs.suderpkgs.lib.pins.containers.whoami.image
flake.inputs.suderpkgs.lib.pins.containers.zwave-js-ui.version
```

Use pinned GitHub source metadata for non-container services like Honcho:

```nix
flake.inputs.suderpkgs.packages.${pkgs.system}.honcho-src
flake.inputs.suderpkgs.lib.pins.github.honcho.rev
```

Or install the overlay and use:

```nix
pkgs.suderpkgs.mpd-url
pkgs.suderPins.containers.codex-lb.image
```

## Pin Policy

Current versions live in `pins/*.nix`. Do not duplicate current values in prose
unless there is a strong reason; prose drifts faster than Nix data.

The `.opencode/skills/update-dependencies/references.md` file documents how to
check each upstream, what counts as an acceptable update, and how to validate a
change.

For scheduled maintenance, check every entry under the registry's container tag
section against its upstream URL/API. Update only specific tags, not floating
tags such as `latest`.

## Validation

```sh
nix flake check --all-systems --no-build
nix build .#mpd-url
nix eval .#lib.pins.containers.home-assistant.image
```
