local status, nvim_tree = pcall(require, 'nvim-tree_WRONG')
if(not status) then return end


-- empty setup using defaults
nvim_tree.setup({
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

