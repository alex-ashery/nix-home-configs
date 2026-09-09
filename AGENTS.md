# AGENTS.md

## Repo Notes

- New modules must be tracked with `git add` before flake-based `nix eval` or `home-manager` checks will see them. Untracked paths are invisible to flake evaluation.
- Do not use `builtins.currentSystem` to decide module imports in this repo. In pure flake evaluation it may be empty. Prefer importing from the host-specific module list and gating behavior inside the module if needed.
- For app-specific macOS behavior, put the Darwin configuration in `modules/<app>/darwin.nix` and import the app module from the macOS host module list instead of adding app setup directly in `aashery-mac/home.nix`.
- macOS app autostart can be managed declaratively with `launchd.agents.<name>.config.ProgramArguments = [ "/usr/bin/open" "-a" "<App>" ];` plus `RunAtLoad = true;`.
- In the Codex sandbox, plain `nix eval` is usually fine, but commands that realize store paths (`nix build`, some `nix path-info` uses, and plugin/source inspection) may need the Nix daemon socket and normal Nix cache under `~/.cache/nix`, which are outside the sandbox. Prefer the already-approved flake check command when it is enough: `XDG_CACHE_HOME=/tmp /nix/var/nix/profiles/default/bin/nix flake check`. If a daemon-backed Nix command fails with socket or cache permission errors, rerun that exact command with escalated permissions instead of working around it with ad hoc cache paths.
- For tool families where one implementation should be selected, prefer a shared selector module with a caller-provided package set over per-tool enable flags. Keep host configs
  responsible for choosing package sources.
