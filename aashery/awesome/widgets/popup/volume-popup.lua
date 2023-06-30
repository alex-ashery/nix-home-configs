local awful = require("awful")
local beautiful = require("beautiful")
local createPopup = require("widgets.popup.popup")

local popup = createPopup(beautiful.blue, awful.screen.focused().geometry.height / 3)

awesome.connect_signal("evil::volume", function(volume)
	popup.update(volume.value, volume.image)
end)

awesome.connect_signal("popup::volume", function(volume)
    if volume ~= nil then
        popup.updateValue(volume.amount)
    end
    popup.show()
end)
