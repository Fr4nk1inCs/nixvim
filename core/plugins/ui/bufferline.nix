_: {
  plugins.bufferline = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = ["BufReadPost" "BufNewFile" "BufWritePre"];
        keys = [
          {
            __unkeyed-1 = "<leader>bp";
            __unkeyed-2 = "<cmd>BufferLineTogglePin<cr>";
            desc = "Toggle pin";
          }
          {
            __unkeyed-1 = "<leader>bP";
            __unkeyed-2 = "<cmd>BufferLineGroupClose ungrouped<cr>";
            desc = "Close all unpinned buffers";
          }
          {
            __unkeyed-1 = "<leader>bl";
            __unkeyed-2 = "<cmd>BufferLineCloseLeft<cr>";
            desc = "Close buffers to the left";
          }
          {
            __unkeyed-1 = "<leader>br";
            __unkeyed-2 = "<cmd>BufferLineCloseRight<cr>";
            desc = "Close buffers to the right";
          }
          {
            __unkeyed-1 = "<s-h>";
            __unkeyed-2 = "<cmd>BufferLineCyclePrev<cr>";
            desc = "Previous buffer";
          }
          {
            __unkeyed-1 = "<s-l>";
            __unkeyed-2 = "<cmd>BufferLineCycleNext<cr>";
            desc = "Next buffer";
          }
          {
            __unkeyed-1 = "[b";
            __unkeyed-2 = "<cmd>BufferLineCyclePrev<cr>";
            desc = "Previous buffer";
          }
          {
            __unkeyed-1 = "]b";
            __unkeyed-2 = "<cmd>BufferLineCycleNext<cr>";
            desc = "Next buffer";
          }
          {
            __unkeyed-1 = "[B";
            __unkeyed-2 = "<cmd>BufferLineMovePrev<cr>";
            desc = "Move buffer to previous";
          }
          {
            __unkeyed-1 = "]B";
            __unkeyed-2 = "<cmd>BufferLineMoveNext<cr>";
            desc = "Move buffer to next";
          }
        ];
      };
    };

    settings = {
      options = {
        close_command.__raw = "function(n) Snacks.bufdelete.delete(n) end";
        right_mouse_command.__raw = "function(n) Snacks.bufdelete.delete(n) end";

        diagnostics = "nvim_lsp";
        diagnostics_indicator.__raw = ''
          function(_, _, diag)
            local error = diag.error and " " .. diag.error .. " " or ""
            local warning = diag.warning and " " .. diag.warning .. " " or ""
            return vim.trim(error .. warning)
          end
        '';

        always_show_bufferline = false;

        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "center";
            separator = true;
          }
        ];
      };
    };
  };
}
