{ config, lib, pkgs, ... }:

let
  cfg = config.modules.crit;
  # Codex follows skill-directory symlinks but skips a symlinked SKILL.md.
  sharedSkill = name: pkgs.runCommand "${name}-skill" { } ''
    mkdir -p "$out"
    cp ${./skills + "/${name}/SKILL.md"} "$out/SKILL.md"
    cp ${cfg.package.src}/integrations/codex/skills/${name}/SKILL.md "$out/codex.md"
    cp ${cfg.package.src}/integrations/claude-code/skills/${name}/SKILL.md "$out/claude-code.md"
  '';
in
{
  imports = [ ../llm-cli ];

  options.modules.crit.package = lib.mkOption {
    type = lib.types.package;
    description = "Crit package selected by the calling profile.";
  };

  config = {
    home.packages = [ cfg.package ];
    modules.llmCli.skills = {
      crit = sharedSkill "crit";
      crit-cli = sharedSkill "crit-cli";
    };
  };
}
