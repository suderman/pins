# pins

Manually tracked upstream pins that do not fit well as separate flake inputs.

This repo is intentionally small. Service policy stays in the consuming NixOS
flake; package wrappers stay there too. This flake carries centralized release
metadata and update automation.

This flake uses `treefmt-nix` for formatting and a small development shell for
pin maintenance commands.

## Outputs

- `default.containers`
- `default.fetchurl`
- `default.firefox`
- `default.github`
- `default.chromium`
- `pins.*` as an explicit alias for `default`
- `devShells.${system}.default`
- `formatter.${system}`

## Consuming

Add this flake once:

```nix
{
  inputs.pins = {
    url = "github:suderman/pins";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Use centralized image/tag metadata without importing a package set:

```nix
flake.inputs.pins.default.containers.home-assistant.image
flake.inputs.pins.default.containers.immich.serverImage
flake.inputs.pins.default.containers.whoami.image
flake.inputs.pins.default.containers.zwave-js-ui.version
```

Use pinned source metadata for local package wrappers in the consuming flake:

```nix
flake.inputs.pins.default.github.honcho.rev
flake.inputs.pins.default.github.honcho.hash
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

GitHub Actions scheduled maintenance uses `.github/workflows/update-pins.yml`.
Configure the `MINIMAX_API_KEY` repository secret before enabling it. The
workflow installs `@earendil-works/pi-coding-agent`, runs
`tools/update-with-agent-ci.sh`, validates the result, refuses non-`pins/*.nix`
changes, then commits and pushes validated pin updates with `GITHUB_TOKEN`.

## Validation

```sh
nix flake check --all-systems --no-build
nix eval .#default.containers.home-assistant.image
```
