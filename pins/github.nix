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
    rev = "v2.8.0";
    hash = "sha256-Fw+8Wjn4zFzZFn/Xl63boeIVzZ2sCCN+1vKPDwJDXf0=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:8afcd51dd966f18bc9f8da3b78e75c872d58e7dea55257aeb7b83e482f09e0da";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:412dc9917298494cfde3373e48158d00e618251659730f1b8433191911ca366d";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:015cfef5541a456e773b68762da05cca3477e768576bc74fc7259c70c670e118";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:6c43efc675abd1fa4c480a1a48df9d8e3e205e379aedf062def6555464ab749c";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:9d9c930220cb9bf2f956d10a8f909cf9973d9672ca0278aef2c1e6facccad2e0";
    redisImage = "redis:alpine@sha256:3811787313eba226a2ef38658c6ccb91cd5e110edc89c37767de373120a0e5a0";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:df221db836e1754089190208cee7eeda94f233197056426eda74a43ab1abeac2";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
