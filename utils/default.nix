_: {
  plugins.snacks = {
    enable = true;

    settings = {
      dashboard.enabled = false;
    };
  };

  extraConfigLuaPre = ''
    local utils = {}

    utils.norm = function(path)
      if path:sub(1, 1) == "~" then
        local home = vim.uv.os_homedir()
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
          home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
      end
      path = path:gsub("\\", "/"):gsub("/+", "/")
      return path:sub(-1) == "/" and path:sub(1, -2) or path
    end

    do
      local M = setmetatable({}, { __call = function(m) return m.get() end })

      M.spec = vim.g.root_spec

      M.detectors = {}

      function M.detectors.cwd()
        return { vim.uv.cwd() }
      end

      function M.detectors.lsp(buf)
        local bufpath = M.bufpath(buf)
        if not bufpath then
          return {}
        end
        local roots = {} ---@type string[]
        for _, client in pairs(vim.lsp.get_clients({ bufnr = buf })) do
          local workspace = client.config.workspace_folders
          for _, ws in pairs(workspace or {}) do
            roots[#roots + 1] = vim.uri_to_fname(ws.uri)
          end
          if client.root_dir then
            roots[#roots + 1] = client.root_dir
          end
        end
        return vim.tbl_filter(function(path)
          path = utils.norm(path)
          return path and bufpath:find(path, 1, true) == 1
        end, roots)
      end

      ---@param patterns string[]|string
      function M.detectors.pattern(buf, patterns)
        patterns = type(patterns) == "string" and { patterns } or patterns
        local path = M.bufpath(buf) or vim.uv.cwd()
        local pattern = vim.fs.find(function(name)
          for _, p in ipairs(patterns) do
            if name == p then
              return true
            end
            if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
              return true
            end
          end
          return false
        end, { path = path, upward = true })[1]
        return pattern and { vim.fs.dirname(pattern) } or {}
      end


      function M.bufpath(buf)
        return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
      end

      function M.cwd()
        return M.realpath(vim.uv.cwd()) or ""
      end

      function M.realpath(path)
        if path == "" or path == nil then
          return nil
        end
        path = vim.uv.fs_realpath(path) or path
        return utils.norm(path)
      end

      ---@param spec LazyRootSpec
      ---@return LazyRootFn
      function M.resolve(spec)
        if M.detectors[spec] then
          return M.detectors[spec]
        elseif type(spec) == "function" then
          return spec
        end
        return function(buf)
          return M.detectors.pattern(buf, spec)
        end
      end

      ---@param opts? { buf?: number, spec?: LazyRootSpec[], all?: boolean }
      function M.detect(opts)
        opts = opts or {}
        opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
        opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

        local ret = {} ---@type LazyRoot[]
        for _, spec in ipairs(opts.spec) do
          local paths = M.resolve(spec)(opts.buf)
          paths = paths or {}
          paths = type(paths) == "table" and paths or { paths }
          local roots = {} ---@type string[]
          for _, p in ipairs(paths) do
            local pp = M.realpath(p)
            if pp and not vim.tbl_contains(roots, pp) then
              roots[#roots + 1] = pp
            end
          end
          table.sort(roots, function(a, b)
            return #a > #b
          end)
          if #roots > 0 then
            ret[#ret + 1] = { spec = spec, paths = roots }
            if opts.all == false then
              break
            end
          end
        end
        return ret
      end

      function M.info()
        local spec = type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec

        local roots = M.detect({ all = true })
        local lines = {} ---@type string[]
        local first = true
        for _, root in ipairs(roots) do
          for _, path in ipairs(root.paths) do
            lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
              first and "x" or " ",
              path,
              type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
            )
            first = false
          end
        end
        lines[#lines + 1] = "```lua"
        lines[#lines + 1] = "vim.g.root_spec = " .. vim.inspect(spec)
        lines[#lines + 1] = "```"
        Snacks.notify.info(lines, { title = "Roots" })
        return roots[1] and roots[1].paths[1] or vim.uv.cwd()
      end

      ---@type table<number, string>
      M.cache = {}

      function M.setup()
        vim.api.nvim_create_user_command("FindRoot", function()
          M.info()
        end, { desc = "Find roots for the current buffer" })

        -- FIX: doesn't properly clear cache in neo-tree `set_root` (which should happen presumably on `DirChanged`),
        -- probably because the event is triggered in the neo-tree buffer, therefore add `BufEnter`
        -- Maybe this is too frequent on `BufEnter` and something else should be done instead??
        vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged", "BufEnter" }, {
          group = vim.api.nvim_create_augroup("nixvim_root_cache", { clear = true }),
          callback = function(event)
            M.cache[event.buf] = nil
          end,
        })
      end

      -- returns the root directory based on:
      -- * lsp workspace folders
      -- * lsp root_dir
      -- * root pattern of filename of the current buffer
      -- * root pattern of cwd
      ---@param opts? {normalize?:boolean, buf?:number}
      ---@return string
      function M.get(opts)
        opts = opts or {}
        local buf = opts.buf or vim.api.nvim_get_current_buf()
        local ret = M.cache[buf]
        if not ret then
          local roots = M.detect({ all = false, buf = buf })
          ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
          M.cache[buf] = ret
        end
        if opts and opts.normalize then
          return ret
        end
        return ret
      end

      function M.git()
        local root = M.get()
        local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
        local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
        return ret
      end

      ---@param opts? {hl_last?: string}
      function M.pretty_path(opts)
        return ""
      end

      utils.root = M
    end

    do
      local M = {}

      local trouble_symbols = nil

      M.trouble = function()
        if not trouble_symbols then
          trouble_symbols = require("trouble").statusline({
            mode = "symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            hl_group = "lualine_c_normal",
          })
        end
        return {
          name = trouble_symbols.get,
          cond = trouble_symbols.has
        }
      end

    ---@param component any
    ---@param text string
    ---@param hl_group? string
    ---@return string
    function M.format(component, text, hl_group)
      text = text:gsub("%%", "%%%%")
      if not hl_group or hl_group == "" then
        return text
      end
      ---@type table<string, string>
      component.hl_cache = component.hl_cache or {}
      local lualine_hl_group = component.hl_cache[hl_group]
      if not lualine_hl_group then
        local utils = require("lualine.utils.utils")
        ---@type string[]
        local gui = vim.tbl_filter(function(x)
          return x
        end, {
          utils.extract_highlight_colors(hl_group, "bold") and "bold",
          utils.extract_highlight_colors(hl_group, "italic") and "italic",
        })

        lualine_hl_group = component:create_hl({
          fg = utils.extract_highlight_colors(hl_group, "fg"),
          gui = #gui > 0 and table.concat(gui, ",") or nil,
        }, "LV_" .. hl_group) --[[@as string]]
        component.hl_cache[hl_group] = lualine_hl_group
      end
      return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
    end

    ---@param opts? {relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number?}
    function M.pretty_path(opts)
      opts = vim.tbl_extend("force", {
        relative = "cwd",
        modified_hl = "MatchParen",
        directory_hl = "",
        filename_hl = "Bold",
        modified_sign = "",
        readonly_icon = " 󰌾 ",
        length = 3,
      }, opts or {})

      return function(self)
        local path = vim.fn.expand("%:p") --[[@as string]]

        if path == "" then
          return ""
        end

        local root = utils.root.get({ normalize = true })
        local cwd = utils.root.cwd()

        if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        else
          path = path:sub(#root + 2)
        end

        local sep = package.config:sub(1, 1)
        local parts = vim.split(path, "[\\/]")

        if opts.length == 0 then
          parts = parts
        elseif #parts > opts.length then
          parts = { parts[1], "…", table.concat({ unpack(parts, #parts - opts.length + 2, #parts) }, sep) }
        end

        if opts.modified_hl and vim.bo.modified then
          parts[#parts] = parts[#parts] .. opts.modified_sign
          parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
        else
          parts[#parts] = M.format(self, parts[#parts], opts.filename_hl)
        end

        local dir = ""
        if #parts > 1 then
          dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
          dir = M.format(self, dir .. sep, opts.directory_hl)
        end

        local readonly = ""
        if vim.bo.readonly then
          readonly = M.format(self, opts.readonly_icon, opts.modified_hl)
        end
        return dir .. parts[#parts] .. readonly
      end
    end

      ---@param opts? {cwd:false, subdirectory: true, parent: true, other: true, icon?:string}
      function M.root_dir(opts)
        opts = vim.tbl_extend("force", {
          cwd = false,
          subdirectory = true,
          parent = true,
          other = true,
          icon = "󱉭 ",
          color = {
            fg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Special", link = false }).fg),
          }
        }, opts or {})

        local function get()
          local cwd = utils.root.cwd()
          local root = utils.root.get({ normalize = true })
          local name = vim.fs.basename(root)

          if root == cwd then
            -- root is cwd
            return opts.cwd and name
          elseif root:find(cwd, 1, true) == 1 then
            -- root is subdirectory of cwd
            return opts.subdirectory and name
          elseif cwd:find(root, 1, true) == 1 then
            -- root is parent directory of cwd
            return opts.parent and name
          else
            -- root and cwd are not related
            return opts.other and name
          end
        end

        return {
          name = function()
            return (opts.icon and opts.icon .. " ") .. get()
          end,
          cond = function()
            return type(get()) == "string"
          end,
          color = opts.color,
        }
      end

      utils.lualine = M
    end
  '';
}
