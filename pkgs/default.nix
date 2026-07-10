{
  pkgs,
  pins,
}: let
  callPackage = pkgs.callPackage;
  buildFirefoxXpiAddon = callPackage ./build-firefox-xpi-addon.nix {};
in
  {
    easy-container-shortcuts = callPackage ./easy-container-shortcuts.nix {
      inherit buildFirefoxXpiAddon;
      pin = pins.firefox.easy-container-shortcuts;
    };

    honcho-src = callPackage ./github-source.nix {
      pin = pins.github.honcho;
    };

    mpd-url = callPackage ./mpd-url.nix {
      pin = pins.github.mpd-url;
    };
  }
  // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
    citron = callPackage ./appimage-path.nix {
      pin = pins.fetchurl.citron;
    };

    eden = callPackage ./appimage-path.nix {
      pin = pins.fetchurl.eden;
    };
  }
