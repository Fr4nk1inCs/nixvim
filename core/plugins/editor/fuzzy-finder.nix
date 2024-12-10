{pkgs, ...}: let
  actions = func: {__raw = ''require("fzf-lua.actions").${func}'';};
  UISelect.__raw = ''
    function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        winopts = {
          layout = "vertical",
          -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
          width = 0.5,
          preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
            layout = "vertical",
            vertical = "down:15,border-top",
            hidden = "hidden",
          } or {
            layout = "vertical",
            vertical = "down:15,border-top",
          },
        },
      } or {
        winopts = {
          width = 0.5,
          -- height is number of items, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
        },
      })
    end
  '';
  toggleRootDir.__raw = ''
    function(_, ctx)
      local o = vim.deepcopy(ctx.__call_opts)
      o.root = o.root == false
      o.buf = ctx.__CTX.bufnr

      o.cwd = o.root and utils.root({ buf = o.buf }) or nil
      require("fzf-lua")[ctx.__INFO.cmd](o)
    end
  '';
  openInRoot = cmd: {
    __raw = ''
      function()
        local buf = vim.api.nvim_get_current_buf()
        local cwd = utils.root({ buf = buf })
        require("fzf-lua").${cmd}({ cwd = cwd, root = true })
      end
    '';
  };
  openInCwd = cmd: {
    __raw = ''
      function()
        require("fzf-lua").${cmd}({ cwd = cwd, root = false })
      end
    '';
  };
  lspOperation = cmd: "<cmd>FzfLua lsp_${cmd} jump_to_single_result=true ignore_current_line=true<cr>";
  map = keymap: {
    inherit (keymap) key;
    mode = keymap.mode or "n";
    inherit (keymap) action;
    options = {
      inherit (keymap) desc;
      silent = true;
    };
  };
in {
  plugins = {
    fzf-lua = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          # FIXME: This is a workaround with fzf-lua and lz.n
          # cmd = "FzfLua";
          on_require = ["fzf-lua"];
          keys = [
            {
              __unkeyed-1 = "<leader>,";
              __unkeyed-2 = "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>";
              desc = "Switch buffer";
            }
            {
              __unkeyed-1 = "<leader>:";
              __unkeyed-2 = "<cmd>FzfLua command_history<cr>";
              desc = "Command history";
            }
            {
              __unkeyed-1 = "<leader>fb";
              __unkeyed-2 = "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>";
              desc = "Switch buffer";
            }
            {
              __unkeyed-1 = "<leader>fg";
              __unkeyed-2 = "<cmd>FzfLua git_files<cr>";
              desc = "Find files (git-files)";
            }
            {
              __unkeyed-1 = "<leader>fr";
              __unkeyed-2 = "<cmd>FzfLua oldfiles<cr>";
              desc = "Recent files";
            }
            {
              __unkeyed-1 = "<leader>gc";
              __unkeyed-2 = "<cmd>FzfLua git_commits<cr>";
              desc = "Git commits";
            }
            {
              __unkeyed-1 = "<leader>gs";
              __unkeyed-2 = "<cmd>FzfLua git_status<cr>";
              desc = "Git status";
            }
            {
              __unkeyed-1 = "<leader>s\"";
              __unkeyed-2 = "<cmd>FzfLua registers<cr>";
              desc = "Registers";
            }
            {
              __unkeyed-1 = "<leader>sa";
              __unkeyed-2 = "<cmd>FzfLua autocmds<cr>";
              desc = "Autocommands";
            }
            {
              __unkeyed-1 = "<leader>sb";
              __unkeyed-2 = "<cmd>FzfLua grep_curbuf<cr>";
              desc = "Grep buffer";
            }
            {
              __unkeyed-1 = "<leader>sc";
              __unkeyed-2 = "<cmd>FzfLua command_history<cr>";
              desc = "Command history";
            }
            {
              __unkeyed-1 = "<leader>sC";
              __unkeyed-2 = "<cmd>FzfLua commands<cr>";
              desc = "Commands";
            }
            {
              __unkeyed-1 = "<leader>sd";
              __unkeyed-2 = "<cmd>FzfLua diagnostics_document<cr>";
              desc = "Document diagnostics";
            }
            {
              __unkeyed-1 = "<leader>sD";
              __unkeyed-2 = "<cmd>FzfLua diagnostics_workspace<cr>";
              desc = "Workspace diagnostics";
            }
            {
              __unkeyed-1 = "<leader>sh";
              __unkeyed-2 = "<cmd>FzfLua help_tags<cr>";
              desc = "Help pages";
            }
            {
              __unkeyed-1 = "<leader>sH";
              __unkeyed-2 = "<cmd>FzfLua highlights<cr>";
              desc = "Search highlights";
            }
            {
              __unkeyed-1 = "<leader>sj";
              __unkeyed-2 = "<cmd>FzfLua jumps<cr>";
              desc = "Jumplist";
            }
            {
              __unkeyed-1 = "<leader>sk";
              __unkeyed-2 = "<cmd>FzfLua keymaps<cr>";
              desc = "Keymaps";
            }
            {
              __unkeyed-1 = "<leader>sl";
              __unkeyed-2 = "<cmd>FzfLua loclist<cr>";
              desc = "Loclist";
            }
            {
              __unkeyed-1 = "<leader>sm";
              __unkeyed-2 = "<cmd>FzfLua marks<cr>";
              desc = "Jump to marks";
            }
            {
              __unkeyed-1 = "<leader>sM";
              __unkeyed-2 = "<cmd>FzfLua man_pages<cr>";
              desc = "Man pages";
            }
            {
              __unkeyed-1 = "<leader>sR";
              __unkeyed-2 = "<cmd>FzfLua resume<cr>";
              desc = "Resume FZF";
            }
            {
              __unkeyed-1 = "<leader>sq";
              __unkeyed-2 = "<cmd>FzfLua quickfix<cr>";
              desc = "Quickfix list";
            }
            {
              __unkeyed-1 = "<leader>ss";
              __unkeyed-2 = "<cmd>FzfLua lsp_document_symbols<cr>";
              desc = "Document symbols";
            }
            {
              __unkeyed-1 = "<leader>sS";
              __unkeyed-2 = "<cmd>FzfLua lsp_workspace_symbols<cr>";
              desc = "Workspace symbols";
            }
            {
              __unkeyed-1 = "<leader>uC";
              __unkeyed-2 = "<cmd>FzfLua colorschemes<cr>";
              desc = "Colorschemes";
            }
            {
              __unkeyed-1 = "<leader>/";
              __unkeyed-2 = openInRoot "live_grep";
              desc = "Live grep (root)";
            }
            {
              __unkeyed-1 = "<leader><space>";
              __unkeyed-2 = openInRoot "files";
              desc = "Find files (root)";
            }
            {
              __unkeyed-1 = "<leader>ff";
              __unkeyed-2 = openInRoot "files";
              desc = "Find files (root)";
            }
            {
              __unkeyed-1 = "<leader>fF";
              __unkeyed-2 = openInCwd "files";
              desc = "Find files (cwd)";
            }
            {
              __unkeyed-1 = "<leader>fR";
              __unkeyed-2.__raw = ''
                  function() require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() })
                end'';
              desc = "Recent files (cwd)";
            }
            {
              __unkeyed-1 = "<leader>sg";
              __unkeyed-2 = openInRoot "live_grep";
              desc = "Live grep (root)";
            }
            {
              __unkeyed-1 = "<leader>sG";
              __unkeyed-2 = openInCwd "live_grep";
              desc = "Live grep (cwd)";
            }
            {
              __unkeyed-1 = "<leader>sw";
              __unkeyed-2 = openInRoot "grep_cword";
              desc = "Grep word (root)";
            }
            {
              __unkeyed-1 = "<leader>sW";
              __unkeyed-2 = openInCwd "grep_cword";
              desc = "Grep word (cwd)";
            }
            {
              __unkeyed-1 = "<leader>sw";
              __unkeyed-2 = openInRoot "grep_visual";
              mode = "v";
              desc = "Grep selection (root)";
            }
            {
              __unkeyed-1 = "<leader>sW";
              __unkeyed-2 = openInCwd "grep_visual";
              mode = "v";
              desc = "Grep selection (cwd)";
            }
          ];
        };
      };

      profile.__raw = ''"default-title"'';

      settings = {
        fzf_color = true;
        winopts = {
          width = 0.8;
          height = 0.8;
          row = 0.5;
          col = 0.5;
          preview = {
            scrollchars = ["┃" ""];
          };
        };
        files = {
          actions = {
            "alt-i" = [(actions "toggle_ignore")];
            "alt-h" = [(actions "toggle_hidden")];
          };
        };
        grep = {
          actions = {
            "alt-i" = [(actions "toggle_ignore")];
            "alt-h" = [(actions "toggle_hidden")];
          };
        };
        lsp = {
          symbol_fmt.__raw = ''function(s) return s:lower() .. ":" end'';
          code_actions.previewer = "codeaction_native";
        };
        actions.files = {
          __unkeyed-1 = true;
          "ctrl-t".__raw = ''require("trouble.sources.fzf").actions.open'';
          "ctrl-r" = toggleRootDir;
          "alt-c" = toggleRootDir;
        };
        keymap = {
          fzf = {
            "ctrl-q" = "select-all+select";
            "ctrl-u" = "half-page-up";
            "ctrl-d" = "half-page-down";
            "ctrl-x" = "jump";
            "ctrl-f" = "preview-page-down";
            "ctrl-b" = "preview-page-up";
          };

          builtin = {
            "<c-f>" = "preview-page-down";
            "<c-b>" = "preview-page-up";
          };
        };
        previewers.builtin = {
          extensions = {
            png = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
            svg = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
            jpg = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
            gif = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
          };
        };
      };
    };

    lsp.keymaps.extra = [
      (map {
        key = "gd";
        action = lspOperation "definitions";
        desc = "Goto definition";
      })
      (map {
        key = "gr";
        action = lspOperation "references";
        desc = "References";
      })
      (map {
        key = "gI";
        action = lspOperation "implementations";
        desc = "Goto implementation";
      })
      (map {
        key = "gy";
        action = lspOperation "typedefs";
        desc = "Goto t[y]pe definition";
      })
    ];

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>f";
        group = "File / Find";
      }
      {
        __unkeyed-1 = "<leader>s";
        group = "Search";
      }
    ];
  };

  extraConfigLuaPost = ''
    do
      -- lazy load fzf-lua for ui.select
      local old_uiselect = vim.ui.select
      vim.ui.select = function(...)
        require("lz.n").trigger_load("fzf-lua")
        require("fzf-lua").register_ui_select(${UISelect.__raw})
        return vim.ui.select(...)
      end
    end
  '';
}
