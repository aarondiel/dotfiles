local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local util = require("util")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local keys = require("keys")
local decorations = require("decorations")

-- Button configuration
local gen_button_size = dpi(8)
local gen_button_margin = dpi(8)
local gen_button_color_unfocused = xrdb.color8
local gen_button_shape = gears.shape.circle

-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c, {font = beautiful.titlebar_font, position = beautiful.titlebar_position, size = beautiful.titlebar_size}) : setup {
        nil,
        {
            buttons = keys.titlebar_buttons,
            font = beautiful.titlebar_font,
            align = beautiful.titlebar_title_align or "center",
            widget = beautiful.titlebar_title_enabled and awful.titlebar.widget.titlewidget(c) or wibox.widget.textbox("")
        },
        {
            -- AwesomeWM native buttons (images loaded from theme)
            -- awful.titlebar.widget.minimizebutton(c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.closebutton(c),

            -- Generated buttons
            decorations.button(c, gen_button_shape, xrdb.color3, gen_button_color_unfocused, xrdb.color11, gen_button_size, gen_button_margin, "minimize"),
            decorations.button(c, gen_button_shape, xrdb.color2, gen_button_color_unfocused, xrdb.color10, gen_button_size, gen_button_margin, "maximize"),
            decorations.text_button(c, "", "Material Icons 9", xrdb.color1, gen_button_color_unfocused, xrdb.color9, gen_button_size, gen_button_margin, "close"),

            -- Create some extra padding at the edge
            util.horizontal_pad(gen_button_margin / 2),

            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)
