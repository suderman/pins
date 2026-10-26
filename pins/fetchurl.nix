{
  camoufox = {
    version = "152.0.4-beta.30";
    url = "https://github.com/daijro/camoufox/releases/download/v152.0.4-beta.30/camoufox-152.0.4-beta.30-lin.x86_64.zip";
    sha256 = "5720d45b894ce1770543de024c6f10d514b38be560fa2dc3226b3d8586caf672";
    upstream = "https://github.com/daijro/camoufox/releases";
    updatePolicy = "Report only, including beta releases. Verify compatibility with the Camofox server before updating.";
  };

  citron = {
    pname = "citron-appimage";
    version = "nightly-56dad8119";
    url = "https://github.com/citron-neo/CI/releases/download/nightly-linux/citron_nightly-56dad8119-linux-x86_64_v3.AppImage";
    sha256 = "sha256-lf9SBsOyddhvYUNq7K+TZMTKKbbGN7/9hrvj0Ti/T0E=";
    upstream = "https://github.com/citron-neo/CI/releases";
    description = "Citron Nintendo Switch emulator AppImage";
  };

  eden = {
    pname = "eden-appimage";
    version = "0.2.1";
    url = "https://git.eden-emu.dev/eden-emu/eden/releases/download/v0.2.1/Eden-Linux-v0.2.1-amd64-gcc-standard.AppImage";
    sha256 = "sha256-L65lg5fa8TwRgIKj62XWGmUZlnteIuZmd1a67PYADFo=";
    upstream = "https://git.eden-emu.dev/eden-emu/eden/releases";
    description = "Eden Nintendo Switch emulator AppImage";
  };
}
