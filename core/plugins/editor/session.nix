_: {
  plugins.auto-session = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings.event = "DeferredUIEnter";
    };

    settings = {
      auto_restore = false;
      cwd_change_handling = true;
      bypass_save_filetypes = ["dashboard"];
    };
  };
}
