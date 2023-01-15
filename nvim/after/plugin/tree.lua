local status, nvim_tree = pcall(require, "nvim-tree")

if not status then
	return
end

nvim_tree.setup({
	diagnostics = {
		enable = true,
		show_on_dirs = true,
	},
	update_focused_file = {
		enable = true,
	},
	view = {
		side = "left",
		relativenumber = true,
		mappings = {
			list = {
				{ key = { "<CR>", "l" }, action = "edit", mode = "n" },
				{ key = { "<BS>", "h" }, action = "close_node", mode = "n" },
			},
		},
	},
})
