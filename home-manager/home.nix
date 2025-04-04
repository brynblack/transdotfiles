{ username, ... }:

let homeDirectory = "/home/${username}";
in {
  imports = [ ./zsh.nix ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  home.file.".config/thefuck/settings.py".text = ''
    exclude_rules = [ "fix_file" ]
  '';

  services = {
    kdeconnect.enable = true;
    ssh-agent.enable = true;
    arrpc.enable = true;
  };

  programs.home-manager.enable = true;
}
