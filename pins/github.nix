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
    rev = "v3.6.1";
    hash = "sha256-prbjOEN5jWUEzjPHxjs4ELtaMGU1BRk3h4dII1GQqf4=";
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
    rev = "v3.1.0";
    hash = "sha256-shi0rBJbVkaaR8/lErQi1A7UL7ufKfl24dC0WmQP5qw=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:596e39764e7edd1a6151159c51ecab1dd01a54edf45deeadab8cb682b31e7661";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:43a49fe3803815c087956b927f0030c70f81fbb3687abfeba00aff5123462575";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:9272e47f523909dd5e0af8b18da2e2e15e88d4ecf1742ba86434707900e9fd52";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:98740b73a901ad09ed13d133cb33565f41434ff6ddecf7db2e5f67a081e77e87";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:ab49524d18df7200b74ac9a475e1db6297fc1eb57da4c214c63d10ecc4b754fa";
    redisImage = "redis:alpine@sha256:7958cfbb9d152f87dadfbc89f1b0b15938f0b81ff8982feb327476f4911935c3";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:713fc2ebfd92e8217db451477182ee91944b123d2b1ee9fd5a8c6e91ca6c3a11";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
