# suderman/pins 📌

A curated pinboard for upstream versions that need judgment, policy, or metadata beyond `flake.lock`

## Outputs

- `default`: the pin registry
- `pins`: alias for `default`
- `devShells.${system}.default`: maintenance shell
- `formatter.${system}`

Pin groups currently include `containers`, `fetchurl`, `firefox`, `github`, and `chromium`.

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

Read pin metadata directly from default:

```nix
flake.inputs.pins.default.containers.home-assistant.image
flake.inputs.pins.default.containers.immich.serverImage
flake.inputs.pins.default.github.honcho.rev
flake.inputs.pins.default.github.honcho.hash
```

Package wrappers, service policy, and host-specific decisions stay in the consuming flake.

## Pin Policy

Current values live in `pins/*.nix`; prose should describe policy, not repeat versions.

`AGENTS.md` documents each pin’s upstream source, update policy, hash refresh rule, and validation command. Scheduled maintenance updates only explicit versions, tags, URLs, revisions, and hashes. Floating tags such as `latest` are avoided unless a registry entry explicitly allows them.

## Updating

Enter the shell with `direnv allow` or `nix develop`. 

- `pins-check`
- `pins-report`
- `pins-apply-safe`
- `pins-validate`

Use `pins-check` for a concise read-only upstream check, `pins-report` for Markdown, and `--format json` when full upstream error details are needed.

Apply safe deterministic updates, validate, commit, and push:

```sh
pins-apply-safe
```

GitHub Actions runs `.github/workflows/update-pins.yml` on schedule. It requires `MINIMAX_API_KEY`, runs `tools/update-with-agent-ci.sh`, validates the diff, refuses `non-pins/*.nix` changes, then commits and pushes with `GITHUB_TOKEN`.

## Validation

```sh
nix flake check --all-systems --no-build
nix eval .#default.containers.home-assistant.image
```
