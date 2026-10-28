{ config, lib, ... }:

let
  cfg = config.modules.tuicr;
in

{
  imports = [ ../llm-cli ];

  options.modules.tuicr = {
    enable = lib.mkEnableOption "tuicr and its shared agent review skill";

    package = lib.mkOption {
      type = lib.types.package;
      example = lib.literalExpression "pkgs.unstable.tuicr";
      description = "tuicr package selected by the calling profile.";
    };
    kittyLaunchCommand = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      readOnly = true;
      default = if cfg.enable then "${lib.getExe cfg.package} -w" else null;
      description = "Command launched by Kitty to review uncommitted changes in tuicr.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    modules.llmCli = {
      # Use the complete upstream skill, including its terminal helper scripts,
      # from the same source revision as the selected package.
      skills.tuicr = "${cfg.package.src}/skills/tuicr";
      globalContext.additionalText = ''
        ## Code Review

        - When I refer to my code comments, review comments, or feedback on pending changes, use the `tuicr` skill to read my review for the current repository, unless I name another review tool or clearly mean comments in source code.
        - When following up on a review, reconsider every human comment, including ones with agent replies. A reply alone does not resolve feedback: check the current work and report addressed items and any remaining questions or decisions explicitly.
      '';
    };
  };
}
