{pkgs, ...}: let
  savePath =
    if pkgs.isWsl
    then "/mnt/c/Users/fushen/Pictures/CodeSnap"
    else "~/Pictures/CodeSnap";
in {
  plugins.codesnap = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        on_require = ["codesnap"];
        event = ["BufReadPost" "BufNewFile" "BufWritePre"];
      };
    };

    settings = {
      save_path = savePath;
      has_breadcrumbs = true;
      bg_theme = "sea";
      code_font_family = "Maple Mono NF CN";
    };
  };
  extraPackages = with pkgs; [maple-mono];
  performance.combinePlugins.standalonePlugins = ["codesnap.nvim"];
  extraConfigLuaPost = ''
    do
      local codesnap_save_path = vim.fn.expand("${savePath}")
      if vim.fn.isdirectory(codesnap_save_path) == 0 then
        vim.fn.mkdir(codesnap_save_path, "p")
      end
    end
  '';
}
