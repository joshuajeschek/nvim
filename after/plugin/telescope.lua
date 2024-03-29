local telescope = require('telescope')
telescope.setup {
  extensions = {
    file_browser = {theme = 'ivy', hijack_netrw = true},
    defaults = {
      file_ignore_patterns = {".git/**/*"},
      vimgrep_arguments = 'rg', '--hidden'
  }
  }
}
telescope.load_extension 'file_browser'
telescope.load_extension 'conventional_commits'
telescope.load_extension 'make'
