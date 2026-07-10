{
  fetchurl,
  lib,
  stdenvNoCC,
  pin,
}: let
  src = fetchurl {
    inherit (pin) url sha256;
  };
in
  stdenvNoCC.mkDerivation {
    inherit (pin) pname version;
    inherit src;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      printf '%s\n' "$src" > $out/path

      runHook postInstall
    '';

    passthru = {
      inherit src;
      inherit (pin) upstream url;
    };

    meta = {
      inherit (pin) description;
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
