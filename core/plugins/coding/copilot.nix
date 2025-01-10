_: {
  plugins = {
    copilot-lua = {
      enable = true;

      settings = {
        filetypes = {
          markdown = true;
          help = true;
        };

        suggestion = {
          enabled = true;
          autoTrigger = true;
          keymap = {
            accept = "<c-a>";
            prev = "<c-[>";
            next = "<c-]>";

            dismiss = "<c-q>";
          };
        };
      };
    };

    copilot-chat = {
      enable = true;
      settings = {
        window.border = "rounded";
      };
    };

    lualine.settings.sections.lualine_x = [
      {
        __unkeyed-1.__raw = ''
          function()
            local status = require("copilot.api").status.data
            local icon = " "
            return icon .. (status.message or "")
          end
        '';
        cond.__raw = ''
          function()
            local clients = vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
            return #clients > 0
          end
        '';
        color.__raw = ''
          function()
            local status = require("copilot.api").status.data.status
            if status == "Warning" then
              return "DiagnosticError"
            elseif status == "InProgress" then
              return "DiagnosticWarn"
            end
            return "Special"
          end
        '';
      }
    ];
  };

  performance.combinePlugins.standalonePlugins = ["copilot.lua"];
}
