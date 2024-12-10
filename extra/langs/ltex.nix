_: {
  plugins.ltex-extra = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        on_require = ["ltex_extra"];
        ft = ["markdown" "tex" "latex"];
      };
    };

    settings = {
      load_langs = ["en-US" "zh-CN"];
      path = ".ltex";
    };
  };
}
