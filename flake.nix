{
  description = "Personal Nix packages and manually tracked upstream pins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = f:
      lib.genAttrs systems (system:
        f (import nixpkgs {
          inherit system;
        }));
  in {
    lib = {
      pins = import ./pins;
    };

    packages = forAllSystems (pkgs:
      import ./pkgs {
        inherit pkgs;
        pins = self.lib.pins;
      });

    checks = forAllSystems (pkgs: self.packages.${pkgs.stdenv.hostPlatform.system});

    formatter = forAllSystems (pkgs:
      pkgs.writeShellApplication {
        name = "suderpkgs-fmt";
        runtimeInputs = [pkgs.alejandra];
        text = ''
          if [ "$#" -eq 0 ]; then
            set -- .
          fi

          alejandra "$@"
        '';
      });

    overlays.default = import ./overlays/default.nix;
  };
}
