--[[                                      ]]--
--                                          -
--   Multicolor Awesome WM 3.5.+ config     --
--        github.com/copycat-killer         --
--                                          -
--[[                                      ]]--


-- {{{ Required Libraries

gears           = require("gears")
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
revelation      = require("revelation")
beautiful       = require("beautiful")
naughty         = require("naughty")
vicious         = require("vicious")
scratch         = require("scratch")

-- }}}

-- {{{ Autostart

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- run_once("wicd-client --tray")

-- }}}

-- {{{ Run or raise

--- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- @param cmd the command to execute
-- @param properties a table of properties to match against clients.  Possible entries: any properties of the client object
function run_or_raise(cmd, properties)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0
   for i, c in pairs(clients) do
      --make an array of matched clients
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end
   if n > 0 then
      local c = matched_clients[1]
      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      local ctags = c:tags()
      if #ctags == 0 then
         -- ctags is empty, show client on current tag
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)
      else
         -- Otherwise, pop to first tag client is visible on
         awful.tag.viewonly(ctags[1])
      end
      -- And then focus the client
      client.focus = c
      c:raise()
      return
   end
   awful.util.spawn(cmd)
end

-- Returns true if all pairs in table1 are present in table2
function match (table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end

-- }}}

-- {{{ Localization

os.setlocale(os.getenv("LANG"))

-- }}}

-- {{{ Error Handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    in_error = false
    awesome.connect_signal("debug::error", function (err)
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

-- {{{ Variable Definitions

-- Useful Paths
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
scriptdir = confdir .. "/scripts/"
themes = confdir .. "/themes"
active_theme = themes .. "/multicolor"

-- Init revelation
revelation.init()

-- Themes define colours, icons, and wallpapers
beautiful.init(active_theme .. "/theme.lua")

-- Pomodoro
--local pomodoro = require("pomodoro")
--pomodoro.format = function (t) return t end
--pomodoro.init()

terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "gvim"
browser = "firefox"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.tile.left,            -- 3
    awful.layout.suit.tile.bottom,          -- 4
    awful.layout.suit.tile.top,             -- 5
    awful.layout.suit.fair,                 -- 6
    awful.layout.suit.fair.horizontal,      -- 7
    awful.layout.suit.spiral,               -- 8
    awful.layout.suit.spiral.dwindle,       -- 9
    awful.layout.suit.max,                  -- 10
    --awful.layout.suit.max.fullscreen,     -- 11
    --awful.layout.suit.magnifier           -- 12
}

-- }}}

-- {{{ Wallpaper

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- }}}

-- {{{ Tags

-- Define a tag table which hold all screen tags.
tags = {
    names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    -- layout = { layouts[1], layouts[3], layouts[4], layouts[1], layouts[7], layouts[1] }
}

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, layouts[2])
end

-- }}}

-- {{{ Wibox

-- Colours
coldef  = "</span>"
colwhi  = "<span color='#b2b2b2'>"
colbwhi = "<span color='#ffffff'>"
blue = "<span color='#7493d2'>"
yellow = "<span color='#e0da37'>"
purple = "<span color='#e33a6e'>"
lightpurple = "<span color='#eca4c4'>"
azure = "<span color='#80d9d8'>"
green = "<span color='#87af5f'>"
lightgreen = "<span color='#62b786'>"
red = "<span color='#e54c62'>"
orange = "<span color='#ff7100'>"
darkorange = "<span color='#de5e1e'>"
brown = "<span color='#db842f'>"
fuchsia = "<span color='#800080'>"
gold = "<span color='#e7b400'>"

-- Net widget
netwidget = wibox.widget.imagebox()

function netInfo ()
    local fconnect = io.popen("grep nameserver /etc/resolv.conf")
    local fdevice = io.popen("grep dhcpcd /etc/resolv.conf | awk '{print $6}'")
    local connect = fconnect:read()
    local device = fdevice:read()
    fconnect:close()
    fdevice:close()
    if connect == nil then
        netwidget:set_image(beautiful.widget_network)
    else
        if device == "enp0s25" then
            netwidget:set_image(beautiful.widget_network)
        elseif device == "wlp2s0" then
            netwidget:set_image(beautiful.widget_network)
        else
            netwidget:set_image(beautiful.widget_network)
        end
    end
end

netInfo()
nettimer = timer({ timeout = 5 })
nettimer:connect_signal("timeout", function() netwidget.text = netInfo() end)
nettimer:start()

netwidget:buttons(awful.util.table.join( awful.button({ }, 1,
        function () run_or_raise("urxvt -name wicd-curses -e wicd-curses", { name = "wicd-curses" }) end)
))

-- Textclock widget
clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.widget_clock)
mytextclock = awful.widget.textclock(blue .. "%A %d %B" .. coldef .. " > " .. darkorange .. "%H:%M " .. coldef)

-- Calendar attached to the textclock
local os = os
local string = string
local table = table
local util = awful.util

char_width = nil
text_color = theme.fg_normal or "#FFFFFF"
today_color = theme.fg_focus or "#00FF00"
calendar_width = 21

local calendar = nil
local offset = 0

local data = nil

local function pop_spaces(s1, s2, maxsize)
   local sps = ""
   for i = 1, maxsize - string.len(s1) - string.len(s2) do
      sps = sps .. " "
   end
   return s1 .. sps .. s2
end

local function adjust_weekday(weekday)
    local new_value
    if weekday ~= 0 then
        new_value = weekday - 1
    else
        new_value = 6
    end
    return new_value
end

local function create_calendar()
   offset = offset or 0

   local now = os.date("*t")
   local cal_month = now.month + offset
   local cal_year = now.year
   if cal_month > 12 then
      cal_month = (cal_month % 12)
      cal_year = cal_year + 1
   elseif cal_month < 1 then
      cal_month = (cal_month + 12)
      cal_year = cal_year - 1
   end

   local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
                                            month = cal_month + 1}) - 86400)
   local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
   local first_day_in_week = adjust_weekday(tonumber(os.date("%w", first_day)))
   local result = "lu ma mi ju vi sa do\n"
   for i = 1, first_day_in_week do
      result = result .. "   "
   end

   local this_month = false
   for day = 1, last_day do
      local last_in_week = (day + first_day_in_week) % 7 == 0
      local day_str = pop_spaces("", day, 2) .. (last_in_week and "" or " ")
      if cal_month == now.month and cal_year == now.year and day == now.day then
         this_month = true
         result = result ..
            string.format('<span weight="bold" foreground = "%s">%s</span>',
                          today_color, day_str)
      else
         result = result .. day_str
      end
      if last_in_week and day ~= last_day then
         result = result .. "\n"
      end
   end

   local header
   if this_month then
      header = os.date("%a, %d %b %Y")
   else
      header = os.date("%B %Y", first_day)
   end
   return header, string.format('<span font="%s" foreground="%s">%s</span>',
                                theme.font, text_color, result)
end

local function calculate_char_width()
   return beautiful.get_font_height(theme.font) * 0.555
end

function hide()
   if calendar ~= nil then
      naughty.destroy(calendar)
      calendar = nil
      offset = 0
   end
end

function show(inc_offset)
   inc_offset = inc_offset or 0

   local save_offset = offset
   hide()
   offset = save_offset + inc_offset

   local char_width = char_width or calculate_char_width()
   local header, cal_text = create_calendar()
   calendar = naughty.notify({ title = header,
                               text = cal_text,
                               timeout = 0, hover_timeout = 0.5,
                            })
end

mytextclock:connect_signal("mouse::enter", function() show(0) end)
mytextclock:connect_signal("mouse::leave", hide)
mytextclock:buttons(util.table.join( awful.button({ }, 1, function() show(1) end),
                                     awful.button({ }, 3, function() show(-1) end)))

-- Uptime
uptimeicon = wibox.widget.imagebox()
uptimeicon:set_image(beautiful.widget_uptime)
uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, brown .. "$2.$3" .. coldef)

-- CPU widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, red .. "$1%" .. coldef, 3)

-- Temp widget
tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, yellow .. "$1°C" .. coldef, 9, {"coretemp.0", "core"} )
--vicious.register(tempwidget, vicious.widgets.thermal, yellow ..  "$1°C" .. coldef, 9, "thermal_zone0")

-- Battery widget
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, "$2", 1, "BAT1")

function batstate()
     local file = io.open("/sys/class/power_supply/BAT1/status", "r")

     if (file == nil) then
          return "Cable plugged"
     end

     local batstate = file:read("*line")
     file:close()

     if (batstate == 'Discharging' or batstate == 'Charging') then
          return batstate
     else
          return "Fully charged"
     end
end

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat,
function (widget, args)
    -- plugged
    if (batstate() == 'Cable plugged') then return "AC "
        -- critical
    elseif (args[2] <= 5 and batstate() == 'Discharging') then
        naughty.notify({
            text = "El equipo se apagará pronto",
            title = "Batería muy baja",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
        -- low
    elseif (args[2] <= 10 and batstate() == 'Discharging') then
        naughty.notify({
            text = "Conecta el cable",
            title = "Batería baja",
            position = "top_right",
            timeout = 1,
            fg="#ffffff",
            bg="#262729",
            screen = 1,
            ontop = true,
        })
    end
    return " " .. args[2] .. "% "
end, 1, 'BAT1')

-- Volume widget
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
--vicious.register(volumewidget, vicious.widgets.volume, blue .. "$1%" .. coldef,  1, "Master")
vicious.register(volumewidget, vicious.widgets.volume,
function(widget, args)
    if args[2] == "♩" then
        return blue .. "--" .. coldef
    else
        return blue .. args[1] .. "%" .. coldef
    end
end,  1, "Master")

-- Memory widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, green .. "$2M" .. coldef, 1)

-- Spacer
spacer = wibox.widget.textbox(" ")

-- }}}

-- {{{ Layout

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
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
    mypromptbox[s] = awful.widget.prompt()


    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the upper wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })
    --border_width = 0, height =  20 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(spacer)
    -- left_layout:add(mylauncher)
    -- left_layout:add(spacer)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spacer)
--    right_layout:add(pomodoro.widget)
    right_layout:add(spacer)
    right_layout:add(netwidget)
    right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(spacer)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(spacer)
    right_layout:add(uptimeicon)
    right_layout:add(uptimewidget)
    right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    -- right_layout:add(spacer)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)
    --right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20 })
    --mybottomwibox[s].visible = false

    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(spacer)

    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(spacer)
    bottom_right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

end

-- }}}

-- {{{ Mouse Bindings

-- root.buttons(awful.util.table.join(
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))

-- root.buttons(awful.util.table.join(
--     awful.button({ }, 3, function () mymainmenu:toggle() end)))

-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

    -- Capture a screenshot
    awful.key({        }, "Print", function() awful.util.spawn("screenshot", false) end),

    -- Move clients
    awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    awful.key({ altkey }, "Down",  function () awful.client.moveresize( 0,  1,  0,  0) end),
    awful.key({ altkey }, "Up",    function () awful.client.moveresize( 0, -1,  0,  0) end),
    awful.key({ altkey }, "Left",  function () awful.client.moveresize(-1,  0,  0,  0) end),
    awful.key({ altkey }, "Right", function () awful.client.moveresize( 1,  0,  0,  0) end),
    awful.key({ modkey }, "Right", awful.tag.viewnext       ),
    awful.key({ modkey }, "Left",  awful.tag.viewprev       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),
    awful.key({ modkey }, "e",     revelation),
    awful.key({ modkey }, "Up",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "Down",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

------------ --------- SUSPENDER EQUIPO --------------
        awful.key({ modkey,  }, "s" ,
             function ()
                 awful.util.spawn("gksudo pm-suspend -m" .. "'Se va a suspender el equipo, ¿estas seguro?'")
             end),
--------------------------------------------------------


    -- Show/Hide Wibox
    awful.key({ modkey }, "b",
        function ()
            mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
            mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
        end),

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
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)          end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)          end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Brightness control
    awful.key({}, "#232",  function () awful.util.spawn("xbacklight -dec 10", false) end),
    awful.key({}, "#233",  function () awful.util.spawn("xbacklight -inc 10", false) end),

    -- Volume control
    awful.key({ }, "XF86AudioRaiseVolume", function ()
                                       awful.util.spawn("amixer set Master playback 5%+", false )
                                       vicious.force({ volumewidget })
                                   end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
                                       awful.util.spawn("amixer set Master playback 5%-", false )
                                       vicious.force({ volumewidget })
                                     end),
    awful.key({ }, "XF86AudioMute", function ()
                                       awful.util.spawn("amixer sset Master playback toggle", false )
                                       vicious.force({ volumewidget })
                                     end),
    awful.key({ altkey, "Control" }, "Up", function ()
                                       awful.util.spawn("amixer set Master playback 5%+", false )
                                       vicious.force({ volumewidget })
                                   end),
    awful.key({ altkey, "Control" }, "Down", function ()
                                       awful.util.spawn("amixer set Master playback 5%-", false )
                                       vicious.force({ volumewidget })
                                     end),
    awful.key({ altkey, "Control" }, "0", function ()
                                       awful.util.spawn("amixer sset Master playback toggle", false )
                                       vicious.force({ volumewidget })
                                     end),

    -- User programs
    awful.key({ "Control", altkey }, "f", function () awful.util.spawn( "firefox", false ) end),
    awful.key({ "Control", altkey }, "t", function () awful.util.spawn( terminal, false ) end),
    awful.key({ "Control", altkey }, "d", function () awful.util.spawn( "pcmanfm", false ) end),
    awful.key({ "Control", altkey }, "g", function () awful.util.spawn( "chromium", false ) end),
    awful.key({ "Control", altkey }, "r", function () awful.util.spawn( terminal .. " -e ranger", false ) end),
    awful.key({ "Control", altkey }, "m", function () awful.util.spawn( terminal .. " -name mocp -e mocp", false ) end),
    awful.key({ "Control", altkey }, "n", function () awful.util.spawn( terminal .. " -name newsbeuter -e newsbeuter", false ) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ "Control" }, "Return", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
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
        end),

    -- Move window to workspace left/right
    awful.key({ modkey, "Shift"   }, "Left",
        function (c)
            local curidx = awful.tag.getidx()
            if curidx == 1 then
                awful.client.movetotag(tags[client.focus.screen][9])
                awful.tag.viewprev()
            else
                awful.client.movetotag(tags[client.focus.screen][curidx - 1])
                awful.tag.viewprev()
            end
        end),
    awful.key({ modkey, "Shift"   }, "Right",
        function (c)
            local curidx = awful.tag.getidx()
            if curidx == 9 then
                awful.client.movetotag(tags[client.focus.screen][1])
                awful.tag.viewnext()
            else
                awful.client.movetotag(tags[client.focus.screen][curidx + 1])
                awful.tag.viewnext()
            end
        end),

    -- Show/hide border
    awful.key({ modkey }, "i",
        function (c)
            if   c.border_width == 0 then c.border_width = beautiful.border_width
            else c.border_width = 0 end
        end),

    awful.key({ modkey }, "s",
        function (c)
            scratch.pad.set(c, 0.50, 1, false)
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
                        screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      screen = mouse.screen
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
                      buttons = clientbuttons,
                      size_hints_honor = false
                     }
    },
    { rule = { class = "Gvim" }, properties = { size_hints_honor = false } },
    { rule = { class = "Chromium" }, properties = { tag = tags[1][9] } },
    { rule = { class = "Firefox" }, properties = { tag = tags[1][1] } },
    { rule = { class = "Gmail" }, properties = { tag = tags[1][9] } },
    { rule = { name = "mocp" }, properties = { tag = tags[1][8] } },
    { rule = { name = "newsbeuter" }, properties = { tag = tags[1][2] } },
    { rule = { instance = "plugin-container" }, properties = { floating = true } },

}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- if not startup then
    --     -- Put windows in a smart way, only if they does not set an initial
    --     -- position.
    --     if not c.size_hints.user_position and
    --         not c.size_hints.program_position then
    --             awful.placement.no_overlap(c)
    --             awful.placement.no_offscreen(c)
    --     end
    -- end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
