{
  buildFirefoxXpiAddon,
  lib,
  pin,
}:
buildFirefoxXpiAddon {
  inherit (pin) pname version addonId url sha256;

  meta = {
    description = "Easy, opinionated keyboard shortcuts for Firefox containers";
    license = lib.licenses.bsd2;
    mozPermissions = [
      "tabs"
      "contextualIdentities"
      "cookies"
    ];
    platforms = lib.platforms.all;
  };
}
