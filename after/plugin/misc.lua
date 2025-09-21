require('mason').setup()
require('project_nvim').setup {
  patterns = { ".git/" } -- only match git directories -> recurses to submodule parent
}
