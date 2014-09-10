-- pomodoro timer widget
pomodoro = {}
-- tweak these values in seconds to your liking
pomodoro.pause_duration = 300
pomodoro.work_duration = 1200

pomodoro.pause_title = "Pausa finalizada."
pomodoro.pause_text = "Vuelve al trabajo meloncio!"
pomodoro.work_title = "Pomodoro finalizado."
pomodoro.work_text = "Tomate un kitkat!"
pomodoro.working = true
pomodoro.left = pomodoro.work_duration
pomodoro.widget = widget({ type = "textbox" })
awful.widget.layout.margins[pomodoro.widget] = { right = 5 }
pomodoro.timer = timer { timeout = 1 }

function pomodoro:settime(t)
  if t >= 3600 then -- more than one hour!
    t = os.date("!%X", t-3600)
  else
    t = os.date("!%M:%S", t)
  end
--  self.widget.text = string.format(" | <span color='#7F9F7F'>Pomodoro:</span> <span color='#CC9393'><b>%s</b></span> | ", t)
self.widget.text = string.format("<span color='#CC9393'><b>%s</b></span> | ", t)

end

function pomodoro:notify(title, text, duration, working)
  naughty.notify {
    bg = "#ff0000",
    fg = "#aaaaaa",
    title = title,
    text = text,
    timeout = 10
  }

  pomodoro.left = duration
  pomodoro:settime(duration)
  pomodoro.working = working
end

pomodoro:settime(pomodoro.work_duration)

pomodoro.widget:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function()
      pomodoro.last_time = os.time()
      pomodoro.timer:start()
    end),
    awful.button({ }, 2, function()
      pomodoro.timer:stop()
    end),
    awful.button({ }, 3, function()
      pomodoro.timer:stop()
      pomodoro.left = pomodoro.work_duration
      pomodoro:settime(pomodoro.work_duration)
    end)
))

pomodoro.timer:add_signal("timeout", function()
  local now = os.time()
  pomodoro.left = pomodoro.left - (now - pomodoro.last_time)
  pomodoro.last_time = now

  if pomodoro.left > 0 then
    pomodoro:settime(pomodoro.left)
  else
    if pomodoro.working then
      pomodoro:notify(pomodoro.work_title, pomodoro.work_text,
        pomodoro.pause_duration, false)
    else
      pomodoro:notify(pomodoro.pause_title, pomodoro.pause_text,
        pomodoro.work_duration, true)
    end
    pomodoro.timer:stop()
  end
end)
