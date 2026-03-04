{ pkgs, inputs }:
with pkgs;
[
  nerd-fonts.meslo-lg
  yq
  ripgrep
  inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  bashInteractive
]
