local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

lspkind.symbol_map['Tabnine'] = 'ﮧ'

-- typst hayagriva citing autocomplete (expect file at bibliography.yaml in cwd)
local hayagriva = {}

function hayagriva:complete(params, callback)
  local items = {}

  local bib_file = vim.fn.getcwd() .. "/bibliography.yaml"
  local bib_exists = vim.fn.filereadable(bib_file) == 1

  local filetype = params.context.filetype
  local is_typst_file = filetype == "typst" or filetype == "typ"

  local cursor_before_line = params.context.cursor_before_line

  if cursor_before_line:sub(1, 1) == "@" and is_typst_file and bib_exists then

    local home = os.getenv("HOME")
    local csl_file = home .. "/.config/nvim/assets/apa-with-citation-keys.csl"
    local cmd = "hayagriva " .. vim.fn.shellescape(bib_file) .. " reference --no-fmt --csl " .. vim.fn.shellescape(csl_file)
    local output = vim.fn.system(cmd)
    local lines = vim.split(output, "\n")

    for _, line in ipairs(lines) do
      if line ~= "" then
        -- key (first word) + rest (reference)
        local key, reference = line:match("^(%S+)%s+(.+)$")
        if key and reference then
          table.insert(items, { label = "@" .. key, detail = reference, kind = 18, })
        end
      end
    end

  end

  callback(items)
end

function hayagriva:get_trigger_characters()
  return { "@" }
end

-- Don't forget to register your new source to cmp.
cmp.register_source("hayagriva", hayagriva)


-- general autocompletion setup
require('luasnip.loaders.from_vscode').lazy_load()
cmp.setup ({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'cmp_tabnine' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'hayagriva' },
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { 'i', 's' }),
    ['<C-e>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  formatting = {
    format = lspkind.cmp_format({
      -- symbol_map = lspkind_symbol_map,
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      before = function(entry, vim_item)
        if entry.source.name == 'cmp_tabnine' then
          -- vim_item.abbr = vim_item.kind
          vim_item.kind = 'Tabnine'
        end
        return vim_item
      end
    }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

-- autocompletion setup in cmdline environments
local cmp_mapping_cmdline = cmp.mapping.preset.cmdline({
  -- override behavior so that cmp will be displayed if not yet visible
  ['<Tab>'] = {
    c = function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end,
  },
})
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp_mapping_cmdline,
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp_mapping_cmdline,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- snippets
local snippets_paths = function()
  local plugins = { 'friendly-snippets' }
  local paths = {}
  local path
  local root_path = vim.env.HOME .. '/.vim/plugged/'
  for _, plug in ipairs(plugins) do
    path = root_path .. plug
    if vim.fn.isdirectory(path) ~= 0 then
      table.insert(paths, path)
    end
  end
  return paths
end

require('luasnip.loaders.from_vscode').lazy_load({
  paths = snippets_paths(),
  include = nil, -- Load all languages
  exclude = {},
})
