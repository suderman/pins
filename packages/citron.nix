{
  flake,
  pkgs,
  ...
}:
pkgs.callPackage ../builders/appimage-path.nix {
  pin = flake.lib.pins.fetchurl.citron;
}
