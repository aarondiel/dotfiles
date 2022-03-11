--- @module 'awful.init'
local awful = require('awful')

local applications = {
	'firefox',
	'discord',
	'thunderbird'
}

--- @param autorun? boolean
--- @return nil
local function setup_autorun(autorun)
	if autorun == nil then
		autorun = true
	end

	if not autorun then
		return
	end

	for _, application in pairs(applications) do
		awful.spawn.once(application)
	end
end


return setup_autorun
