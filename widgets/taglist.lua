local gears = require("gears")
local colors  = require("utils.colors")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

function return_taglist(s)
  local taglist = wibox.widget{
      {
          awful.widget.taglist{
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = awful.util.taglist_buttons
          },
          left   = dpi(3),
          top    = dpi(2),
          bottom = dpi(2),
          right  = dpi(3),
          widget = wibox.container.margin
      },
      shape = gears.shape.rounded_bar,
      bg = colors.polar.darkest,
      widget = wibox.container.background
  }

  return taglist
end

return return_taglist
