{
  camofox-browser = {
    version = "2.4.8";
    owner = "redf0x1";
    repo = "camofox-browser";
    rev = "v2.4.8";
    hash = "sha256-fKg/s3cruPpfr3j1Muv/XAT4zLzHlRGw9s3ttGNQRTY=";
    npmDepsHash = "sha256-Ugss4pzQOdYBipF6I6+qcFeemMVn0vrdNzSjuq+Zfgo=";
    upstream = "https://github.com/redf0x1/camofox-browser/releases";
    updatePolicy = "Report only. Test the server lockfile and Camoufox engine together before updating.";
  };

  honcho = {
    owner = "plastic-labs";
    repo = "honcho";
    rev = "v3.4.0";
    hash = "sha256-pTYjdm+ke5ELSlCiQsvFiV55GWrALRDN1tWT7eT7vek=";
    upstream = "https://github.com/plastic-labs/honcho/releases";
    updatePolicy = "Track tagged releases, not branch heads.";
  };

  mpd-url = {
    owner = "suderman";
    repo = "mpd-url";
    rev = "09200dd2dbc3d51312cbf5881efc00678dce9a11";
    hash = "sha256-Wcl+wenrdkGOcjwFEmhCIVHIoZs97oMOrJzP1fbxtUE=";
    upstream = "https://github.com/suderman/mpd-url";
    updatePolicy = "Track the default branch only when that is intentional for this script.";
  };

  nojoin = {
    owner = "Valtora";
    repo = "Nojoin";
    rev = "v2.10.0";
    hash = "sha256-/l+tJENnkcBL1d4n+5QdixCsA1/2LpFL+ipQJMYwTlE=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:bb9d0be068c5475f3ebff808d6e1d5c5fd21a5b8b3e2aa7b04ebe9405aa8495e";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:e369ce7a0588245c1bdc29ca21f296667282aa3560a28b20f51a0c602bc0b7dd";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:e64bf339cc33fcd669092b4d3f8c6e8e121fb3159525518111d991ea94426267";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:726fab295821292c8dae634cbe1c4bd8b1280955fec1a175452d5cccfb77bb3e";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:9d9c930220cb9bf2f956d10a8f909cf9973d9672ca0278aef2c1e6facccad2e0";
    redisImage = "redis:alpine@sha256:47b08295737773de3b711fb86f13ae802f5074e96a9a2d29f5f80164ac08c046";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:a3554c0d0b48177b1413c26e01f695334428020d9df01243fbae3e11cfd17417";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
