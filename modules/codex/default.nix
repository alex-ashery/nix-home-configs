{ lib, config, ... }:
let
  cfg = config.modules.codex;
in
{
  options.modules.codex.enable = lib.mkEnableOption "Codex CLI configuration";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      CODEX_HOME = "$HOME/.codex";
    };

    programs.zsh.initContent = ''
      # Ensure trust/history are persisted in a stable location.
      export CODEX_HOME="$HOME/.codex"
    '';
  };
}
