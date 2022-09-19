local status, auto_dark_mode = pcall(require, 'auto-dark-mode')
if (not status) then return end


auto_dark_mode.setup({
	update_interval = 30000,
	set_dark_mode = function()
    vim.cmd("colorscheme nightfox")
	end,
	set_light_mode = function()
    vim.cmd("colorscheme dawnfox")
	end,
})
auto_dark_mode.init()
