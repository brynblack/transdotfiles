{
  programs = {
    zsh = {
      enable = true;
      initExtra = ''
        export EDITOR=hx

        alias ls='eza -lh --icons=always --sort=type'
        alias lsa='ls -a'
        alias shx='sudo -E hx'
        alias update='sudo nix flake update /etc/nixos'
        alias rebuild='sudo nixos-rebuild switch --flake /etc/nixos && home-manager switch --flake /etc/nixos'

        colorscript -e zwaves
      '';
    };

    fzf.enable = true;
  };
}
