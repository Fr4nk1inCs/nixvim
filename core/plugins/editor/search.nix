{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    grug-far-nvim
  ];

  extraConfigLua = ''
    require("grug-far").setup({ headerMaxWidth = 80 })
  '';

  keymaps = [
    {
      key = "<leader>sr";
      mode = ["n" "v"];
      action.__raw = ''
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").grug_far({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end
      '';
      options = {
        desc = "Search & Replace";
        silent = true;
      };
    }
  ];
}
