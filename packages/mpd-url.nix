{
  flake,
  pkgs,
  ...
}:
pkgs.callPackage ../builders/mpd-url.nix {
  pin = flake.lib.pins.github.mpd-url;
}
