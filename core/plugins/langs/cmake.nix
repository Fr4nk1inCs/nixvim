{pkgs, ...}: {
  plugins = {
    treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.cmake];
    lsp.servers.cmake.enable = true;
    cmake-tools = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          on_require = ["cmake-tools"];
          ft = ["c" "cpp" "cuda" "cmake"];
        };
      };
    };
    none-ls.sources.diagnostics.cmake_lint.enable = true;
  };
}
