_: let
  flash = func: {__raw = ''function() require("flash").${func}() end'';};
in {
  plugins.flash = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
        on_require = ["flash"];
        keys = [
          {
            __unkeyed-1 = "s";
            __unkeyed-2 = flash "jump";
            mode = ["n" "x" "o"];
            desc = "Flash";
          }
          {
            __unkeyed-1 = "S";
            __unkeyed-2 = flash "treesitter";
            mode = ["n" "x" "o"];
            desc = "Flash Treesitter";
          }
          {
            __unkeyed-1 = "r";
            __unkeyed-2 = flash "remote";
            mode = "o";
            desc = "Remote flash";
          }
          {
            __unkeyed-1 = "R";
            __unkeyed-2 = flash "treesitter_search";
            mode = ["x" "o"];
            desc = "Treesitter search";
          }
          {
            __unkeyed-1 = "<c-s>";
            __unkeyed-2 = flash "toggle";
            mode = "c";
            desc = "Toggle flash search";
          }
        ];
      };
    };
  };
}
