_: {
  plugins.smartcolumn = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.event = "DeferredUIEnter";
    };
    settings = {
      disabled_filetypes = [
        "help"
        "text"
        "tex"
        "markdown"
        "dashboard"
        "lazy"
        "mason"
        "neo-tree"
        "help"
        "checkhealth"
        "lspinfo"
        "noice"
        "Trouble"
        "fish"
        "zsh"
        "leetcode.nvim"
      ];
    };
  };
}
