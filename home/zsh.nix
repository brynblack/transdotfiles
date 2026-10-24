{ config, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];

  # ZDOTDIR is exported from /etc/zshenv (system/programs.nix), so the
  # ~/.zshenv shim pointing at dotDir isn't needed.
  home.file.".zshenv".enable = false;

  programs = {
    fzf.enable = true;
    zoxide.enable = true;
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      defaultKeymap = "viins";
      shellAliases.ls = "eza -lh --icons=always --sort=type";
      initContent = ''
        # Switch to command mode on <Esc> after 10ms rather than 400ms
        KEYTIMEOUT=1

        # Keep emacs-style line movement in insert mode; end-of-line also
        # accepts an autosuggestion
        bindkey -M viins '^A' beginning-of-line '^E' end-of-line
        # vi's backspace and ^W stop at the point where insert mode began;
        # delete past it like nvim (backspace=start) does
        bindkey -M viins '^?' backward-delete-char '^H' backward-delete-char \
          '^W' backward-kill-word

        # Colemak: the same langmap as nvim (home/nixvim/mappings.nix), with
        # hjkl on neio and the displaced keys moved along (j->y, l->u, y->o,
        # u->i, k->n, h->e)
        bindkey -M vicmd \
          n vi-backward-char e down-line-or-history \
          i up-line-or-history o vi-forward-char \
          j vi-yank l undo y vi-open-line-below u vi-insert \
          k vi-repeat-search h vi-forward-word-end
        # Operator-pending and visual mode bind their own j/k, iw text objects
        # and (visual) o/u, which would shadow the above. Unbinding j lets jj
        # yank the whole line, like dd.
        for km in viopp visual; do
          bindkey -M $km -r j k iw iW ia
          bindkey -M $km \
            e down-line i up-line \
            uw select-in-word uW select-in-blank-word ua select-in-shell-word
        done
        bindkey -M visual -r o u
        bindkey -M visual y exchange-point-and-mark l vi-down-case j vi-yank

        # Share the system clipboard like nvim's clipboard=unnamedplus. zle
        # yanks and deletes only fill its own cut buffer, so copy that out after
        # each vi yank/delete/change. Done in a redraw hook rather than by
        # wrapping vi-yank, which would stop jj and dd from acting on the line.
        _clipboard_copy() {
          [[ $LASTWIDGET == vi-(yank|delete|change|kill-eol|backward-delete-char)* ]] || return
          [[ -n $CUTBUFFER ]] && print -rn -- "$CUTBUFFER" | wl-copy 2>/dev/null
        }
        autoload -Uz add-zle-hook-widget
        add-zle-hook-widget line-pre-redraw _clipboard_copy
        # ...and put from it
        _clipboard_put() {
          CUTBUFFER=$(wl-paste -n 2>/dev/null)
          zle .$WIDGET
        }
        zle -N vi-put-after _clipboard_put
        zle -N vi-put-before _clipboard_put

        # Mode indicator: block cursor in command mode, beam in insert mode
        zle-keymap-select() {
          if [[ $KEYMAP == vicmd ]]; then
            printf '\e[2 q'
          else
            printf '\e[6 q'
          fi
        }
        zle -N zle-keymap-select
        # Every new prompt starts in insert mode
        zle-line-init() { printf '\e[6 q' }
        zle -N zle-line-init
        # Hand programs a block cursor, as they expect
        zle-line-finish() { printf '\e[2 q' }
        zle -N zle-line-finish

        colorscript -e zwaves
        nv() { neovide "$@" &>/dev/null & disown }
      '';
    };
  };
}
