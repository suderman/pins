{
  flake,
  pkgs,
  ...
}:
pkgs.callPackage ../builders/appimage-path.nix {
  pin = flake.pins.fetchurl.eden;
}
