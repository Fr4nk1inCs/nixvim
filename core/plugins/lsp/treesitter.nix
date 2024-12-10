{pkgs, ...}: {
  plugins = {
    treesitter = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          lazy.__raw = "vim.fn.argc(-1) == 0";
          on_require = ["nvim-treesitter"];
          event = ["BufReadPost" "BufNewFile" "BufWritePre" "DeferredUIEnter"];
          cmd = ["TSUpdateSync" "TSUpdate" "TSInstall"];
        };
      };

      folding = true;
      nixvimInjections = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        diff
        html
        javascript
        jsdoc
        json
        jsonc
        lua
        luadoc
        luap
        markdown
        markdown_inline
        printf
        python
        query
        regex
        toml
        tsx
        typescript
        vim
        vimdoc
        xml
        yaml
      ];

      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
    };

    treesitter-textobjects = {
      enable = true;
      move = {
        enable = true;
        gotoNextStart = {
          "]f" = "@function.outer";
          "]c" = "@class.outer";
          "]a" = "@parameter.inner";
        };
        gotoNextEnd = {
          "]F" = "@function.outer";
          "]C" = "@class.outer";
          "]A" = "@parameter.inner";
        };
        gotoPreviousStart = {
          "[f" = "@function.outer";
          "[c" = "@class.outer";
          "[a" = "@parameter.inner";
        };
        gotoPreviousEnd = {
          "[F" = "@function.outer";
          "[C" = "@class.outer";
          "[A" = "@parameter.inner";
        };
      };
    };

    ts-autotag.enable = true;

    treesitter-context = {
      enable = true;
      settings = {
        mode = "cursor";
        max_lines = 3;
      };
    };
  };

  highlight = {
    TreesitterContextBottom = {
      underline = true;
    };
  };

  extraConfigLuaPost = ''
    Snacks.toggle.treesitter():map("<leader>ut")
  '';
}
