_: {
  plugins = {
    lsp.servers.lua_ls = {
      enable = true;
      settings.Lua = {
        workspace = {
          checkThirdParty = false;
        };
        codeLens = {
          enable = true;
        };
        completion = {
          callSnippet = "Replace";
        };
        doc = {
          privateName = ["^_"];
        };
        hint = {
          enable = true;
          setType = false;
          paramType = true;
          paramName = "Disable";
          semicolon = "Disable";
          arrayIndex = "Disable";
        };
      };
    };

    none-ls.sources.formatting.stylua.enable = true;
  };
}
