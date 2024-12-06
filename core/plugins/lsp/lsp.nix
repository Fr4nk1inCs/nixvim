_: let
  severity = s: "vim.diagnostic.severity.${s}";
in {
  plugins.lsp = {
    enable = true;
    inlayHints = true;

    keymaps = {
      lspBuf = {
        K = {
          action = "hover";
          desc = "Hover";
        };
        gK = {
          action = "signature_help";
          desc = "Signature help";
        };
        "<leader>cr" = {
          action = "rename";
          desc = "Rename";
        };
      };
      extra = [
        {
          key = "<c-s>";
          action.__raw = "vim.lsp.buf.signature_help";
          mode = "i";
          options.desc = "Signature help";
        }
        {
          key = "<leader>ca";
          action.__raw = "vim.lsp.buf.code_action";
          mode = ["n" "v"];
          options.desc = "Code action";
        }
        {
          key = "<leader>cc";
          action.__raw = "vim.lsp.codelens.run";
          mode = ["n" "v"];
          options.desc = "Run codelens";
        }
        {
          key = "<leader>cC";
          action.__raw = "vim.lsp.codelens.refresh";
          options.desc = "Refresh & Display codelens";
        }
      ];
      silent = true;
    };
  };

  diagnostics = {
    underline = true;
    update_in_insert = false;
    virtual_text = {
      spacing = 4;
      source = "if_many";
    };
    severity_sort = true;
    signs.text.__raw = ''
      {
        [${severity "ERROR"}] = " ",
        [${severity "WARN"}] = " ",
        [${severity "INFO"}] = " ",
        [${severity "HINT"}] = " "
      }'';
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "g";
      group = "goto";
    }
  ];

  extraConfigLuaPost = ''
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.inlay_hints():map("<leader>ud")
  '';
}
