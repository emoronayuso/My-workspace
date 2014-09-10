
naughty = require("naughty")

---Funcion volumen para el widget tb_volume---
cardid = 0
channel = "Master"
function volume (mode, widget)
    if mode == "update" then
        local fd = io.popen("amixer -c" .. cardid .. " -- sget " .. channel)
        local status = fd:read("*all")
        fd:close()

          local volume = string.match(status, "(%d?%d?%d)%%")
          volume = string.format("% 3d", volume)

          status = string.match(status, "%[(o[^%]]*)%]")

          if string.find(status, "on", 1, true) then
              volume = "Vol:" .. volume .. "%" .. " | "
          else
              volume = "Vol:" .. volume .. "M" .. " | "
          end

          widget.text = volume

    elseif mode == "up" then
        io.popen("amixer -q -c " .. cardid .. " -- sset " .. channel .. " 5%+"):read("*all")

        --Esto sirve para debugear-----
        --naughty.notify{
        -- bg = "#ff0000",
        -- fg = "#aaaaaa",
        -- title = "entra en el mode igual a up",
        -- text = "entra",
        -- timeout = 10
       -- }

        volume("update", widget)
    elseif mode == "down" then
        io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-"):read("*all")
        volume("update", widget)
    else
        --io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " toggle"):read("*all")
        io.popen("amixer set " .. channel .. " toggle"):read("*all")
        volume("update", widget)
    end
end
--------------------------------------------

-- Lanzador para abrir nautilus --

function abre_nautilus (mode, widget)
    if mode == "abrir" then
        local exec = io.popen("nautilus")
        fd:close()
    end

    widget.text = "[^] | "
end

-----------------------------------




-- Standard awesome library
awful = require("awful")
awful.autofocus = require("awful.autofocus")
awful.rules = require("awful.rules")
beautiful = require("beautiful")
--Notification library
--naughty = require("naughty")

obvious = require("obvious")


-- Theme handling library

-- Load Debian menu ent
require("debian.menu")

--wibox = require("wibox")
vicious = require("vicious")


-- Useful Paths
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
scriptdir = confdir .. "/scripts/"
themes = confdir .. "/themes"
active_theme = themes .. "/multicolor"

-- Themes define colours, icons, and wallpapers
beautiful.init(active_theme .. "/theme.lua")

--insert after beautiful.init("...")
require("pomodoro")
--init de pomodoro objet
--pomodoro.init()


-- {{{ Localization

os.setlocale(os.getenv("LANG"))

-- }}}



--- icono pomodoro
--barra_arriba = awful.wibox.layout.fixed.horizontal()
--barra_arriba:add(widget_img)
--img_po = wixbox.widget.imagebox()
--img_po.set_image(beautiful.imagen_pomodoro)









--CPU usage widget-------------------------------------------------
cpuwidget = awful.widget.graph({ align = "right" })
cpuwidget:set_width(50)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#FF5656")
cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 2)
--------------------------------------------------------------------

--netwidget = wibox.widget.textbox()



-- Uptime--------
--uptimeicon = wibox.widget.imagebox()
--uptimeicon:set_image(beautiful.widget_uptime)
--uptimewidget = wibox.widget.textbox()
--vicious.register(uptimewidget, vicious.widgets.uptime, brown .. "$2.$3" .. coldef)
----------------------------------------------

---Widget Volumen---------------------------------------------------------------
tb_volume = {}
tb_volume.widget = widget({ type="textbox", name="tb_volume", align="right" })
tb_volume.widget:buttons(
   awful.util.table.join(
          awful.button({ }, 4, function () volume("up", tb_volume.widget) end ),
          awful.button({ }, 5, function () volume("down", tb_volume.widget) end ),
          awful.button({ }, 1, function () volume("mute", tb_volume.widget) end )
))
volume("update", tb_volume.widget)
------------------------------------------------------------------------------

---- Widget para abrir nautilus ------
tb_nautilus = {}
tb_nautilus.widget = widget({ type="textbox", name="tb_nautilus", align="right" })
tb_nautilus.widget:buttons(
   awful.util.table.join(
      awful.button({ }, 1, function () abre_nautilus("abrir", tb_nautilus.widget) end )  
   )
)
-- abre_nautilus("abrir", tb_nautilus.widget)

--------------------------------------



---Widget imagen pomodoro------------------------------------------------------
img_pomodoro = widget({ type = "imagebox" , name="img_pomodoro" })
img_pomodoro.image=image(beautiful.imagen_pomodoro)
-------------------------------------------------------------------------------


---Vicious uso de la bateria ------------------------------------
batwidget = widget({ type = "textbox", name = "batwidget" })
vicious.register(batwidget, vicious.widgets.bat, "$1", 23, "BAT1")
-------------------------------------------------------------------

----Vicious Fecha (FUNCIONA) -----------------------------------------------
--fecha_widget = widget({ type = "textbox", name = "fecha_widget" })
--vicious.register(fecha_widget, vicious.widgets.date)
-----------------------------------------------------------------

--- Vicious Wifi --------------------------------------------------
wifi_widget = widget({ type = "textbox", name = "wifi_widget" })
vicious.register(wifi_widget, vicious.widgets.wifi, "wlan0")
-------------------------------------------------------------------
--- obvious Wifi -----------------
--wifi_widget = obvious.wlan.get_data_source("wlan0")


--






-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
--terminal = "x-terminal-emulator"
terminal = "/usr/bin/urxvt"
--terminal = "xterm"
--terminal = "sakura"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
--editor_cmd = terminal .. " -e vim "


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
 --      tags[s] = awful.tag({ "☠", "⌥", "✇", "⌤", "⍜", "✣", "⌨", ":)", "☕", "⌘", "®", "₪" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

--Menu_kikeRL = {
--    { "Concola","xterm" },
--    { "Apagar", "shutdown -h now" },
--    { "Reiniciar", "shutdown -r now" },
--}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                   -- { "Menu KikeRL", Menu_kikeRL },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })


-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        ---AQUI INCLUYO LOS WIDGETS----
        separator, cpuwidget,
        pomodoro.widget,
        img_pomodoro,
        tb_volume.widget,
        batwidget,
        tb_nautilus.widget,
        --img_pomodoro.widget,
 --       fecha_widget,  -- FUNCIONA
       -- obvious.wlan.widget,
       -- wifi_widget,
       -- separator, volwidget,
       -- separator, batwidget,
       -- volumewidget,
       -- datewidget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),

----- Atajos del teclado FUNCIONA!!-----------------------------------------
   awful.key({ modkey,       }, "s",
        function ()
             awful.util.spawn("gksudo pm-suspend -m" .. "'Se va a suspender el equipo, ¿estas seguro?'")
            end),

----------------------------------------------------------------------------

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

-- Teclas de volumen------

--awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 2dB-") end)
--awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 2dB+") end)

------------------------------


    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    -- c:add_signal("mouse::enter", function(c)
    --     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --         and awful.client.focus.filter(c) then
    --         client.focus = c
    --     end
    -- end)

    -- if not startup then
    --     -- Set the windows at the slave,
    --     -- i.e. put it at the end of others instead of setting it master.
    --     -- awful.client.setslave(c)

    --     -- Put windows in a smart way, only if they does not set an initial position.
    --     if not c.size_hints.user_position and not c.size_hints.program_position then
    --         awful.placement.no_overlap(c)
    --         awful.placement.no_offscreen(c)
    --     end
    -- end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


----Refrescar widget de volumen cada 10 segundos --
awful.hooks.timer.register(10, function () volume("update", tb_volume.widget) end)
----------------------------------------------------



