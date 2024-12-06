_: {
  autoGroups = {
    nixvim_format = {clear = true;};
  };

  autoCmd = [
    {
      group = "nixvim_format";
      event = ["BufWritePre"];
      callback.__raw = ''
        function(event)
          if vim.b[event.buf].autoformat == nil then
            vim.b[event.buf].autoformat = vim.g.autoformat
          end
          if vim.b[event.buf].autoformat then
            vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 5000 })
          end
        end
      '';
    }
  ];

  keymaps = [
    # Manual format
    {
      action.__raw = ''
        function()
          vim.lsp.buf.format({ async = true, bufnr = vim.api.nvim_get_current_buf() })
        end
      '';
      key = "<leader>cf";
      mode = ["n" "v"];
      options = {
        desc = "Format (Async)";
        silent = true;
      };
    }
  ];

  extraConfigLuaPost = ''
    do
      local function toggle_format(buf)
        return Snacks.toggle({
          name = "autoformat (" .. (buf and "buffer" or "global") .. ")",
          get = function()
            if not buf then
              return vim.g.autoformat == nil or vim.g.autoformat
            end
            if vim.b[buf].autoformat == nil then
              vim.b[buf].autoformat = vim.g.autoformat
            end
            return vim.b[buf].autoformat
          end,
          set = function(state)
            if enable == nil then
              enable = true
            end
            if buf then
              vim.b[buf].autoformat = state
            else
              vim.g.autoformat = state
              vim.b[buf].autoformat = nil
            end

            buf = buf or vim.api.nvim_get_current_buf()
            local global = vim.g.autoformat == nil or vim.g.autoformat
            local buffer = vim.b[buf].autoformat == nil and global or vim.b[buf].autoformat

            local lines = {
              "# Autoformat Status",
              "- [" .. (global and "x" or " ") .. "]Global: " .. (global and "**Enabled**" or "**Disabled**"),
              "- [" .. (buffer and "x" or " ") .. "] Buffer: " .. (buffer and "**Enabled**" or "**Disabled**"),
            }

            Snacks.notify[buffer and "info" or "warn"](
              table.concat(lines, "\n"),
              { title = "Autoformat " .. (buffer and "Enabled" or "Disabled") }
            )
          end,
        })
      end

      toggle_format():map("<leader>uF")
      toggle_format(vim.api.nvim_get_current_buf()):map("<leader>uf")
    end
  '';
}
