{
  honcho = {
    owner = "plastic-labs";
    repo = "honcho";
    rev = "v3.2.1";
    hash = "sha256-oPv4/F/CofKUFQ+4Ok0zE2RKLHDjRZx7T9BwdJZKllk=";
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
    rev = "v2.5.1";
    hash = "sha256-L80IZuh19TLt1ZJ8NqHXiPGCGaRbZfLfTfr6fKNdWIQ=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:27c24ab9a7346ebd3a81430477f13e32667fc51abe894fd9d23cb715993eda14";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:5a0cd602032063e0efd1cf1b814b5cf34483d9e1ae3ebd08f9da22fa72daa389";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:f982b51ff3796b7243658796f5c678e5ca1d54ff4df6f90fbbbe446625444559";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:a66260f16475ff48be0e323f8512a090e051aadbe2f2ec64ef952d0b12a7ee12";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:78bf48b801e792f99e3ac62b5036fd3876e9be48afda16c1e331af1c75ceb2ff";
    redisImage = "redis:alpine@sha256:3811787313eba226a2ef38658c6ccb91cd5e110edc89c37767de373120a0e5a0";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:1ed1b0e1d7652937d6cbdaf4018c7b6fc009a7dd6c3047351e2eddda745de43f";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
