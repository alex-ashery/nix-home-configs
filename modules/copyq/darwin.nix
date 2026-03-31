{ config, lib, ... }:
let
  copyqApp = "/Applications/CopyQ.app";
in
{
  homebrew.casks = lib.mkAfter [ "copyq" ];

  launchd.agents.copyq = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "CopyQ" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  home.activation.fixCopyQDarwin = lib.mkIf (config.homebrew.enable or false)
    (lib.hm.dag.entryAfter [ "brewBundle" ] ''
      set -euo pipefail

      if [ ! -d "${copyqApp}" ]; then
        echo "CopyQ.app not found at ${copyqApp}; skipping quarantine/signing fixes."
        exit 0
      fi

      xattr -d com.apple.quarantine "${copyqApp}" >/dev/null 2>&1 || true
      codesign --force --deep --sign - "${copyqApp}"
    '');
}
