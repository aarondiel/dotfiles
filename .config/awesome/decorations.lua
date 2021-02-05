local awful = require("awful")
local beautiful = require("beautiful")
local util = require("util")
local gears = require("gears")
local wibox = require("wibox")

local decorations = {}

awful.titlebar.enable_tooltip = false

function decorations.hide(c)
    if not c.custom_decoration or not c.custom_decoration[beautiful.titlebar_position] then
        awful.titlebar.hide(c, beautiful.titlebar_position)
    end
end

function decorations.show(c)
    if not c.custom_decoration or not c.custom_decoration[beautiful.titlebar_position] then
        awful.titlebar.show(c, beautiful.titlebar_position)
    end
end

local button_commands = {
    ['close'] = { fun = function(c) c:kill() end, track_property = nil } ,
    ['maximize'] = { fun = function(c) c.maximized = not c.maximized; c:raise() end, track_property = "maximized" },
    ['minimize'] = { fun = function(c) c.minimized = true end },
    ['sticky'] = { fun = function(c) c.sticky = not c.sticky; c:raise() end, track_property = "sticky" },
    ['ontop'] = { fun = function(c) c.ontop = not c.ontop; c:raise() end, track_property = "ontop" },
    ['floating'] = { fun = function(c) c.floating = not c.floating; c:raise() end, track_property = "floating" },
}

decorations.button = function (c, shape, color, unfocused_color, hover_color, size, margin, cmd)
    local button = wibox.widget {
        forced_height = size,
        forced_width = size,
        bg = (client.focus and c == client.focus) and color or unfocused_color,
        shape = shape,
        widget = wibox.container.background()
    }

    local button_widget = wibox.widget {
        button,
        margins = margin,
        widget = wibox.container.margin(),
    }
    button_widget:buttons(gears.table.join(
        awful.button({ }, 1, function()
            button_commands[cmd].fun(c)
        end)
    ))

    local p = button_commands[cmd].track_property
    if p then
        c:connect_signal("property::"..p, function()
            button.bg = c[p] and color .. "40" or color
        end)
        c:connect_signal("focus", function()
            button.bg = c[p] and color .. "40" or color
        end)
        button_widget:connect_signal("mouse::leave", function()
            if c == client.focus then
                button.bg = c[p] and color .. "40" or color
            else
                button.bg = unfocused_color
            end
        end)
    else
        button_widget:connect_signal("mouse::leave", function()
            if c == client.focus then
                button.bg = color
            else
                button.bg = unfocused_color
            end
        end)
        c:connect_signal("focus", function()
            button.bg = color
        end)
    end
    button_widget:connect_signal("mouse::enter", function()
        button.bg = hover_color
    end)
    c:connect_signal("unfocus", function()
        button.bg = unfocused_color
    end)

    return button_widget
end

decorations.text_button = function (c, symbol, font, color, unfocused_color, hover_color, size, margin, cmd)
    local button = wibox.widget {
        align = "center",
        valign = "center",
        font = font,
        markup = util.colorize_text(symbol, unfocused_color),
        forced_width = size + margin * 2,
        widget = wibox.widget.textbox
    }

    button:buttons(gears.table.join(
        awful.button({ }, 1, function()
            button_commands[cmd].fun(c)
        end)
    ))

    local p = button_commands[cmd].track_property
    if p then
        c:connect_signal("property::"..p, function()
            button.markup = util.colorize_text(symbol, c[p] and color .. "40" or color)
        end)
        c:connect_signal("focus", function ()
            button.markup = util.colorize_text(symbol, c[p] and color .. "40" or color)
        end)
        button:connect_signal("mouse::leave", function ()
            if c == client.focus then
                button.markup = util.colorize_text(symbol, c[p] and color .. "40" or color)
            else
                button.markup = util.colorize_text(symbol, unfocused_color)
            end
        end)
    else
        button:connect_signal("mouse::leave", function ()
            if c == client.focus then
                button.markup = util.colorize_text(symbol, color)
            else
                button.markup = util.colorize_text(symbol, unfocused_color)
            end
        end)
        c:connect_signal("focus", function ()
            button.markup = util.colorize_text(symbol, color)
        end)
    end
    button:connect_signal("mouse::enter", function ()
        button.markup = util.colorize_text(symbol, hover_color)
    end)
    c:connect_signal("unfocus", function ()
        button.markup = util.colorize_text(symbol, unfocused_color)
    end)

    return button
end

return decorations
