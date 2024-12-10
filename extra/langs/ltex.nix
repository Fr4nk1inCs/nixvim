_: {
  plugins.ltex-extra = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        ft = ["markdown" "tex" "latex"];
      };
    };

    settings = {
      load_langs = ["en-US" "zh-CN"];
      path = ".ltex";
    };
  };
}
