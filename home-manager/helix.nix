{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      nil
    ];
    
    settings = {
      theme = "catppuccin_mocha";

      editor = {
        line-number = "relative";
        idle-timeout = 0;
        completion-trigger-len = 0;
        soft-wrap.enable = true;
        indent-guides = {
          render = true;
          character = "|";
        };
      };


      keys = {
        select = {
          n = "extend_char_left";
          e = "extend_line_down";
          i = "extend_line_up";
          o = "extend_char_right";

          k = "insert_mode";
          K = "insert_at_line_start";

          y = "open_below";
          Y = "open_above";

          t = "move_next_word_end";
          T = "move_next_long_word_end";

          j = "search_next";
          J = "search_prev";
        };
        normal = {
          n = "move_char_left";
          e = "move_line_down";
          i = "move_line_up";
          o = "move_char_right";

          l = "undo";
          L = "redo";

          u = "insert_mode";
          U = "insert_at_line_start";

          y = "open_below";
          Y = "open_above";

          j = "yank";

          t = "find_till_char";
          T = "till_prev_char";

          k = "search_next";
          K = "search_prev";

          g = {
            n = "goto_line_start";
            o = "goto_line_end";
          };

          space.w = {
            n = "jump_view_left";
            e = "jump_view_down";
            i = "jump_view_up";
            o = "jump_view_right";
          };

          "C-w" = {
            n = "jump_view_left";
            e = "jump_view_down";
            E = "join_selections";
            "A-E" = "join_selections_space";

            i = "jump_view_up";
            I = "keep_selections";
            "A-I" = "remove_selections";

            o = "jump_view_right";
          };

          z = {
            e = "scroll_down";
            i = "scroll_up";
          };

          Z = {
            e = "scroll_down";
            i = "scroll_up";
          };
        };
      };
    };
  };
}
