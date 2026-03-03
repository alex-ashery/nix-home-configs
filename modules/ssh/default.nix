{ lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  programs.ssh = {
    enable = true;
    extraConfig = lib.optionalString isDarwin ''
      Host *
        UseKeychain yes
        AddKeysToAgent yes
    '';
  };

  systemd.user.services = lib.mkIf isLinux {
    ssh-agent = {
      Unit = {
        Description = "User SSH agent";
      };
      Service = {
        ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent.socket";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  home.sessionVariables = lib.mkIf isLinux {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  };
}
