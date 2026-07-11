{
  description = "Manually tracked upstream pins";

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
    pins = import ./pins;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    blueprint = inputs.blueprint {
      inherit inputs systems;
    };
  in {
    inherit pins;
    inherit (blueprint) devShells formatter;
  };
}
