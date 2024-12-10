{pkgs, ...}: {
  plugins = {
    treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.json5];
    lsp.servers.jsonls = {
      enable = true;
      settings.json = {
        format.enable = true;
        validate.enable = true;
      };
      extraOptions.on_new_config.__raw = ''
        function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end
      '';
    };

    # TODO: Wait for nixvim team to support lazy loading for this plugin
    schemastore.enable = true;
  };
}
