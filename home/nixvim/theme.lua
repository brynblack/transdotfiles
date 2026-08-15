-- Post-processing on top of noctalia's generated matugen.lua. Nothing here edits
-- that file, so all of it survives regeneration.

---------------------------------------------------------------------------
-- colour maths
---------------------------------------------------------------------------

local function hex2rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end

local function rgb2hex(r, g, b)
  local function c(x)
    return math.floor(math.min(math.max(x, 0), 1) * 255 + 0.5)
  end
  return string.format("#%02x%02x%02x", c(r), c(g), c(b))
end

local function rgb2hsl(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l = 0, 0, (max + min) / 2
  local d = max - min
  if d > 0 then
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h * 60
  end
  return h, s, l
end

local function hsl2rgb(h, s, l)
  h = (h % 360) / 360
  if s == 0 then
    return l, l, l
  end
  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  local function hue(t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end
  return hue(h + 1 / 3), hue(h), hue(h - 1 / 3)
end

local function luminance(hex)
  local function lin(c)
    return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
  end
  local r, g, b = hex2rgb(hex)
  return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)
end

local function contrast(a, b)
  local la, lb = luminance(a), luminance(b)
  if la < lb then
    la, lb = lb, la
  end
  return (la + 0.05) / (lb + 0.05)
end

---------------------------------------------------------------------------
-- syntax accents
---------------------------------------------------------------------------

-- Noctalia's material palette yields roughly three distinct hues, so the eight
-- base16 accent slots collide: strings and functions come out identical, as do
-- keywords and classes. Redistribute the accents evenly around the palette's
-- dominant hue, preserving each slot's saturation and lightness (so the theme
-- still reads as the theme) and its position in the original hue order (so the
-- change is the smallest one that separates them).
-- base08 is left alone: it is the red slot, and base16 drives DiagnosticError,
-- diff-deleted and error text from it. Rotating it lands errors on whatever hue
-- the arithmetic picks, which on this palette was magenta.
local ANCHOR = "base08"
local ACCENTS = { "base09", "base0A", "base0B", "base0C", "base0D", "base0E" }
-- Below this many degrees per step the hues are too close to tell apart, so
-- lightness does the separating instead.
local MIN_STEP = 6

local function respread(colors)
  if type(colors) ~= "table" then
    return colors
  end

  local anchor = colors[ANCHOR]
  if type(anchor) ~= "string" or not anchor:match("^#%x%x%x%x%x%x$") then
    return colors
  end
  local anchor_h = rgb2hsl(hex2rgb(anchor))

  local info = {}
  for _, key in ipairs(ACCENTS) do
    local value = colors[key]
    if type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then
      local h, s, l = rgb2hsl(hex2rgb(value))
      info[#info + 1] = { key = key, h = h, s = s, l = l }
    end
  end
  if #info < 2 then
    return colors
  end

  -- Sort by distance from the anchor so the redistribution preserves the
  -- original hue order — the smallest change that separates them.
  for _, e in ipairs(info) do
    e.d = (e.h - anchor_h) % 360
  end
  table.sort(info, function(a, b)
    return a.d < b.d
  end)

  -- Spread across the span the palette already occupies, leaving its outermost
  -- hues exactly where they were. Fanning out over a fixed arc instead invents
  -- hues the theme does not contain: on a violet palette it walked strings and
  -- constants into orange and green.
  local lo, hi = info[1].d, info[#info].d
  local step = (hi - lo) / (#info - 1)

  local out = vim.deepcopy(colors)
  for i, e in ipairs(info) do
    local lightness = e.l
    if step < MIN_STEP then
      -- Effectively a single-hue palette. Stagger lightness around each accent's
      -- own value rather than manufacture hues that clash with the desktop.
      local offset = (i - (#info + 1) / 2) * 0.045
      lightness = math.min(math.max(e.l + offset, 0.25), 0.9)
    end
    out[e.key] = rgb2hex(hsl2rgb(anchor_h + lo + (i - 1) * step, e.s, lightness))
  end
  return out
end

---------------------------------------------------------------------------
-- transparency
---------------------------------------------------------------------------

-- Popups (blink-cmp, Pmenu), the visual selection and the Telescope
-- title/selection bars deliberately keep their backgrounds: those float over
-- code, where transparency costs more readability than it buys.
local TRANSPARENT_GROUPS = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "SignColumn",
  "FoldColumn",
  "Folded",
  "EndOfBuffer",
  "LineNr",
  "LineNrAbove",
  "LineNrBelow",
  "CursorLineNr",
  "WinSeparator",
  "VertSplit",
  "MsgArea",
  "MsgSeparator",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "GitSignsAdd",
  "GitSignsChange",
  "GitSignsDelete",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeEndOfBuffer",
  "NeoTreeWinSeparator",
  "NeoTreeFloatNormal",
  "NeoTreeFloatBorder",
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopeResultsNormal",
  "TelescopePreviewNormal",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopePromptPrefix",
  "TelescopePromptCounter",
}

-- base16 draws VertSplit in base05 — the foreground colour — so the divider
-- renders as a full-brightness white line at roughly 14:1 against the
-- background, far louder than a divider should be. base03 is the slot base16
-- reserves for invisibles and dividers and lands near 3:1; base02 (~1.4:1) makes
-- it almost invisible if you would rather the gaps did the separating.
local SEPARATOR_SLOT = "base03"
local SEPARATOR_GROUPS = { "WinSeparator", "VertSplit", "NeoTreeWinSeparator" }

-- bufferline generates a few dozen groups and renames them between releases, so
-- match the prefix rather than listing them. This is what leaves the focused tab
-- opaque otherwise: it is BufferLineBufferSelected, not TabLineSel.
local TRANSPARENT_PREFIXES = { "BufferLine" }

local function strip_bg(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if next(hl) ~= nil and hl.bg ~= nil then
    hl.bg, hl.ctermbg = nil, nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

-- The palette base16 was last handed, kept so the passes below can reference
-- slots by name rather than re-deriving colours. source_palette is the same
-- thing before respread() touched it.
local applied_palette = nil
local source_palette = nil

-- nvim's built-in terminal renders ANSI through g:terminal_color_0..15. base16
-- assigns those on its own convention, which disagrees with the mapping
-- noctalia's wezterm template uses at indices 4, 5 and 6 — so :terminal came out
-- subtly different from the same shell in wezterm. Use noctalia's mapping, and
-- read from the palette as generated rather than the respread one, so ANSI
-- output is identical in both.
local TERMINAL_SLOTS = {
  [0] = "base00",
  [1] = "base08",
  [2] = "base0B",
  [3] = "base0A",
  [4] = "base09",
  [5] = "base0D",
  [6] = "base0E",
  [7] = "base05",
  [8] = "base03",
  [9] = "base08",
  [10] = "base0B",
  [11] = "base0A",
  [12] = "base09",
  [13] = "base0D",
  [14] = "base0E",
  [15] = "base07",
}

local function sync_terminal_colours()
  if type(source_palette) ~= "table" then
    return
  end
  for index, slot in pairs(TERMINAL_SLOTS) do
    local colour = source_palette[slot]
    if type(colour) == "string" then
      vim.g["terminal_color_" .. index] = colour
    end
  end
end

local function tone_separators()
  local colour = type(applied_palette) == "table" and applied_palette[SEPARATOR_SLOT]
  if type(colour) ~= "string" then
    return
  end

  for _, group in ipairs(SEPARATOR_GROUPS) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if next(hl) ~= nil then
      hl.fg, hl.bg, hl.ctermbg = colour, nil, nil
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

-- In a terminal, clearing Normal's background lets the terminal show through.
-- Neovide *is* the window, so there is nothing behind to reveal: it needs a real
-- colour to apply neovide_normal_opacity to, and with none set it falls back to
-- a flat default and the palette tint is lost.
local function restore_neovide_background()
  if not vim.g.neovide then
    return
  end

  local colour = type(applied_palette) == "table" and applied_palette.base00
  if type(colour) ~= "string" then
    return
  end

  for _, group in ipairs({ "Normal", "NormalNC" }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = colour
    vim.api.nvim_set_hl(0, group, hl)
  end
end

local function clear_backgrounds()
  for _, group in ipairs(TRANSPARENT_GROUPS) do
    strip_bg(group)
  end

  for group in pairs(vim.api.nvim_get_hl(0, {})) do
    for _, prefix in ipairs(TRANSPARENT_PREFIXES) do
      if group:sub(1, #prefix) == prefix then
        strip_bg(group)
      end
    end
  end

  -- With every tab transparent the selected one loses its only cue, so give it
  -- one back that does not need a background.
  local selected = vim.api.nvim_get_hl(0, { name = "BufferLineBufferSelected", link = false })
  if next(selected) ~= nil then
    selected.bold = true
    vim.api.nvim_set_hl(0, "BufferLineBufferSelected", selected)
  end
end

-- bufferline builds its per-filetype icon highlights lazily — the first time a
-- filetype is rendered, set_icon_highlight() copies bg from the parent tab group
-- and caches the result. A one-shot sweep over existing groups therefore always
-- misses them, which leaves an opaque patch behind the icon. Every bufferline
-- highlight funnels through highlights.set(), so force transparency there
-- instead and it holds for groups created at any point later.
local function patch_bufferline()
  local ok, highlights = pcall(require, "bufferline.highlights")
  if not ok or type(highlights.set) ~= "function" then
    return
  end
  if highlights.__transparent_patched then
    return
  end

  local original = highlights.set
  highlights.set = function(name, opts)
    if type(opts) == "table" then
      opts = vim.tbl_extend("force", opts, { bg = "NONE", ctermbg = "NONE" })
    end
    return original(name, opts)
  end
  highlights.__transparent_patched = true

  -- Groups already cached from before the patch keep their old background.
  if type(highlights.reset_icon_hl_cache) == "function" then
    highlights.reset_icon_hl_cache()
  end
end

-- lualine builds its own theme table from the colorscheme instead of reading
-- StatusLine, so clearing highlight groups never reaches it. Re-derive its auto
-- theme, drop the section backgrounds, and feed it back through setup().
-- Below this, a section's foreground is unreadable once its block is removed.
local MIN_SECTION_CONTRAST = 3

local function clear_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  package.loaded["lualine.themes.auto"] = nil
  local ok_theme, theme = pcall(require, "lualine.themes.auto")
  if not ok_theme or type(theme) ~= "table" then
    return
  end

  local editor_bg = type(applied_palette) == "table" and applied_palette.base00

  for _, mode in pairs(theme) do
    if type(mode) == "table" then
      for _, section in pairs(mode) do
        if type(section) == "table" then
          -- The mode and location sections carry a near-black foreground chosen
          -- to read against a bright block. Removing the block leaves that text
          -- at about 1:1 against the editor, so promote the block's own colour
          -- to the foreground: the mode reads as coloured text instead of a
          -- coloured bar. Sections whose foreground already stands on its own
          -- are left alone.
          if
            type(editor_bg) == "string"
            and type(section.fg) == "string"
            and type(section.bg) == "string"
            and section.fg:match("^#%x%x%x%x%x%x$")
            and section.bg:match("^#%x%x%x%x%x%x$")
            and contrast(section.fg, editor_bg) < MIN_SECTION_CONTRAST
          then
            section.fg = section.bg
          end
          section.bg = nil
        end
      end
    end
  end

  local config = lualine.get_config()
  config.options.theme = theme
  lualine.setup(config)
end

---------------------------------------------------------------------------
-- wire up
---------------------------------------------------------------------------

-- Hook base16 rather than matugen: the SIGUSR1 handler in the generated module
-- does `package.loaded['matugen'] = nil` and re-requires, which would discard a
-- wrapper placed on matugen itself. base16-colorscheme stays loaded, so wrapping
-- it survives every re-theme.
local base16 = require("base16-colorscheme")
local base16_setup = base16.setup

base16.setup = function(colors, config)
  source_palette = type(colors) == "table" and vim.deepcopy(colors) or nil
  applied_palette = respread(colors)
  base16_setup(applied_palette, config)
  -- Deferred so matugen's own Telescope highlight calls, which run after
  -- base16.setup() returns, don't paint the backgrounds straight back on.
  vim.schedule(function()
    patch_bufferline()
    clear_backgrounds()
    restore_neovide_background()
    sync_terminal_colours()
    tone_separators()
    clear_lualine()
  end)
end

-- Also up front, so the patch is in place before bufferline's first render even
-- if that happens ahead of the deferred pass above.
patch_bufferline()

-- Load noctalia's generated palette. The module installs its own SIGUSR1
-- handler, and the template's apply.sh signals nvim after each write, so live
-- re-theming needs nothing further here.
--
-- Keep this written exactly as `pcall(require, 'matugen')`: apply.sh greps
-- init.lua for that literal and, when it doesn't find it, appends its own loader
-- — which fails against nixvim's read-only store symlink and, under
-- `set -euo pipefail`, kills the script before it reaches its pkill.
local ok, matugen = pcall(require, "matugen")
if ok then
  matugen.setup()
end
