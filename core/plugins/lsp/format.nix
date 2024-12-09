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
          if vim.g.autoformat == nil then
            vim.g.autoformat = true
          end
          local format = vim.b[event.buf].autoformat ~= nil and vim.b[event.buf].autoformat or vim.g.autoformat
          if format then
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
      local function toggle_format(bufonly)
        return Snacks.toggle({
          name = "autoformat (" .. (bufonly and "buffer" or "global") .. ")",
          get = function()
            local buf = vim.api.nvim_get_current_buf()
            if not bufonly or vim.b[buf].autoformat == nil then
              return vim.g.autoformat
            end
            return vim.b[buf].autoformat
          end,
          set = function(state)
            local buf = vim.api.nvim_get_current_buf()
            if bufonly then
              vim.b[buf].autoformat = state
            else
              vim.g.autoformat = state
              vim.b[buf].autoformat = nil
            end

            local global = vim.g.autoformat
            local buffer = state

            local lines = {
              "# Autoformat Status",
              "- [" .. (global and "x" or " ") .. "] Global: " .. (global and "**Enabled**" or "**Disabled**"),
              "- [" .. (buffer and "x" or " ") .. "] Buffer: " .. (buffer and "**Enabled**" or "**Disabled**"),
            }

            Snacks.notify[buffer and "info" or "warn"](
              table.concat(lines, "\n"),
              { title = "Autoformat " .. (buffer and "Enabled" or "Disabled") }
            )
          end,
        })
      end

      toggle_format(false):map("<leader>uF")
      toggle_format(true):map("<leader>uf")
    end
  '';
}
