local gears = require("gears")
local colors = require("utils.colors")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi   = require("beautiful.xresources").apply_dpi

local function add_app(app, text, fg, bg)     

        local widget = wibox.widget {
            {
                {
                markup = text,
                font = "JetBrainsMono Nerd Font 12",
                widget = wibox.widget.textbox
                },
                -- Margin 
                left   = 10,
                spacing = 20,
                top    = 4,
                bottom = 4,
                right  = 10,
                widget = wibox.container.margin,
            },
            
            bg         = bg,
            fg         = fg,

            -- Sets the shape 
            shape      = gears.shape.rounded_rect,
            shape_clip = true,
            widget     = wibox.container.background,
        }
        -- When pressed the widget, it will
        -- change its color and spawn the app
        widget:connect_signal("button::press",
            function()
                widget.fg = colors.frost.lightest
                app()
                --awful.spawn.with_shell(app)
            end
        )

        -- This function will be called when the button  is 
        -- released
        widget:connect_signal("button::release",
            function()
                widget.fg = fg
            end
        )

        -- When its on hover, it will change its color
        widget:connect_signal("mouse::enter",
            function()

                widget.fg = colors.light.lighter
            end
        )
        
        widget:connect_signal("mouse::leave",
            function()
                widget.fg = fg

            end
        )
        return widget
    end

return add_app
