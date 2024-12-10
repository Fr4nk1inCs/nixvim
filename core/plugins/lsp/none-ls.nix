_: {
  plugins.none-ls = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.event = ["BufReadPost" "BufNewFile" "BufWritePre"];
    };
    settings = {
      border = "rounded";
    };
  };
}
