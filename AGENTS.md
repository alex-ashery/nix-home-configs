# AGENTS.md

## Repo Notes

- New modules must be tracked with `git add` before flake-based `nix eval` or `home-manager` checks will see them. Untracked paths are invisible to flake evaluation.
- Do not use `builtins.currentSystem` to decide module imports in this repo. In pure flake evaluation it may be empty. Prefer importing from the host-specific module list and gating behavior inside the module if needed.
- For app-specific macOS behavior, put the Darwin configuration in `modules/<app>/darwin.nix` and import the app module from the macOS host module list instead of adding app setup directly in `aashery-mac/home.nix`.
- macOS app autostart can be managed declaratively with `launchd.agents.<name>.config.ProgramArguments = [ "/usr/bin/open" "-a" "<App>" ];` plus `RunAtLoad = true;`.
