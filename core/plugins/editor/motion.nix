_: let
  flash = func: {__raw = ''function() require("flash").${func}() end'';};
in {
  plugins.flash.enable = true;
  keymaps = [
    {
      key = "s";
      mode = ["n" "x" "o"];
      action = flash "jump";
      options = {
        desc = "Flash";
        silent = true;
      };
    }
    {
      key = "S";
      mode = ["n" "x" "o"];
      action = flash "treesitter";
      options = {
        desc = "Flash Treesitter";
        silent = true;
      };
    }
    {
      key = "r";
      mode = "o";
      action = flash "remote";
      options = {
        desc = "Remote flash";
        silent = true;
      };
    }
    {
      key = "R";
      mode = ["x" "o"];
      action = flash "treesitter_search";
      options = {
        desc = "Treesitter search";
        silent = true;
      };
    }
    {
      key = "<c-s>";
      mode = "c";
      action = flash "toggle";
      options = {
        desc = "Toggle flash search";
        silent = true;
      };
    }
  ];
}
