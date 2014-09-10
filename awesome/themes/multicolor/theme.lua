---------------------------
-- Default-PERSONALIZADO-KIKE awesome theme --
---------------------------

theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/multicolor"

theme.font          = "Inconsolata 10"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ff8c00"
theme.fg_urgent     = "#af1d18"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#1c2022"
theme.border_focus  = "#606060"
theme.border_marked = "#3ca4d8"

theme.mouse_finder_color = "#afa72e"




-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "awsetbg " .. theme.confdir .. "/foto_asturias_llanes.jpg" }

-- imagenes widgets--
--theme.imagen_pomodoro = theme.confdir .. "/widgets/pomodoro_22_22.png"
theme.imagen_pomodoro = "/home/kike/.config/awesome/icons/pomodoro/pomodoro_22_22.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme.confdir .. "/layouts/fairh.png"
theme.layout_fairv = theme.confdir .. "/layouts/fairv.png"
theme.layout_floating  = theme.confdir .. "/layouts/floating.png"
theme.layout_magnifier = theme.confdir .. "/layouts/magnifier.png"
theme.layout_max = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tile = theme.confdir .. "/layouts/tile.png"
theme.layout_tiletop = theme.confdir ..  "/layouts/tiletop.png"
theme.layout_spiral  = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle = theme.confdir .. "/layouts/dwindle.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
