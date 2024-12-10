_: {
  plugins = {
    noice = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
          keys = [
            {
              __unkeyed-1 = "<leader>snl";
              __unkeyed-2.__raw = ''function() require("noice").cmd("last") end'';
              desc = "Last (noice) message";
            }
            {
              __unkeyed-1 = "<leader>snh";
              __unkeyed-2.__raw = ''function() require("noice").cmd("history") end'';
              desc = "History (noice) messages";
            }
            {
              __unkeyed-1 = "<leader>sna";
              __unkeyed-2.__raw = ''function() require("noice").cmd("all") end'';
              desc = "All (noice) messages";
            }
            {
              __unkeyed-1 = "<leader>snd";
              __unkeyed-2.__raw = ''function() require("noice").cmd("dismiss") end'';
              desc = "Dismiss (noice) messages";
            }
            {
              __unkeyed-1 = "<leader>snt";
              __unkeyed-2.__raw = ''function() require("noice").cmd("pick") end'';
              desc = "Pick (noice) messages (FzfLua)";
            }
            {
              __unkeyed-1 = "<s-enter>";
              __unkeyed-2.__raw = ''
                function()
                  require("noice").redirect(vim.fn.getcmdline())
                end
              '';
              mode = "c";
              desc = "Redirect cmdline";
            }
            {
              __unkeyed-1 = "<c-f>";
              __unkeyed-2.__raw = ''
                function()
                  if not require("noice.lsp").scroll(4) then
                    return "<c-f>"
                  end
                end
              '';
              mode = ["i" "n" "s"];
              expr = true;
              desc = "Scroll forward";
            }
            {
              __unkeyed-1 = "<c-b>";
              __unkeyed-2.__raw = ''
                function()
                  if not require("noice.lsp").scroll(-4) then
                    return "<c-b>"
                  end
                end
              '';
              mode = ["i" "n" "s"];
              expr = true;
              desc = "Scroll backward";
            }
          ];
        };
      };

      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          signature.opts = {
            relative = "cursor";
            size.width = 60;
          };
        };

        views = builtins.listToAttrs (
          builtins.map (
            item: {
              name = item;
              value = {
                win_options.winblend = 0;
              };
            }
          )
          ["popup" "notify" "cmdline_popup" "popupmenu" "mini"]
        );

        routes = [
          {
            filter = {
              event = "msg_show";
              any = [
                {find = "%d+L; %d+B";}
                {find = "; after #%d+";}
                {find = "; before #%d+";}
              ];
            };
            view = "mini";
          }
        ];

        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          lsp_doc_border = true;
          inc_rename = true;
        };

        markdown.hover = {
          "|(%S-)|".__raw = "vim.cmd.help"; # vim help links
          "%[.-%]%((%S-)%)".__raw = ''require("noice.util").open''; # markdown links
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>sn";
        group = "Messages (noice)";
      }
    ];
  };
}
