{
  description = "Manually tracked upstream pins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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

    forAllSystems = lib.genAttrs systems;

    pkgsFor = system:
      import inputs.nixpkgs {
        inherit system;
      };

    formatterFor = pkgs: let
      treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
      treefmtEval.config.build.wrapper;
  in {
    default = pins;
    inherit pins;

    formatter = forAllSystems (system: formatterFor (pkgsFor system));

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
      formatter = formatterFor pkgs;
      devshell = inputs.devshell.legacyPackages.${system};
    in {
      default = import ./devshell.nix {
        inherit devshell formatter pkgs;
      };
    });
  };
}
