local status, commented = pcall(require, "commented")
if not status then
	return
end

commented.setup()
