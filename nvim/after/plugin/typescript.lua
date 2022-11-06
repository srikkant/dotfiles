local status, typescript = pcall(require, "typescript")

if not status then
	return
end

typescript.setup({})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx" },
	callback = function()
		typescript.actions.organizeImports({ sync = true })
		typescript.actions.addMissingImports({ sync = true })
		typescript.actions.fixAll({ sync = true })
	end,
})
