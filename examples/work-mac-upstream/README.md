# Example work Mac setup

This directory is an example of a separate work-owned Home Manager flake that
consumes this personal repo as an upstream.

For local inspection from this repo, `flake.nix` uses:

```nix
personal-home.url = "path:../..";
```

In a real separate work repo, change that input to a pinned personal upstream:

```nix
personal-home.url = "github:alex-ashery/nix-home-configs";
```

The intended ownership boundary is:

- personal upstream: reusable modules, editor/shell ergonomics, generic tooling
- work repo: work username, Git identity, company-specific casks, internal URLs,
  SSH hosts, secrets, and local policy

Evaluate the example without writing a lock file:

```sh
nix eval --no-write-lock-file .#homeConfigurations.work-mac.activationPackage.drvPath
```

