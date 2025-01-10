_: {
  plugins.blink-cmp = {
    enable = true;

    settings = {
      # __cmp_cmdline_border.winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:Visual,Search:None";
      appearance.nerd_font_variant = "normal";
      completion = {
        accept.auto_brackets.enabled = true;
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        list.selection.preselect = false;
        menu = {
          border = "rounded";
          winblend = 0;
          draw = {
            columns = [
              {
                __unkeyed-1 = "label";
                __unkeyed-2 = "label_description";
                gap = 1;
              }
              [
                "kind_icon"
                "kind"
              ]
            ];
          };
        };
      };
      signature = {
        enabled = true;
        window.border = "rounded";
      };
      sources = {
        default = ["lsp" "path" "snippets" "buffer"];
      };
      keymap = {
        "<c-space>" = ["accept" "fallback"];
        "<c-b>" = ["scroll_documentation_up" "fallback"];
        "<c-f>" = ["scroll_documentation_down" "fallback"];
        "<c-k>" = ["cancel" "fallback"];
        "<cr>" = ["accept" "fallback"];
        "<s-tab>" = ["select_prev" "fallback"];
        "<tab>" = ["select_next" "fallback"];
      };
    };
  };
}
