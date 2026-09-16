{
  honcho = {
    owner = "plastic-labs";
    repo = "honcho";
    rev = "v3.1.2";
    hash = "sha256-Ee278E3N1zw8jJ0DvM5LAh6LtkgIgvpn7Mb6+7+ENjA=";
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
    rev = "v2.5.0";
    hash = "sha256-NGJorciTzbmUL8UOtd41ZtXjKbaPKWKHJNOGJxWlSJ0=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:aa9dcc5bbb4aaa11568c3fcede037ed9629c35fed211cb299bbb7af8f37b4cac";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:9a65feba6843248df95e5cfff1eaf77e7152f5380f44d0ea071c84c9272e5aa6";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:137e6a5ab72caa39e5c0d28f046c2a87b15ca974e0148a31dfb552d3c74d3dbe";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:37769f7286aa4dab42ab83c2b09846a4b4c92804a6e25a7ebd1fffd1d750c8bd";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:78bf48b801e792f99e3ac62b5036fd3876e9be48afda16c1e331af1c75ceb2ff";
    redisImage = "redis:alpine@sha256:becdda6c7f4b3fb42e42fd7f120bbf5c54c4caaaf16f26da24e4563d2c1f0576";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:c8497b180665e631ec92a5091125bec5b214f0e2b99409e30653a125b37557da";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
