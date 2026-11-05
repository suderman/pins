{
  backblaze-personal-wine = rec {
    version = "2.1.1";
    ref = version;
    image = "tessypowder/backblaze-personal-wine:v${ref}";
    upstream = "https://hub.docker.com/r/tessypowder/backblaze-personal-wine/tags";
    updatePolicy = "Intentionally conservative; review migrations and test persisted state before updating.";
  };

  codex-lb = rec {
    version = "1.24.0";
    ref = version;
    image = "ghcr.io/soju06/codex-lb:${ref}";
    upstream = "https://github.com/Soju06/codex-lb/pkgs/container/codex-lb";
  };

  comfyui = rec {
    repository = "ghcr.io/utensils/comfyui-nix";
    tag = "latest-cuda";
    digest = "sha256:c8bf5418f14c552f81d5a12a07d85ba6f17aaf4ee77008f9122c5f64e15a9b3c";
    image = "${repository}@${digest}";
    upstream = "https://github.com/utensils/comfyui-nix/pkgs/container/comfyui-nix";
    # Temporary upstream SAM editor fix until the image includes it.
    samEditorUrl = "https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/85f76ea6acf964fd6e8911d3c1510d64676f4ea2/js/impact-sam-editor.js";
    samEditorHash = "sha256-zW+ZZf+AXp1AjxcWaS35MXovD9r7ULI/fgckIs/y7sU=";
  };

  home-assistant = rec {
    version = "2026.11.0";
    ref = version;
    image = "ghcr.io/home-assistant/home-assistant:${ref}";
    upstream = "https://github.com/home-assistant/core/pkgs/container/home-assistant/versions?filters%5Bversion_type%5D=tagged";
  };

  immich = rec {
    version = "3.3.6";
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
    tag = "6.2.24";
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
    version = "1.12.0";
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
    version = "11.25.2";
    ref = version;
    image = "ghcr.io/zwave-js/zwave-js-ui:${ref}";
    upstream = "https://github.com/zwave-js/zwave-js-ui/pkgs/container/zwave-js-ui/versions?filters%5Bversion_type%5D=tagged";
  };
}
