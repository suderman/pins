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
    rev = "v3.3.0";
    hash = "sha256-Ec6qswT0bSD0VsghRoixwT5rD+MoTeFTeRnfGjEXF+o=";
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
    rev = "v2.9.0";
    hash = "sha256-7iXeV2HAyvAcuFfVEGpmpRq9LnF3ic9C7pVSBr6D8rY=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:20054622dcf7c65ae40358cd5f4554b7a56bc18a205a1315d8ec9c8fd6dbd6cd";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:0a9abcb52916b5bc6755903017c223fac0c4b82c0105d21bc1db0ba322ff6438";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:69cbff52d8853f454dfa57c7a147e829b44613449899319563341436e5ffcd1d";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:1ccfc05678b1ad4275cf4f9c51b5e789d7973dbeaee8183cf1224e6d3c3253e7";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:9d9c930220cb9bf2f956d10a8f909cf9973d9672ca0278aef2c1e6facccad2e0";
    redisImage = "redis:alpine@sha256:3811787313eba226a2ef38658c6ccb91cd5e110edc89c37767de373120a0e5a0";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:892bb2152464f0c5d8972593a5f5afaf8054552580b699d95f8ff4af08c2d33d";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
