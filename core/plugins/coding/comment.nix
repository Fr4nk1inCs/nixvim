_: {
  plugins.ts-comments = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.event = "DeferredUIEnter";
    };
    settings.lang = {
      typst = "// %s";
    };
  };
}
