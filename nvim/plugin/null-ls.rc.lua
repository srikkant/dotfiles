local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local augroup_format = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

null_ls.setup({
	debug = true,
	sources = {
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.prettierd.with({
			extra_filetypes = { "svelte" },
		}),
		null_ls.builtins.formatting.stylelint,

		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,

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

	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup_format })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup_format,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(format_client)
							return format_client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
