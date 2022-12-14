local util = require('formatter.util')
local Remap = require("joshuajeschek.keymap")
local Utils = require("joshuajeschek.utils")
local lines_from = Utils.lines_from
local file_exists = Utils.file_exists
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local TMPDIR = vim.fn.stdpath('data') .. '/formatter'

if not file_exists(TMPDIR) then os.execute('mkdir -p' .. TMPDIR) end
require('formatter').setup {
  logging = true,
  log_level = vim.log.levels.INFO,
  filetype = {
    python = {require('formatter.filetypes.python').autopep8},
    haskell = {require('formatter.filetypes.haskell').stylish_haskell},
    tex = {
      function()
        return {
          exe = "latexindent",
          args = {
            '-g', util.escape_path(util.get_cwd() .. '/latexindent.log'),
            '-l', util.escape_path(util.get_cwd() .. '/latexindent.yaml'),
            util.escape_path(util.get_current_buffer_file_path())
          },
          stdin = true
        }
      end
    },
    ["*"] = {require('formatter.filetypes.any').remove_trailing_whitespace},
    lua = {
      -- require('formatter.filetypes.lua').luaformatter,
      function()
        return {
          exe = 'lua-format',
          args = {
            '--tab-width=2', '--indent-width=2',
            util.escape_path(util.get_current_buffer_file_path())
          },
          stdin = true
        }
      end
    },
    htmldjango = {
      function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, '\n')
        local tmpfile = TMPDIR .. '/' .. os.time()
        local f = io.open(tmpfile, 'w')
        if f == nil then
          return {exe = 'echo "Failed to create temp file"; (exit 1)'}
        end
        f:write(content)
        f:close()

        return {
          exe = 'djlint',
          args = {
            tmpfile, '--reformat', '--format-css', '--format-js', '--indent 2',
            '--preserve-blank-lines'
          },
          ignore_exitcode = true,
          no_append = true,
          stdin = false,
          transform = function(_)
            if not file_exists(tmpfile) then return lines end
            local flines = lines_from(tmpfile)
            os.execute('rm ' .. tmpfile)
            return flines
          end
        }
      end
    }
  }
}

nnoremap('<C-F>', ':w | :Format<CR>')
inoremap('<C-F>', '<C-o>:w | :Format<CR>')
