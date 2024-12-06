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
    {
      key = "<leader>y";
      action = "<cmd>Yazi toggle<cr>";
      options = {
        desc = "Resume last yazi session";
        silent = true;
      };
    }
    {
      key = "<leader>fy";
      action = "<cmd>Yazi cwd<cr>";
      options = {
        desc = "Open yazi at current working directory";
        silent = true;
      };
    }
    {
      key = "<leader>fY";
      action = "<cmd>Yazi<cr>";
      options = {
        desc = "Open yazi at currtn buffer";
        silent = true;
      };
    }
  ];

  plugins.neo-tree = {
    enable = true;

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
