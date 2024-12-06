{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    dropbar-nvim
  ];
}
