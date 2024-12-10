_: let
  highlights = [
    "TSRainbowRed"
    "TSRainbowYellow"
    "TSRainbowBlue"
    "TSRainbowOrange"
    "TSRainbowGreen"
    "TSRainbowViolet"
    "TSRainbowCyan"
  ];
in {
  plugins.indent-blankline = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = ["BufReadPost" "BufNewFile" "BufEnter" "DeferredUIEnter"];
        on_require = ["ibl"];
      };
    };

    settings = {
      indent = {
        char = "│";
        tab_char = "│";
      };

      scope.highlight = highlights;

      exclude.filetypes = [
        "help"
        "alpha"
        "dashboard"
        "neo-tree"
        "Trouble"
        "trouble"
        "notify"
        "toggleterm"
        "lazygit"
      ];
    };
  };

  extraConfigLuaPre = ''
    -- Configure indent-blankline highlights
    do
      local highlights = {
        "TSRainbowRed",
        "TSRainbowYellow",
        "TSRainbowBlue",
        "TSRainbowOrange",
        "TSRainbowGreen",
        "TSRainbowViolet",
        "TSRainbowCyan",
      }

      local get_hl = function(name)
        local specs = vim.api.nvim_get_hl(0, { name = name })
        local hl = {}
        for k, v in pairs(specs) do
            hl[k] = string.format("#%06x", v)
        end
        return hl
      end

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for _, hl in ipairs(highlights) do
            vim.api.nvim_set_hl(0, hl, get_hl(hl))
        end
      end)
    end
  '';

  extraConfigLuaPost = ''
    do
      -- Setup indent-blankline scope highlights
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end

    do
      Snacks.toggle({
        name = "indention guides",
        get = function()
          return require("ibl.config").get_config(0).enabled
        end,
        set = function(state)
          require("ibl").setup_buffer(0, { enabled = state })
        end,
      }):map("<leader>ui")
    end
  '';
}
