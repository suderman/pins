{
  description = "Personal Nix packages and manually tracked upstream pins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Map folder structure to flake outputs.
    # <https://github.com/numtide/blueprint>
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    # Code formatting.
    # <https://github.com/numtide/treefmt-nix>
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Development shell.
    # <https://github.com/numtide/devshell>
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    pins = import ./pins;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    blueprint = inputs.blueprint {
      inherit inputs systems;
    };

    filterPackages = system: packages:
      builtins.removeAttrs (lib.filterAttrs (
          _: package: let
            platforms = package.meta.platforms or [];
          in
            platforms == [] || lib.elem system platforms
        )
        packages) ["formatter"];
  in {
    inherit pins;
    inherit (blueprint) devShells formatter;

    packages = lib.mapAttrs filterPackages blueprint.packages;

    checks =
      lib.mapAttrs (
        _: checks: builtins.removeAttrs checks ["pkgs-formatter"]
      )
      blueprint.checks;

    overlays.default = final: _prev: {
      suderPins = pins;
      suderpkgs = filterPackages final.stdenv.hostPlatform.system (blueprint.mkPackagesFor final);
    };
  };
}
