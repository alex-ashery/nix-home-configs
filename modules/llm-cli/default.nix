{ lib, config, pkgs, ... }:

let
  cfg = config.modules.llmCli;
  primaryPackage = cfg.packages.${cfg.primary};
  globalContextText = lib.concatStringsSep "\n\n" (
    [
      (builtins.readFile cfg.globalContext.source)
    ]
    ++ (map builtins.readFile cfg.globalContext.additionalSources)
    ++ (lib.optional (cfg.globalContext.additionalText != "") cfg.globalContext.additionalText)
  );
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

    globalContext = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install shared global instructions for the selected LLM CLI.
        '';
      };

      source = lib.mkOption {
        type = lib.types.path;
        default = ./global-context.md;
        defaultText = lib.literalExpression "./global-context.md";
        description = ''
          Markdown file used as global context for the selected LLM CLI.
        '';
      };

      additionalSources = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = lib.literalExpression "[ ./work-context.md ]";
        description = ''
          Additional Markdown files appended to the selected LLM CLI's global context.
        '';
      };

      additionalText = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          ## Work Context

          - Prefer the internal package registry for new dependencies.
        '';
        description = ''
          Additional Markdown text appended to the selected LLM CLI's global context.
          This option is mergeable, so consuming profiles can add local context
          without replacing the shared base file.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      programs.codex = lib.mkIf (cfg.primary == "codex") {
        enable = true;
        package = primaryPackage;
      };

      programs.claude-code = lib.mkIf (cfg.primary == "claude-code") {
        enable = true;
        package = primaryPackage;
      };

      home.sessionVariables = lib.mkIf (cfg.primary == "codex") {
        CODEX_HOME = "$HOME/.codex";
      };

      programs.zsh.initContent = lib.mkIf (cfg.primary == "codex") ''
        # Ensure trust/history are persisted in a stable location.
        export CODEX_HOME="$HOME/.codex"
      '';
    }

    (lib.mkIf cfg.globalContext.enable {
      home.file = lib.mkMerge [
        (lib.mkIf (cfg.primary == "codex") {
          ".codex/AGENTS.md".text = globalContextText;
        })
        (lib.mkIf (cfg.primary == "claude-code") {
          ".claude/CLAUDE.md".text = globalContextText;
        })
      ];
    })
  ];
}
