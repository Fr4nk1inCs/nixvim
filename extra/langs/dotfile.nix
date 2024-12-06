{pkgs, ...}: {
  filetype = {
    extension = {
      rasi = "rasi";
      rofi = "rasi";
      wofi = "rasi";
    };
    filename.vifmrc = "vim";
    pattern = {
      ".*/waybar/config(%.json)?" = "jsonc";
      ".*/mako/config" = "dosini";
      ".*/kitty/.+%.conf" = "bash";
      ".*/hypr/.+%.conf" = "hyprlang";
      "%.env%.[%w_.-]+" = "sh";
    };
  };

  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    git_config
    hyprlang
    rasi
  ];
}
