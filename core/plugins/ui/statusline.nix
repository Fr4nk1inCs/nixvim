_: {
  plugins.lualine = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = ["DeferredUIEnter"];
        on_require = ["lualine"];
      };
    };

    settings = {
      options = {
        globalstatus = true;
        theme = "auto";
        disabledFiletypes.statusline = ["dashboard"];
      };
      extensions = ["neo-tree" "fzf" "toggleterm" "man"];

      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            icon = "";
            fmt.__raw = ''
              function(text)
                return text:sub(1, 1):upper()
              end
            '';
          }
        ];
        lualine_b = [
          "branch"
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
            source.__raw = ''
              function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end
            '';
          }
        ];
        lualine_c = [
          {
            __unkeyed-1.__raw = "utils.lualine.root_dir().name";
            cond.__raw = "utils.lualine.root_dir().cond";
            color.__raw = "utils.lualine.root_dir().color";
          }
          {
            __unkeyed-1 = "diagnostics";
            symbols = {
              error = " ";
              warn = " ";
              hint = " ";
              info = " ";
            };
          }
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1.__raw = "utils.lualine.pretty_path()";
          }
          {
            __unkeyed-1.__raw = ''
              utils.lualine.trouble().name
            '';
            cond.__raw = ''
              utils.lualine.trouble().cond
            '';
          }
        ];

        lualine_x = [
          {
            __unkeyed-1.__raw = ''
              function()
                return require("noice").api.status.command.get()
              end
            '';
            cond.__raw = ''
              function()
                return require("noice").api.status.command.has()
              end
            '';
            color = "Statement";
          }
          {
            __unkeyed-1.__raw = ''
              function()
                return require("noice").api.status.mode.get()
              end
            '';
            cond.__raw = ''
              function()
                return require("noice").api.status.mode.has()
              end
            '';
            color = "Constant";
          }
          {
            __unkeyed-1.__raw = ''
              function()
                return  "  " .. require("dap").status()
              end
            '';
            cond.__raw = ''
              function()
                return require("dap").status() ~= ""
              end
            '';
            color = "Debug";
          }
        ];
        lualine_y = [
          {
            __unkeyed-1 = "fileformat";
            separator.left = "";
          }
          {
            __unkeyed-1 = "encoding";
            separator.left = "";
          }
          "filesize"
        ];
        lualine_z = [
          {
            __unkeyed-1 = "progress";
            padding = {
              left = 1;
              right = 1;
            };
          }
          {
            __unkeyed-1 = "location";
            separator.left = " ";
            padding = {
              left = 0;
              right = 0;
            };
          }
        ];
      };
    };
  };
}
