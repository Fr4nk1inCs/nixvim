_: let
  jump = direction: {
    __raw = ''
      function()
        if require("trouble").is_open() then
          require("trouble").${direction}({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.c${direction})
          if not ok then
            Snacks.notify.error(err)
          end
        end
      end
    '';
  };
in {
  plugins.trouble = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        cmd = "Trouble";
        keys = [
          {
            __unkeyed-1 = "<leader>xx";
            __unkeyed-2 = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
            desc = "Buffer diagnostics (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>xX";
            __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
            desc = "Workspace diagnostics (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>cs";
            __unkeyed-2 = "<cmd>Trouble symbols toggle<cr>";
            desc = "Symbols (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>cS";
            __unkeyed-2 = "<cmd>Trouble lsp toggle<cr>";
            desc = "LSP references/definitions/... (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>xL";
            __unkeyed-2 = "<cmd>Trouble loclist toggle<cr>";
            desc = "Location list (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>xQ";
            __unkeyed-2 = "<cmd>Trouble quickfix toggle<cr>";
            desc = "Quickfix list (Trouble)";
          }
          {
            __unkeyed-1 = "[q";
            __unkeyed-2 = jump "prev";
            desc = "Previous trouble/quickfix item (Trouble)";
          }
          {
            __unkeyed-1 = "]q";
            __unkeyed-2 = jump "next";
            desc = "Next trouble/quickfix item (Trouble)";
          }
        ];
      };
    };

    settings.modes.lsp.win.position = "right";
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>x";
      group = "diagnostics/quickfix";
      icon = {
        icon = "󱖫 ";
        color = "green";
      };
    }
  ];
}
