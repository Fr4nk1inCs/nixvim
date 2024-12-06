{...}: {
  imports = [
    ./config
    ./plugins
  ];

  viAlias = true;
  vimAlias = true;
  withNodeJs = true;
  withPerl = true;
  withPython3 = true;
  withRuby = true;

  luaLoader.enable = true;

  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;
      standalonePlugins = ["nvim-treesitter"];
    };
  };
}
