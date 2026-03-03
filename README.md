# nix-home-configs

Home Manager configurations

# Bootstrap
Enable the dev shell automatically with `direnv allow`

## SOPS + GitHub token for Nix (macOS)

This repo uses sops-nix to provide a GitHub access token to Nix on macOS.
- Add an age key at `~/.config/sops/age/keys.txt` by running `age-keygen -o ~/.config/sops/age/keys.txt`.
- Update the encrypted secret by adding your age public key as a recipient (so you can decrypt):
   `sops --add-age age1YOURPUBLICKEY -i secrets/github-token.sops.yaml`

## SSH key passphrases

macOS:
- Home Manager config enables macOS Keychain integration.
- Run once: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`

Linux (NixOS):
- Home Manager enables a user `ssh-agent` systemd service.
- The agent does not persist keys across logins; run once per login/session:
  `ssh-add ~/.ssh/id_ed25519`
