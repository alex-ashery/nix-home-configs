SOPS secrets live in this folder.

To set the GitHub token used by Nix on macOS:
1) Ensure you have an age key at ~/.config/sops/age/keys.txt
2) Create secrets/github-token.sops.yaml with a field named github-token
3) Encrypt it with sops for your age public key

The macOS Home Manager config will include the token in nix.conf only when
secrets/github-token.sops.yaml exists.
