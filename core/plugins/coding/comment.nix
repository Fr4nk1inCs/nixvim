_: {
  plugins.ts-comments = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
        on_require = ["ts-comments"];
      };
    };

    settings.lang = {
      typst = "// %s";
    };
  };
}
