local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.stylelint,

		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Rust
		null_ls.builtins.formatting.rustfmt,

		-- Golang
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.golines,

		-- Shell script
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.shellharden,
		null_ls.builtins.formatting.shfmt,

		-- YAML
		null_ls.builtins.diagnostics.yamllint,

		-- Flutter
		null_ls.builtins.formatting.dart_format,
	},

	on_attach = function(client)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup_format,
				buffer = 0,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})
