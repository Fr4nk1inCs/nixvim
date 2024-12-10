_: {
  keymaps = [
    {
      key = "<leader>fe";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = utils.root() })
        end
      '';
      options = {
        desc = "File explorer (root)";
        silent = true;
      };
    }
    {
      key = "<leader>fE";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end
      '';
      options = {
        desc = "File explorer (cwd)";
        silent = true;
      };
    }
    {
      key = "<leader>e";
      action = "<leader>fe";
      options = {
        desc = "File explorer (root)";
        remap = true;
        silent = true;
      };
    }
    {
      key = "<leader>E";
      action = "<leader>fE";
      options = {
        desc = "File explorer (cwd)";
        remap = true;
        silent = true;
      };
    }
    {
      key = "<leader>ge";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, source = "git_status" })
        end
      '';
      options = {
        desc = "Git explorer";
        silent = true;
      };
    }
    {
      key = "<leader>be";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, source = "buffers" })
        end
      '';
      options = {
        desc = "Buffer explorer";
        silent = true;
      };
    }
    {
      key = "<leader>se";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, source = "document_symbols" })
        end
      '';
      options = {
        desc = "Symbol explorer";
        silent = true;
      };
    }
  ];

  plugins.neo-tree = {
    enable = true;

    # TODO: Wait for nixvim team to support lazy loading for this plugin

    popupBorderStyle = "rounded";

    defaultComponentConfigs = {
      indent = {
        withExpanders = true;
        expanderCollapsed = "";
        expanderExpanded = "";
        expanderHighlight = "NeoTreeExpander";
      };
      gitStatus = {
        symbols = {
          unstaged = "󰄱";
          staged = "󰱒";
        };
      };
      icon = {
        folderClosed = "";
        folderOpen = "";
        folderEmpty = "";
      };
    };

    filesystem = {
      filteredItems.hideDotfiles = false;
      groupEmptyDirs = false;
      followCurrentFile.enabled = true;
    };

    defaultSource = "filesystem";
    sources = [
      "filesystem"
      "buffers"
      "git_status"
      "document_symbols"
    ];
    sourceSelector = {
      winbar = true;
      padding = 1;
      highlightTab = "BufferLineBuffer";
      highlightTabActive = "BufferLineBufferSelected";
      highlightBackground = "BufferLineBuffer";
      highlightSeparator = "BufferLineSeparator";
      highlightSeparatorActive = "BufferLineSeparatorSelected";
      sources = [
        {
          source = "filesystem";
          displayName = " Files";
        }
        {
          source = "buffers";
          displayName = " Buffers";
        }
        {
          source = "git_status";
          displayName = " Git";
        }
        {
          source = "document_symbols";
          displayName = " Symbols";
        }
      ];
    };
    eventHandlers = let
      onMove.__raw = ''
        function(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end
      '';
    in {
      file_moved = onMove.__raw;
      file_renamed = onMove.__raw;
    };
  };

  plugins.yazi = {
    enable = true;

    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
        on_require = ["yazi"];
        keys = [
          {
            __unkeyed-1 = "<leader>y";
            __unkeyed-2 = "<cmd>Yazi toggle<cr>";
            desc = "Resume last yazi session";
          }
          {
            __unkeyed-1 = "<leader>fy";
            __unkeyed-2 = "<cmd>Yazi cwd<cr>";
            desc = "Open yazi at current working directory";
          }
          {
            __unkeyed-1 = "<leader>fY";
            __unkeyed-2 = "<cmd>Yazi<cr>";
            desc = "Open yazi at currtn buffer";
          }
        ];
      };
    };

    settings.keymaps = {
      open_file_in_horizontal_split = "<c-h>";
      change_working_directory = "<c-d>";
    };
  };

  autoCmd = [
    {
      event = "TermClose";
      pattern = "*lazygit";
      callback.__raw = ''
        function()
          require("neo-tree.sources.git_status").refresh()
        end
      '';
    }
  ];
}
