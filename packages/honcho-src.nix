{
  flake,
  pkgs,
  ...
}:
pkgs.callPackage ../builders/github-source.nix {
  pin = flake.lib.pins.github.honcho;
}
