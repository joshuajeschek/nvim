local Remap = require("joshuajeschek.keymap")

local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local vnoremap = Remap.vnoremap

-- lsp keybinds -> lsp.lua
-- cmp keybinds -> cmp.lua

nnoremap('<leader>db', ':Dashboard<CR>')

-- telescope
nnoremap('<leader>t', ':Telescope<CR>')
nnoremap('<leader>fb', ':Telescope file_browser<CR>')
nnoremap('<leader>ff', ':Telescope find_files<CR>')
nnoremap('<leader>of', ':Telescope oldfiles<CR>')

-- commenting
inoremap('<C-#>', '<C-o>:lua MiniComment.operator("line")<CR>')

-- undo/ redo
nnoremap('<C-z>', 'u')
nnoremap('<C-S-z>', 'C-r')
inoremap('<C-z>', '<C-o>u')
inoremap('<C-S-z>', '<C-o><C-r>')

-- Neoformat
nnoremap('<C-S-G>', ':Neoformat<CR>')
inoremap('<C-S-G>', '<C-o>:Neoformat<CR>')

