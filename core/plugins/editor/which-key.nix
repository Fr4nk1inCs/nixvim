_: let
  expand = func: {
    __raw = ''
      function()
        return require("which-key.extras").expand.${func}()
      end
    '';
  };
in {
  plugins.which-key = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
        keys = [
          {
            __unkeyed-1 = "<leader>?";
            __unkeyed-2.__raw = ''
              function()
                require('which-key').show({ global = false })
              end
            '';
            desc = "Buffer keymaps (which-key)";
          }
          {
            __unkeyed-1 = "<c-w><space>";
            __unkeyed-2.__raw = ''
              function()
                require('which-key').show({ keys = "<c-w>", loop = true })
              end
            '';
            desc = "Window hydra mode (which-key)";
          }
        ];
      };
    };

    settings = {
      win.border = "rounded";

      spec = [
        {
          __unkeyed-1 = "[";
          group = "Previous";
        }
        {
          __unkeyed-1 = "]";
          group = "Next";
        }
        {
          __unkeyed-1 = "z";
          group = "Fold";
        }
        {
          __unkeyed-1 = "<leader><tab>";
          group = "Tabs";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "UI / Toggle";
          icon = {
            icon = "󰙵 ";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
          expand = expand "buf";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "Windows";
          proxy = "<c-w>";
          expand = expand "win";
        }
        {
          __unkeyed-1 = "gx";
          group = "Open with system app";
        }
      ];
    };
  };
}
