{
  flake,
  pkgs,
  ...
}: let
  buildFirefoxXpiAddon = pkgs.callPackage ../builders/build-firefox-xpi-addon.nix {};
in
  pkgs.callPackage ../builders/easy-container-shortcuts.nix {
    inherit buildFirefoxXpiAddon;
    pin = flake.lib.pins.firefox.easy-container-shortcuts;
  }
