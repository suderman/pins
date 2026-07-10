{
  flake,
  pkgs,
  ...
}:
pkgs.callPackage ../builders/github-source.nix {
  pin = flake.pins.github.honcho;
}
