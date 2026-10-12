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
    rev = "v3.2.2";
    hash = "sha256-g7RO8gMNZYSoEyw4Py+ORB/PYibwTIonHghmSO7Ms3c=";
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
    rev = "v2.7.0";
    hash = "sha256-PA3MjP9pjvD6CZoVRbFnJzS3JG8SSR6qoemmcOBoAvA=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:17d3f8b79880e3a4eef1e7ff8630d48dfcff0e3dc13b463f302b1a28a81aa2f0";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:466584f0f52be52cf1f9bb8877e5f5c9a0dd663044d095c5c931c5c4f1e5b849";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:ff512be58a95199cd172beb14a3cdc678804543be6997409de0bf562748318e2";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:703a7bea8ddb9b78bd987e473183a47e7766ba7f625d45f0e14f469dbc7e8557";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:9d9c930220cb9bf2f956d10a8f909cf9973d9672ca0278aef2c1e6facccad2e0";
    redisImage = "redis:alpine@sha256:3811787313eba226a2ef38658c6ccb91cd5e110edc89c37767de373120a0e5a0";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:df221db836e1754089190208cee7eeda94f233197056426eda74a43ab1abeac2";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
