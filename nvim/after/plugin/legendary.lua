local status, legendary = pcall(require, "legendary")

if not status then
    return
end

legendary.setup({
    which_key = {
        auto_register = false
    }
})
