_: let
  jump = direction: {
    __raw = ''
      function() require("todo-comments").jump_${direction}() end
    '';
  };
  fzf = keywords: {
    __raw = ''
      function() require("todo-comments.fzf").todo({ keywords = ${keywords} }) end
    '';
  };
in {
  plugins.todo-comments = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = ["BufReadPost" "BufNewFile" "BufWritePre"];
        on_require = ["todo-comments"];
        keys = [
          {
            __unkeyed-1 = "]t";
            __unkeyed-2 = jump "next";
            desc = "Next todo comment";
          }
          {
            __unkeyed-1 = "[t";
            __unkeyed-2 = jump "prev";
            desc = "Previous todo comment";
          }
          {
            __unkeyed-1 = "<leader>xt";
            __unkeyed-2 = "<cmd>Trouble todo toggle<cr>";
            desc = "Todo (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>xT";
            __unkeyed-2 = "<cmd>Trouble todo toggle filter = { tag = {TODO,FIX,FIXME} }<cr>";
            desc = "Todo/Fix/Fixme (Trouble)";
          }
          {
            __unkeyed-1 = "<leader>st";
            __unkeyed-2 = fzf "nil";
            desc = "Search todo comments";
          }
          {
            __unkeyed-1 = "<leader>sT";
            __unkeyed-2 = fzf ''{ "TODO", "FIX", "FIXME" }'';
            desc = "Search todo comments (TODO, FIX, FIXME)";
          }
        ];
      };
    };
  };
}
