{
  backblaze-personal-wine = rec {
    version = "1.9";
    ref = version;
    image = "tessypowder/backblaze-personal-wine:v${ref}";
    upstream = "https://hub.docker.com/r/tessypowder/backblaze-personal-wine/tags";
    updatePolicy = "Intentionally conservative; confirm image behavior before jumping from v1.9.";
  };

  codex-lb = rec {
    version = "1.20.1";
    ref = version;
    image = "ghcr.io/soju06/codex-lb:${ref}";
    upstream = "https://github.com/Soju06/codex-lb/pkgs/container/codex-lb";
  };

  home-assistant = rec {
    version = "2026.7.1";
    ref = version;
    image = "ghcr.io/home-assistant/home-assistant:${ref}";
    upstream = "https://github.com/home-assistant/core/pkgs/container/home-assistant/versions?filters%5Bversion_type%5D=tagged";
  };

  immich = rec {
    version = "2.7.5";
    ref = version;
    serverImage = "ghcr.io/immich-app/immich-server:v${ref}";
    machineLearningImage = "ghcr.io/immich-app/immich-machine-learning:v${ref}";
    machineLearningCudaImage = "ghcr.io/immich-app/immich-machine-learning:v${ref}-cuda";
    upstream = "https://github.com/immich-app/immich/releases";
  };

  rsshub = rec {
    tag = "chromium-bundled";
    ref = tag;
    image = "diygod/rsshub:${ref}";
    upstream = "https://hub.docker.com/r/diygod/rsshub/tags";
    updatePolicy = "Keep the chromium-bundled flavor unless intentionally changed.";
  };

  rsshub-redis = rec {
    tag = "6.2.22";
    ref = tag;
    image = "redis:${ref}";
    upstream = "https://hub.docker.com/_/redis/tags";
    updatePolicy = "Use full patch tags within the pinned major/minor line; treat major-version bumps as higher risk.";
  };

  unifi = rec {
    version = "7.5";
    ref = version;
    image = "jacobalberty/unifi:v${ref}";
    upstream = "https://hub.docker.com/r/jacobalberty/unifi/tags";
    updatePolicy = "Intentionally conservative; report newer tags before bumping from the 7.5 controller line.";
  };

  whoami = rec {
    version = "1.11.0";
    ref = version;
    image = "traefik/whoami:v${ref}";
    upstream = "https://hub.docker.com/r/traefik/whoami/tags";
    updatePolicy = "Use the newest full semver tag; avoid latest and arch-specific tags.";
  };

  whoogle-search = rec {
    version = "1.2.5";
    ref = version;
    image = "benbusby/whoogle-search:${ref}";
    upstream = "https://github.com/benbusby/whoogle-search/releases";
  };

  zwave-js-ui = rec {
    version = "11.21.1";
    ref = version;
    image = "ghcr.io/zwave-js/zwave-js-ui:${ref}";
    upstream = "https://github.com/zwave-js/zwave-js-ui/pkgs/container/zwave-js-ui/versions?filters%5Bversion_type%5D=tagged";
  };
}
