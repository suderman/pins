{
  flake,
  pkgs,
  ...
}:
pkgs.callPackage ../builders/mpd-url.nix {
  pin = flake.pins.github.mpd-url;
}
