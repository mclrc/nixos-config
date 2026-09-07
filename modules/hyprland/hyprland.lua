-- Hyprland configuration.
--
-- This is a verbatim Lua config, copied into ~/.config/hypr/hyprland.lua by the
-- sibling hyprland.nix -- edit it as Lua, not as Nix (same deal as
-- modules/rofi/theme.rasi). `hl` is Hyprland's config API; the stubs it is
-- checked against live in ${hyprland}/share/hypr/stubs/hl.meta.lua, and
-- home-manager points the Lua LSP at them via ~/.config/hypr/.luarc.json.
--
-- Ported from the old hyprlang (.conf) config: Hyprland 0.56 warns that the
-- .conf format goes away in 0.57.

------------------
---- PROGRAMS ----
------------------

local mod         = "SUPER"
local terminal    = "alacritty"
local fileManager = "nautilus"
local menu        = "rofi -show drun -show window -show ssh"

------------------
---- MONITORS ----
------------------

-- desc: matching keeps these stable across port changes.

-- Lenovo T27hv-30 pair (top row, side by side)
hl.monitor({
    output   = "desc:Lenovo Group Limited T27hv-30 VTV0A4NU",
    mode     = "2560x1440@60",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "desc:Lenovo Group Limited T27hv-30 VTV0UEPU",
    mode     = "2560x1440@60",
    position = "2560x0",
    scale    = 1,
})

-- ViewSonic XG2705-2K -- offset so its center matches the Lenovo pair's center (x=2560)
hl.monitor({
    output   = "desc:ViewSonic Corporation XG2705-2K WBJ211800224",
    mode     = "2560x1440@144",
    position = "1280x0",
    scale    = 1,
})

-- Laptop screen (centered below any of the external setups above)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60",
    position = "1600x1440",
    scale    = 1,
})

-- Any other external monitor: auto-place at preferred resolution
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("waybar")
    -- hyprpaper.conf is written by hyprland.nix. Build the path from $HOME
    -- rather than "~", which exec_cmd does not expand.
    hl.exec_cmd("hyprpaper -c " .. os.getenv("HOME") .. "/.config/hypr/hyprpaper.conf")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 2,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 6,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        -- pseudotile was removed in Hyprland 0.55; pseudo is per-window via the pseudo dispatcher
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },

    debug = {
        disable_logs = false,
    },

    input = {
        kb_layout    = "us,de",
        kb_options   = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity  = 1,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
        },
    },
})

--------------------
---- ANIMATIONS ----
--------------------

-- Curves were `bezier = name,x1,y1,x2,y2` in hyprlang; the two control points
-- are now an explicit table of pairs.
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },   { 0.32, 1 }    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 }   } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },      { 1, 1 }       } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },  { 0.75, 1.0 }  } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },   { 0.1, 1 }     } })

-- `animation = leaf, enabled, speed, curve[, style]` becomes named fields.
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

---------------------
---- KEYBINDINGS ----
---------------------

-- hl.dsp.focus() is layer-local (tiled<->tiled, float<->float). This jumps
-- between the two layers, replacing the old `hyprctl | grep` shell one-liner
-- that drove `focuswindow floating|tiled`. Scoped to the active workspace so it
-- can never yank focus to another workspace.
local function focusOtherLayer()
    local active = hl.get_active_window()
    local wantFloating = not (active ~= nil and active.floating)

    local workspace = hl.get_active_workspace()
    if workspace == nil then return end

    local matches = hl.get_windows({ workspace = workspace.id, floating = wantFloating })
    if matches ~= nil and matches[1] ~= nil then
        hl.dispatch(hl.dsp.focus({ window = matches[1] }))
    end
end

hl.bind(mod .. " + Return",       hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q",            hl.dsp.window.close())
hl.bind(mod .. " + M",            hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(mod .. " + E",            hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + space",        focusOtherLayer)
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + D",            hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + P",            hl.dsp.window.pseudo())
hl.bind(mod .. " + F",            hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mod .. " + V",            hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + Backspace",    hl.dsp.exec_cmd("swaylock -c 000000"))

-- Move focus, arrows and hjkl
local directions = {
    { key = "left",  dir = "left" },
    { key = "right", dir = "right" },
    { key = "up",    dir = "up" },
    { key = "down",  dir = "down" },
    { key = "H",     dir = "left" },
    { key = "L",     dir = "right" },
    { key = "K",     dir = "up" },
    { key = "J",     dir = "down" },
}

for _, d in ipairs(directions) do
    hl.bind(mod .. " + " .. d.key, hl.dsp.focus({ direction = d.dir }))
end

-- Move windows with SHIFT + hjkl
for _, d in ipairs({
    { key = "H", dir = "left" },
    { key = "J", dir = "down" },
    { key = "K", dir = "up" },
    { key = "L", dir = "right" },
}) do
    hl.bind(mod .. " + SHIFT + " .. d.key, hl.dsp.window.move({ direction = d.dir }))
end

-- Resize windows with SHIFT + arrow keys
for _, r in ipairs({
    { key = "left",  x = -20, y = 0 },
    { key = "right", x = 20,  y = 0 },
    { key = "up",    x = 0,   y = -20 },
    { key = "down",  x = 0,   y = 20 },
}) do
    hl.bind(mod .. " + SHIFT + " .. r.key, hl.dsp.window.resize({ x = r.x, y = r.y, relative = true }))
end

-- Switch workspaces, and move the active window to one. 10 lives on key 0.
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with the mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume and brightness. These repeat on hold (the old `binde`).
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { repeating = true })

-- Media keys keep working while the screen is locked (the old `bindl`).
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
