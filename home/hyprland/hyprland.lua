local mod = "SUPER"
local terminal = "wezterm"
local fileManager = "nautilus"
local screenshotEnv = "HYPRSHOT_DIR=~/Pictures/Screenshots"
local screenshotName = "$(date +'Screenshot_%Y%m%d_%H%M%S.png')"

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "colemak",
    accel_profile = "flat",
    sensitivity = -0.8,
    repeat_rate = 30,
    repeat_delay = 200,
  },
  cursor = {
    no_hardware_cursors = 1,
  },
  general = {
    gaps_in = 6,
    gaps_out = 6,
    border_size = 0,
  },
  decoration = {
    rounding = 12,
    blur = {
      size = 10,
      passes = 3,
      input_methods = true,
      input_methods_ignorealpha = 0.0,
    },
    shadow = { enabled = false },
  },
  animations = {
    enabled = false,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  dwindle = {
    preserve_split = true,
    force_split = 2,
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    background_color = "0x000000",
    animate_manual_resizes = true,
  },
})

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.monitor({
  output = "desc:ASUSTek COMPUTER INC VG279QM M3LMQS406491",
  mode = "preferred",
  position = "0x0",
  scale = 1,
})
hl.monitor({
  output = "desc:Microstep MSI MP273A PB4H643C00347",
  mode = "1920x1080@100",
  position = "1920x-350",
  scale = 1,
  transform = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "DP-2" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })

hl.bind(mod .. " + ESCAPE", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + M", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + SEMICOLON", hl.dsp.window.float())
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + K", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind(mod .. " + BACKSLASH", hl.dsp.exec_cmd("hyprpicker -na"))

hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(screenshotEnv .. " hyprshot -z -f " .. screenshotName .. " -m region"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd(screenshotEnv .. " hyprshot -z -f " .. screenshotName .. " -m window"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd(screenshotEnv .. " hyprshot -z -f " .. screenshotName .. " -m output"))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc mpris previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc mpris playPause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc mpris next"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc audio mute"))

hl.bind(mod .. " + SHIFT + SLASH", hl.dsp.exec_cmd("dms ipc keybinds toggle hyprland"))

for i = 1, 10 do
  local key = tostring(i % 10)
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end

hl.bind(mod .. " + n", hl.dsp.focus({ direction = "l" }), { repeating = true })
hl.bind(mod .. " + o", hl.dsp.focus({ direction = "r" }), { repeating = true })
hl.bind(mod .. " + i", hl.dsp.focus({ direction = "u" }), { repeating = true })
hl.bind(mod .. " + e", hl.dsp.focus({ direction = "d" }), { repeating = true })

hl.bind(mod .. " + CTRL + n", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + o", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + i", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + e", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })

hl.bind(mod .. " + SHIFT + n", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(mod .. " + SHIFT + o", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(mod .. " + SHIFT + i", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(mod .. " + SHIFT + e", hl.dsp.window.move({ direction = "d" }), { repeating = true })

hl.bind(mod .. " + CTRL + SHIFT + n", hl.dsp.window.move({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + SHIFT + o", hl.dsp.window.move({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + SHIFT + i", hl.dsp.window.move({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + SHIFT + e", hl.dsp.window.move({ x = 0, y = 50, relative = true }), { repeating = true })

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc audio decrement 2"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc audio increment 2"), { repeating = true })

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- openrgb --startminimized")
  hl.exec_cmd("uwsm app -- fcitx5")
  hl.exec_cmd("hyprctl setcursor capitaine-cursors 24")
end)
