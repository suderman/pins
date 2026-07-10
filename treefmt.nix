_: {
  projectRootFile = "flake.nix";

  programs.alejandra = {
    enable = true;
    includes = ["*.nix" "**/*.nix"];
  };

  programs.prettier = {
    enable = true;
    includes = [
      "*.json"
      "**/*.json"
      "*.md"
      "**/*.md"
    ];
  };

  programs.shfmt = {
    enable = true;
    includes = [".envrc" "*.sh" "**/*.sh"];
  };

  settings.global.excludes = [
    ".direnv/**"
    "result"
    "result/**"
  ];
}
