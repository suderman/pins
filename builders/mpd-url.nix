{
  fetchFromGitHub,
  gawk,
  jq,
  lib,
  makeWrapper,
  mpc,
  netcat-gnu,
  stdenvNoCC,
  curl,
  pin,
  yt-dlp,
}:
stdenvNoCC.mkDerivation {
  pname = "mpd-url";
  version = builtins.substring 0 8 pin.rev;

  src = fetchFromGitHub {
    inherit (pin) owner repo rev hash;
  };

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    runHook preInstall

    install -Dm755 mpd-url $out/bin/mpd-url
    wrapProgram $out/bin/mpd-url \
      --prefix PATH : ${lib.makeBinPath [curl gawk jq mpc netcat-gnu yt-dlp]}

    runHook postInstall
  '';

  meta = {
    description = "Add URL streams to MPD using yt-dlp";
    platforms = lib.platforms.linux;
  };
}
