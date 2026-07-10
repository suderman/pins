{
  fetchurl,
  lib,
  stdenv,
}: {
  pname,
  version,
  addonId,
  url,
  sha256,
  meta ? {},
  ...
}:
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {inherit url sha256;};

  preferLocalBuild = true;
  allowSubstitutes = true;

  passthru = {inherit addonId;};

  buildCommand = ''
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$dst"
    install -v -m644 "$src" "$dst/${pname}@extraAddons.xpi"
  '';

  meta =
    {
      platforms = lib.platforms.all;
    }
    // meta;
}
