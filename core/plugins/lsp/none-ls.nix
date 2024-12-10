_: {
  plugins.none-ls = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        event = ["BufReadPost" "BufNewFile" "BufWritePre"];
        on_require = ["null-ls"];
      };
    };
    settings = {
      border = "rounded";
    };
  };
}
