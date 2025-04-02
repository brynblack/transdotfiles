{ inputs, username, ... }:

let homeDirectory = "/home/${username}";
in {
  imports = [
    ./packages.nix
    ./programs.nix
    ./zsh.nix
    inputs.aagl.nixosModules.default
  ];

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
  };

  programs.home-manager.enable = true;
}
