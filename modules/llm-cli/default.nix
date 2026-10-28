{ lib, config, pkgs, ... }:

let
  cfg = config.modules.llmCli;
  toolType = lib.types.enum [ "codex" "claude-code" ];
  enabledTools = lib.unique cfg.tools;
  defaultCommandPathEntries = [
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
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
  wrapperArgs =
    (lib.optionals cfg.loadDirenvEnvironment [
      "--run"
      ''eval "$(${pkgs.direnv}/bin/direnv export bash 2>/dev/null || true)"''
    ])
    ++ [
      "--prefix"
      "PATH"
      ":"
      (lib.concatStringsSep ":" cfg.commandPathEntries)
    ];
  wrappedPackage = tool: let
    package = cfg.packages.${tool};
  in pkgs.symlinkJoin {
    name = "${package.name or tool}-with-command-path";
    paths = [ package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/${commands.${tool}.executable}" ${lib.escapeShellArgs wrapperArgs}
    '';
  };
in
{
  options.modules.llmCli = {
    primary = lib.mkOption {
      type = toolType;
      default = "codex";
      description = ''
        Primary LLM CLI used by terminal integrations. It must be included in tools.
      '';
    };

    tools = lib.mkOption {
      type = lib.types.listOf toolType;
      default = [ cfg.primary ];
      defaultText = lib.literalExpression "[ config.modules.llmCli.primary ]";
      example = [ "codex" "claude-code" ];
      description = "LLM CLIs to install and configure for this Home Manager profile.";
    };

    packages = lib.mkOption {
      type = lib.types.attrs;
      default = pkgs;
      defaultText = lib.literalExpression "pkgs";
      example = lib.literalExpression "inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}";
      description = ''
        Package set used for the selected LLM CLIs. It must provide
        package attributes matching every selected tool.
      '';
    };

    skills = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = lib.literalExpression ''
        {
          my-skill = ./skills/my-skill;
        }
      '';
      description = ''
        Shared skill directories, keyed by skill name. Each directory must contain
        a SKILL.md and is linked into ~/.agents/skills. When Claude Code is selected,
        ~/.claude/skills links to that shared directory as well. Other skills in
        the shared directory remain writable.
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

    commandPathEntries = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = defaultCommandPathEntries;
      description = ''
        PATH entries prepended to each selected LLM CLI wrapper. This keeps
        Nix-installed tools visible even when the CLI is launched from an app
        or sandbox environment that did not inherit the interactive shell PATH,
        without taking ownership of mutable tool configuration files.
      '';
    };

    loadDirenvEnvironment = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether each selected LLM CLI wrapper should import the direnv environment
        for the launch directory before starting the CLI. This makes project
        dev-shell tools visible when launching the LLM CLI from a repository with
        an allowed .envrc, while quietly doing nothing outside direnv projects.
      '';
    };

    globalContext = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install shared global instructions for every selected LLM CLI.
        '';
      };

      source = lib.mkOption {
        type = lib.types.path;
        default = ./global-context.md;
        defaultText = lib.literalExpression "./global-context.md";
        description = ''
          Markdown file used as global context for every selected LLM CLI.
        '';
      };

      additionalSources = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = lib.literalExpression "[ ./work-context.md ]";
        description = ''
          Additional Markdown files appended to each selected LLM CLI's global context.
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
          Additional Markdown text appended to each selected LLM CLI's global context.
          This option is mergeable, so consuming profiles can add local context
          without replacing the shared base file.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.elem cfg.primary enabledTools;
          message = "modules.llmCli.tools must include modules.llmCli.primary.";
        }
      ];

      programs.codex = lib.mkIf (lib.elem "codex" enabledTools) {
        enable = true;
        package = wrappedPackage "codex";
      };

      programs.claude-code = lib.mkIf (lib.elem "claude-code" enabledTools) {
        enable = true;
        package = wrappedPackage "claude-code";
      };

      home.file = lib.mkMerge [
        (lib.mapAttrs' (name: source:
          lib.nameValuePair ".agents/skills/${name}" {
            inherit source;
          }
        ) cfg.skills)
        (lib.mkIf (lib.elem "claude-code" enabledTools) {
          ".claude/skills" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills";
          };
        })
      ];

      home.sessionVariables = lib.mkIf (lib.elem "codex" enabledTools) {
        CODEX_HOME = "$HOME/.codex";
      };

      programs.zsh.initContent = lib.mkIf (lib.elem "codex" enabledTools) ''
        # Ensure trust/history are persisted in a stable location.
        export CODEX_HOME="$HOME/.codex"
      '';
    }

    (lib.mkIf cfg.globalContext.enable {
      home.file = lib.mkMerge [
        (lib.mkIf (lib.elem "codex" enabledTools) {
          ".codex/AGENTS.md".text = globalContextText;
        })
        (lib.mkIf (lib.elem "claude-code" enabledTools) {
          ".claude/CLAUDE.md".text = globalContextText;
        })
      ];
    })
  ];
}
