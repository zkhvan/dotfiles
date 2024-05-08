-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

local scheme = wezterm.color.get_builtin_schemes()['Tomorrow Night (Gogh)']
scheme.ansi[1] = '#1d1f21'

config.color_schemes = {
  ['Tomorrow Night Dark (Gogh)'] = scheme,
}
config.color_scheme = 'Tomorrow Night Dark (Gogh)'

config.default_cursor_style = 'SteadyBlock'
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = '0.5cell',
  right = '0.5cell',
  top = 0,
  bottom = 0,
}

-- Fix double-wide nerd fonts when using builtin Nerd Font Symbols
config.allow_square_glyphs_to_overflow_width = 'Never'

config.adjust_window_size_when_changing_font_size = false

config.command_palette_font_size = 16.0

config.font = wezterm.font_with_fallback({
  {
    family = 'JetBrains Mono',
    scale = 1.2,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },

  -- emoji fallback 👉 👀 😁 💩 ✅
  'Noto Color Emoji',
})
config.font_size = 12.0
-- config.line_height = 1.24

config.enable_scroll_bar = true
config.scrollback_lines = 9999
config.hide_tab_bar_if_only_one_tab = true

-- Shortcut to close windows in nvim easily
config.keys = {
  {
    key = 'Escape',
    mods = 'SHIFT',
    action = wezterm.action.SendKey({
      key = 'F13',
    }),
  },
}

config.debug_key_events = true

-- and finally, return the configuration to wezterm
return config
