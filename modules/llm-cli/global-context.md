# Global LLM Agent Context

## Development Environment

- My development environment inherits shared modules and conventions from the `nix-home-configs` repository.
- The active Home Manager or system entrypoint may be another flake that consumes `nix-home-configs`; inspect the current repository before assuming where host-specific configuration lives.
- If a task depends on local tooling, shells, editor behavior, or agent behavior, check the active repo first, then use `nix-home-configs` as the shared baseline when relevant.
- `NIX_HOME_CONFIGS_FLAKE` points at the local checkout of `nix-home-configs` when it is available.

## Repository Layout Standards

- The `dev` and `repo` shell commands define my standard workspace layout and repository navigation flow.
- Prefer following the existing directory structure created by those commands when suggesting paths, setup steps, or automation for other repositories.
- When unclear, inspect the active repository and the shared dotfiles repository rather than assuming a generic layout.

## Nix/Home Manager Conventions

- Prefer declarative Home Manager or Nix module changes for repeatable environment behavior.
- Keep host configs responsible for selecting package sources.
- For tool families where one implementation should be selected, prefer a shared selector module with a caller-provided package set over per-tool enable flags.
- New Nix modules must be tracked with `git add` before flake-based evaluation can see them.
- Do not use `builtins.currentSystem` to decide module imports. In pure flake evaluation it may be empty.

## Agent Collaboration

- Look for repository-local instructions such as `AGENTS.md` or `CLAUDE.md` and treat them as higher-priority project context.
- Keep global context short and reusable. Put project-specific behavior in that project's checked-in instructions.
- If a rule seems specific to `nix-home-configs`, inspect that repository's `AGENTS.md` for the current version.
