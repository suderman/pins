{
  devshell,
  formatter,
  pkgs,
  ...
}:
devshell.mkShell {
  devshell.name = "suderman/pins";

  env = [
    {
      name = "PATH";
      prefix = "tools";
    }
  ];

  commands = [
    {
      category = "updates";
      name = "pins-check";
      help = "Check upstreams without editing pins";
      command = ''
        tools/update-pins.py check "$@"
      '';
    }
    {
      category = "updates";
      name = "pins-report";
      help = "Print a Markdown pin update report";
      command = ''
        tools/update-pins.py report "$@"
      '';
    }
    {
      category = "updates";
      name = "pins-apply-safe";
      help = "Apply safe updates, validate, commit, and push";
      command = ''
        tools/update-pins.py apply --safe --validate --flake-check --commit --push "$@"
      '';
    }
    {
      category = "updates";
      name = "pins-validate";
      help = "Run validation for changed or selected pins";
      command = ''
        tools/update-pins.py validate --flake-check "$@"
      '';
    }
  ];

  packages = [
    pkgs.git
    pkgs.nix
    pkgs.nodejs
    pkgs.python3
    formatter
  ];
}
