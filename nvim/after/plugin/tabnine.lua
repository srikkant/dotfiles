local status, tabnine = pcall(require, 'cmp_tabnine.config')
if (not status) then return end

tabnine.setup({
	run_on_every_keystroke = true,
	show_prediction_strength = true
})

