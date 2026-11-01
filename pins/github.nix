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
    rev = "v3.5.0";
    hash = "sha256-iGxhRFDZzrojQ1/24Q+QNh8bAnfAXTe94IqPoqCjipQ=";
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
    rev = "v3.0.0";
    hash = "sha256-hhfNvWVAj0gv9//dsCWVEdx8SE2IiHdVcB7CvpV+jaQ=";
    apiImage = "ghcr.io/valtora/nojoin-api@sha256:892c7aefb73fb6744146647277cbd3f4e51a86a364f5cb04e5f559839663d45b";
    workerImage = "ghcr.io/valtora/nojoin-worker@sha256:336063657cfe59d3b4eff53e7248105f993083c46b195c529af1a1865fd0572d";
    workerIoImage = "ghcr.io/valtora/nojoin-worker-io@sha256:2ac054eedb361263ce0ff7de6891ecdd5d71aa02e184cd6adfed2152c53ea1a3";
    frontendImage = "ghcr.io/valtora/nojoin-frontend@sha256:926ac75196cb7be81424fb288516300d9848a4bbfc04eb01aa9b03d3c7bf993f";
    postgresImage = "pgvector/pgvector:pg18-trixie@sha256:5895949dfcdf308eb0cd31c950c93c14895c77f33fbedfecf1fa511ab1d4bcd2";
    redisImage = "redis:alpine@sha256:21090af93f8324db2f0f0f4f38a7c60369d47d917e000c3423d89d2ae2883537";
    socketProxyImage = "tecnativa/docker-socket-proxy@sha256:1f5038b54f06c3e18422902cf00ba21803d1c97805aae032e5e6673d532d3459";
    nginxImage = "nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606";
    upstream = "https://github.com/Valtora/Nojoin/releases";
    updatePolicy = "Review release notes and update the source plus all image digests together.";
  };
}
