local gears = require("gears")
--local lain  = require("lain")
--local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local add_app = require("utils.add_app")
local colors  = require("utils.colors")
local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local dpi           = require("beautiful.xresources").apply_dpi

local dir = os.getenv("HOME") .. "/.config/awesome"

local username = os.getenv("USER")
local myavatar = dir .. "/images/avatar.jpg"

local myfavoritebrowser = "chromium"
local terminal          = "kitty"
local editor            = "nvim"
local my_user_widget = wibox.widget {
  {
    {
      {
        {
          {
            {
              {
                image = myavatar,
                forced_width = 128,
                forced_height= 128,
                widget = wibox.widget.imagebox
              },
              shape = function(cr, width, height)
                gears.shape.rounded_rect(
                  cr, width, height,
                  30
                )
              end,
              shape_clip = true,
              widget = wibox.container.background
            },
            margins = 14,
            widget = wibox.container.margin
          },
          {
            {
              {
                markup = '<span foreground="'..colors.green..'">'..username.."</span>",
                font = "JetBrainsMono Nerd Font 30",
                widget = wibox.widget.textbox
              },
              top = 40,
              left = 60,
              widget = wibox.container.margin
            },
            {
              {
                markup = '<span foreground="'..colors.yellow..'">Awesome is Awesome!</span>',
                font = "JetBrainsMono Nerd Font 13",
                widget = wibox.widget.textbox
              },
              bottom = 40,
              left = 60,
              widget = wibox.container.margin
            },
            layout = wibox.layout.flex.vertical
          },
          layout = wibox.layout.fixed.horizontal
        },
        halign = 'center',
        valign = 'center',
        widget = wibox.container.place
      },
      margins = 10,
      widget = wibox.container.margin
    },
    bg = colors.polar.darkest .. "53",
    shape = function(cr, width, height) 
      gears.shape.partially_rounded_rect (cr, width, height, true, true, false, false,
      15)
    end,
    widget = wibox.container.background
  },
  margins = 0,
  widget = wibox.container.margin
}



local clock = wibox.widget {
  {
    {
      format = '<span foreground="'..colors.red..'">%H</span>',
      font = "JetBrainsMono Nerd Font 80",
      align = "top",
      widget = wibox.widget.textclock
    },
    margins = 5,
    widget = wibox.container.margin
  },
  {
    wibox.widget{
      {
        markup = '<span foreground="'..colors.green..'"></span>',
        font = "JetBrainsMono Nerd Font 10",
        widget = wibox.widget.textbox
      },
      --margins = 5,
      top = 20,
      --right = 12,
      widget = wibox.container.margin
    },
    wibox.widget{
      {
        markup = '<span foreground="'..colors.yellow..'"></span>',
        font = "JetBrainsMono Nerd Font 10",
        widget = wibox.widget.textbox
      },
      --margins = 5,
      bottom = 20,
      --right = 12,
      widget = wibox.container.margin
    }, 
    
    --wibox.widget{
    --  {
    --    markup = '<span foreground="'..colors.green..'"></span>',
    --    font = "JetBrainsMono Nerd Font 10",
    --    widget = wibox.widget.textbox
    --  },
    --  margins = 5,
    --  top = 10,
    --  right = 12,
    --  widget = wibox.container.margin
    --},
    fill_space = true,
    layout = wibox.layout.flex.vertical
    
  },
  {
    {
      format = '<span foreground="'..colors.pink..'">%M</span>',
      font = "JetBrainsMono Nerd Font 80",
      align = "top",
      widget = wibox.widget.textclock
    },
    margins = 10,
    widget = wibox.container.margin
  },
  layout = wibox.layout.fixed.horizontal
}

clock = wibox.widget{
  { 
    clock,
    align = 'center',
    valign = 'center',
    widget = wibox.container.place
  },
  bg = colors.polar.darkest .. "af",
  shape = function(cr, width, height)
    gears.shape.partially_rounded_rect(
      cr, width, height,
      false, false,
      true, true,
      30
    )
  end,
  widget = wibox.container.background
}

local start_widget = wibox.widget{
  { 
    {
      {
        markup = '<span foreground="'..colors.polar.lightest..'"><span font="JetBrainsMono Nerd Font 16"></span><span font="JetBrainsMono Nerd Font 10"> Launch app</span></span>',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
      },
      margins = 10,
      widget = wibox.container.margin
    },
    bg = colors.frost.lightest .. "ef",
    shape = function(cr, width, height) 
      gears.shape.partially_rounded_rect(
        cr,  width, height,
        true, true,
        false, false,
        30
      )
    end,
    widget = wibox.container.background
  },
  widget = wibox.container.margin
}

start_widget:connect_signal("mouse::enter", function()
  start_widget.bg = colors.frost.lightest .. "ff"
end)

start_widget:connect_signal("mouse::leave", function()
  start_widget.bg = colors.frost.lightest .. "ef"
end)

start_widget:connect_signal("button::press", function()
  start_widget.bg = colors.light.lighter
  awful.spawn.with_shell("rofi -show drun")
end)
local ram_bar = wibox.widget {
  max_value     = 100,
  value         = 99,
  forced_height = dpi(5),
  margins       = {
    top = dpi(8),
    bottom = dpi(8),
  },
  forced_width  = dpi(500),
  background_color = colors.frost.aqua,
  color = colors.green,
  shape         = gears.shape.rounded_bar,
  widget        = wibox.widget.progressbar,
}

local used_ram_script = [[
  bash -c "
  free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
  "]]

awful.widget.watch(used_ram_script, 20, function(widget, stdout)
                     local available = stdout:match('(.*)@@')
                     local total = stdout:match('@@(.*)@')
                     local used_ram_percentage = (total - available) / total * 100
                     ram_bar.value = used_ram_percentage 
end)

local ram = wibox.widget{
  {
    markup = '<span foreground="'..colors.frost.lightest..'" font="JetBrainsMono Nerd Font 20">﬙ </span>',
    widget = wibox.widget.textbox,
  },
  ram_bar,
  spacing = 10,
  layout = wibox.layout.fixed.horizontal,
  widget = wibox.container.background
} 



-- CPU BAR
local cpu_bar = wibox.widget {
  max_value     = 100,
  forced_height = dpi(5),
  margins       = {
    top = dpi(8),
    bottom = dpi(8),
  },
  forced_width  = dpi(500),
  background_color = colors.frost.aqua,
  color = colors.green, --.. "ef",
  shape         = gears.shape.rounded_bar,
  widget        = wibox.widget.progressbar,
}

local cpu_idle_script = [[
  bash -c "
  vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'
  "]]

awful.widget.watch(cpu_idle_script, 20, function(widget, stdout)
  -- local cpu_idle = stdout:match('+(.*)%.%d...(.*)%(')
  local cpu_idle = stdout
  cpu_idle = string.gsub(cpu_idle, '^%s*(.-)%s*$', '%1')
  cpu_bar.value = tonumber(cpu_idle) 
end)

local cpu = wibox.widget{
  {
    markup = '<span foreground="'..colors.frost.lightest.."ef"..'" font="JetBrainsMono Nerd Font 20"> </span>',
    widget = wibox.widget.textbox,
  },
  cpu_bar,
  spacing = 10,
  layout = wibox.layout.fixed.horizontal,
  widget = wibox.container.background
} 



local disk_bar = wibox.widget {
  max_value     = 1,
  value         = 0.3,
  forced_height = dpi(5),
  margins       = {
    top = dpi(8),
    bottom = dpi(8),
  },
  forced_width  = dpi(500),
  background_color = colors.frost.aqua,
  color = colors.green, --.. "ef",
  shape         = gears.shape.rounded_bar,
  widget        = wibox.widget.progressbar,
}

local disk_idle_script = "python3 "..dir.."/scripts/syscript.py -u s"

awful.widget.watch(disk_idle_script, 20, function(widget, stdout)
  disk_bar.value = tonumber(stdout) 
end)

local disk = wibox.widget{
  {
    markup = '<span foreground="'..colors.frost.lightest.."ef"..'" font="JetBrainsMono Nerd Font 20"> </span>',
    widget = wibox.widget.textbox,
  },
  disk_bar,
  spacing = 10,
  layout = wibox.layout.fixed.horizontal,
  widget = wibox.container.background
} 


local fav_apps = {
  {
    {
      {
        {
          add_app(
            function()
              awful.spawn.with_shell(
                myfavoritebrowser.." https://reddit.com/r/unixporn"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> </span>',
            colors.orange,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                myfavoritebrowser.." https://twitter.com"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> </span>',
            colors.frost.lightest,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                myfavoritebrowser.." https://github.com"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> </span>',
            colors.light.lighter,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                myfavoritebrowser.." https://youtube.com"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> </span>',
            colors.red,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                "discord"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> ﭮ</span>',
            colors.polar.lighter,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                "telegram"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> </span>',
            colors.frost.light_green,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                "dolphin"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> ﱮ</span>',
            colors.yellow,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                terminal
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"></span>',
            colors.light.darker,
            colors.polar.darkest
          ),
          -- 
          add_app(
            function()
              awful.spawn.with_shell(
                string.format(
                  "cd ~/.config/awesome; %s -e %s ~/.config/awesome/rc.lua",
                  terminal, editor
                )
              )
            end,
            '<span font="JetBrainsMono Nerd Font 20"> </span>',
            colors.orange,
            colors.polar.darkest
          ),
          add_app(
            function()
              awful.spawn.with_shell(
                "flameshot gui"
              )
            end,
            '<span font="JetBrainsMono Nerd Font 16"> </span>',
            colors.pink,
            colors.polar.darkest
          ),
          spacing = 5,
          layout = wibox.layout.grid.horizontal
        },
        align = 'center',
        valign = 'center',
        widget = wibox.container.place
      },
      margins = 15,
      widget = wibox.container.margin
    },
    bg = colors.polar.darkest .. "53",
    --shape = gears.shape.rounded_rect,
    widget = wibox.container.background

  },
  spacing = 5,
  layout = wibox.layout.fixed.vertical
}


local logout = wibox.widget{
  {
    {
      {
        markup = '<span foreground="'..colors.polar.lightest..'"><span font="JetBrainsMono Nerd Font 16"> </span><span font="JetBrainsMono Nerd Font 10">Logout</span></span>',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
      },
      margins = 4,
      widget = wibox.container.margin
    },
    bg = colors.red .. "ef",
    shape = function(cr, width, height) 
      gears.shape.partially_rounded_rect(
        cr, width, height,
        false, false,
        true,  true,
        30
      )
    end,
    widget = wibox.container.background
  },
  widget = wibox.container.margin
}

logout:connect_signal("mouse::enter", function()
  logout.bg = colors.red .. "ff"
end)

logout:connect_signal("mouse::leave", function()
  logout.bg = colors.red .. "ef"
end)

logout:connect_signal("button::press", function()
  logout.bg = colors.red
  require("awesome-wm-widgets.logout-popup-widget.logout-popup").launch()
  
end)

local function return_menu(screen)
  local adjustment = function() 
    if screen.workarea.width <= 1366 then
      return 0.3

    else
      return 1
    end
  end

  local adjust = adjustment()

  local menu_popup = awful.popup {
      widget = {
        {
          {
            
            {
              my_user_widget,
              clock,
              {
                bottom = 20,
                widget = wibox.container.margin
              },
              
              {
                
                start_widget,
                
                fav_apps,
                {
                  {
                    {
                      ram,
                      cpu,
                      disk,
                      layout = wibox.layout.fixed.vertical
                    },
                    margins = 10,
                    widget = wibox.container.margin
                  },
                  --shape = gears.shape.rounded_rect,
                  bg = colors.polar.darkest .. "40",
                  widget = wibox.container.background
                },

                logout,
                layout = wibox.layout.fixed.vertical
              },
              
              
              layout = wibox.layout.fixed.vertical
            },
            
            margins = 20*adjust,
            widget = wibox.container.margin
          },
          bg = colors.polar.lightest,
          widget = wibox.container.background
        },
        margins = 5*adjust,
        widget = wibox.container.margin
      },
      bg           = colors.bg,
      fg           = colors.light.lighter,
      border_color = colors.polar.lightest,
      border_width = 5*adjust,
      --hide_on_right_click = true,
      ontop        = true,
      visible      = false,
  }
  
  local menu = wibox.widget {
    {
        { 
            image  = dir .. "/awesome.svg",
            resize = true,
            widget = wibox.widget.imagebox
        },
        --Margin 
        left   = 5,
        spacing = 20, 
        right  = 5,
        widget = wibox.container.margin,
    },
    
    bg         = colors.polar.darkest .. "AF",
    fg         = beautiful.bg_normal,

    -- Sets the shape 
    shape = gears.shape.rounded_rect,
    shape_clip = true,
    widget     = wibox.container.background,
    buttons = awful.button({}, 1, function()
    if menu_popup.visible then
      menu_popup.visible = false
    else
      menu_popup.x = screen.workarea.x + 20
      menu_popup.y = screen.workarea.y + 25
      --menu_popup.y = 50
      --menu_popup:move_next_to(mouse.current_widget_geometry)
      menu_popup.visible = true
    end
  end)
  }

  return menu 
end

return return_menu
