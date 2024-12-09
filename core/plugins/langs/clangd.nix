{
  pkgs,
  lib,
  ...
}: {
  plugins = {
    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      cpp
      cuda
    ];
    clangd-extensions = {
      enable = true;
      ast = {
        roleIcons = {
          type = "";
          declaration = "";
          expression = "";
          specifier = "";
          statement = "";
          templateArgument = "";
        };
        kindIcons = {
          compound = "";
          recovery = "";
          translationUnit = "";
          packExpansion = "";
          templateTypeParm = "";
          templateTemplateParm = "";
          templateParamObject = "";
        };
      };
    };

    lsp.servers.clangd = {
      enable = true;

      rootDir.__raw = ''
        function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or util.root_pattern(
            "compile_commands.json",
            "compile_flags.txt"
          )(fname) or util.find_git_ancestor(fname)
        end
      '';

      cmd = [
        "clangd"
        "--background-index"
        "--clang-tidy"
        "--header-insertion=iwyu"
        "--completion-style=detailed"
        "--function-arg-placeholders"
        "--fallback-style=llvm"
      ];

      extraOptions = {
        capabilities = {
          offsetEncoding = ["utf-16"];
        };
        init_options = {
          usePlaceholders = true;
          completeUnimported = true;
          clangdFileStatus = true;
        };
      };
    };

    cmp.settings.sorting.comparators = lib.mkForce [
      "require('cmp.config.compare').offset"
      "require('cmp.config.compare').exact"
      "require('clangd_extensions.cmp_scores')"
      "require('cmp.config.compare').recently_used"
      "require('cmp.config.compare').locality"
      "require('cmp.config.compare').kind"
      "require('cmp.config.compare').length"
      "require('cmp.config.compare').order"
    ];

    dap = {
      adapters.executables.lldb = {
        command = lib.getExe' pkgs.lldb (
          if pkgs.stdenv.isLinux
          then "lldb-dap"
          else "lldb-vscode"
        );
      };

      configurations.c = [
        {
          name = "Launch (LLDB)";
          type = "lldb";
          request = "launch";
          program.__raw = ''
            function()
                return vim.fn.input("Path to executable (should be compiled with -gdwarf-4): ", vim.fn.getcwd() .. '/', "file")
            end'';
          cwd = "\${workspaceFolder}";
          runInTerminal = true;
        }
      ];

      configurations.cpp = [
        {
          name = "Launch (LLDB)";
          type = "lldb";
          request = "launch";
          program.__raw = ''
            function()
                return vim.fn.input("Path to executable (should be compiled with -gdwarf-4): ", vim.fn.getcwd() .. '/', "file")
            end'';
          cwd = "\${workspaceFolder}";
          runInTerminal = true;
        }
      ];
    };
  };
}
