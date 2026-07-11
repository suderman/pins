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
- `pins.containers`
- `pins.fetchurl`
- `pins.firefox`
- `pins.github`
- `pins.chromium`
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

Use package outputs from Blueprint modules that already receive `perSystem`:

```nix
perSystem.suderpkgs.honcho-src
```

Use centralized image/tag metadata without importing a package set:

```nix
flake.inputs.suderpkgs.pins.containers.home-assistant.image
flake.inputs.suderpkgs.pins.containers.immich.serverImage
flake.inputs.suderpkgs.pins.containers.whoami.image
flake.inputs.suderpkgs.pins.containers.zwave-js-ui.version
```

Use pinned GitHub source metadata for non-container services like Honcho:

```nix
perSystem.suderpkgs.honcho-src
flake.inputs.suderpkgs.pins.github.honcho.rev
```

Or install the overlay and use:

```nix
pkgs.suderpkgs.mpd-url
pkgs.suderPins.containers.codex-lb.image
```

## Pin Policy

Current versions live in `pins/*.nix`. Do not duplicate current values in prose
unless there is a strong reason; prose drifts faster than Nix data.

The root `AGENTS.md` file documents how to check each upstream, what counts as
an acceptable update, and how to validate a change.

For scheduled maintenance, check every entry under the registry's container tag
section against its upstream URL/API. Update only specific tags, not floating
tags such as `latest`.

## Updating Pins

Enter the development shell with `direnv allow` or `nix develop`. It exposes:

- `pins-check`
- `pins-report`
- `pins-apply-safe`
- `pins-validate`
- `pins-agent`
- `pins-agent-ci`

The commands wrap the scripts below and accept the same extra arguments.

Run the deterministic updater to check upstreams without editing files. The
default output is a concise terminal summary:

```sh
tools/update-pins.py check
```

Use `pins-report` or `tools/update-pins.py report` for a Markdown table, and
`--format json` when full upstream error details are needed.

Apply safe deterministic updates, validate, commit, and push:

```sh
tools/update-pins.py apply --safe --validate --flake-check --commit --push
```

Run the agent-supervised workflow for scheduled maintenance:

```sh
tools/update-with-agent.sh
```

The agent wrapper uses the local `pi` coding-agent harness with
`minimax/MiniMax-M3:high`, so it is intended for hosts where those credentials
are already configured.

GitHub Actions scheduled maintenance uses `.github/workflows/update-pins.yml`.
Configure the `MINIMAX_API_KEY` repository secret before enabling it. The
workflow installs `@earendil-works/pi-coding-agent`, runs `pins-agent-ci`,
validates the result, refuses non-`pins/*.nix` changes, then commits and pushes
validated pin updates with `GITHUB_TOKEN`.

## Validation

```sh
nix flake check --all-systems --no-build
nix build .#mpd-url
nix eval .#pins.containers.home-assistant.image
```
