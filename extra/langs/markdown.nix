_: {
  plugins = {
    markview = {
      enable = true;
      # It is not recommended to lazy load this plugin.
      lazyLoad.enable = false;
      settings = {
        headings = {
          shift_width = 0;
        };

        list_items = {
          indent_size = 2;
          shift_width = 2;
        };
        callbacks.on_enable.__raw = ''
          function(_, window)
            vim.wo[window].conceallevel = 2
          end
        '';
      };
    };

    none-ls.sources.formatting.prettier.enable = true;
    none-ls.sources.diagnostics.markdownlint_cli2.enable = true;
  };
}
