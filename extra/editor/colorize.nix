_: {
  plugins.colorizer = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
        on_require = ["colorizer"];
      };
    };

    settings = {
      user_default_options = {
        RGB = true;
        RRGGBB = true;
        mode = "virtualtext";
      };
      filetypes = {
        __unkeyed-1 = ''["*"]'';
        css = {
          css = true;
        };
        sass = {
          css = true;
          sass.enable = true;
        };
        html = {
          css = true;
          tailwind = true;
        };
      };
    };
  };
}
