{ lib, config, pkgs, ... }:

let
  cfg = config.modules.llmCli;
  primaryPackage = cfg.packages.${cfg.primary};
  commands = {
    codex = {
      executable = "codex";
      kittyLaunch = "codex resume --last";
    };
    claude-code = {
      executable = "claude";
      kittyLaunch = "claude";
    };
  };
in
{
  options.modules.llmCli = {
    primary = lib.mkOption {
      type = lib.types.enum [ "codex" "claude-code" ];
      default = "codex";
      description = ''
        Primary LLM CLI to install and configure for this Home Manager profile.
      '';
    };

    packages = lib.mkOption {
      type = lib.types.attrs;
      default = pkgs;
      defaultText = lib.literalExpression "pkgs";
      example = lib.literalExpression "inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}";
      description = ''
        Package set used for the selected primary LLM CLI. It must provide
        package attributes matching the supported primary values.
      '';
    };

    executable = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = commands.${cfg.primary}.executable;
      description = "Executable name for the selected primary LLM CLI.";
    };

    kittyLaunchCommand = lib.mkOption {
      type = lib.types.str;
      default = commands.${cfg.primary}.kittyLaunch;
      defaultText = lib.literalExpression "default launch command for modules.llmCli.primary";
      description = ''
        Command launched by terminal integrations for the selected primary LLM CLI.
      '';
    };
  };

  config = {
    home.packages = [ primaryPackage ];

    home.sessionVariables = lib.mkIf (cfg.primary == "codex") {
      CODEX_HOME = "$HOME/.codex";
    };

    programs.zsh.initContent = lib.mkIf (cfg.primary == "codex") ''
      # Ensure trust/history are persisted in a stable location.
      export CODEX_HOME="$HOME/.codex"
    '';
  };
}
