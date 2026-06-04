local wezterm = require("wezterm")
local M = {}

-- Tokyo Night (night) palette — mirrors folke/tokyonight.nvim
local t = {
	bg       = "#1a1b26",
	bg_dark  = "#15161e",
	bg_hl    = "#292e42",
	fg       = "#c0caf5",
	fg_dark  = "#a9b1d6",
	comment  = "#565f89",
	blue     = "#7aa2f7",
	cyan     = "#7dcfff",
	green    = "#9ece6a",
	yellow   = "#e0af68",
	orange   = "#ff9e64",
	red      = "#f7768e",
	purple   = "#bb9af7",
}

function M.apply(config)
	-- ── Font ─────────────────────────────────────────────────────────────
	config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
	config.font_size = 13.0
	config.line_height = 1.1
	config.underline_thickness = 2

	-- ── Colors ───────────────────────────────────────────────────────────
	config.color_scheme = "Tokyo Night"
	config.colors = {
		tab_bar = {
			background = t.bg_dark,
			active_tab = {
				bg_color  = t.blue,
				fg_color  = t.bg_dark,
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = t.bg,
				fg_color = t.comment,
			},
			inactive_tab_hover = {
				bg_color = t.bg_hl,
				fg_color = t.fg_dark,
			},
			new_tab = {
				bg_color = t.bg_dark,
				fg_color = t.comment,
			},
			new_tab_hover = {
				bg_color = t.bg_hl,
				fg_color = t.blue,
			},
		},
	}

	-- ── Window ───────────────────────────────────────────────────────────
	config.window_decorations        = "RESIZE"   -- no title bar
	config.window_padding            = { left = 8, right = 8, top = 8, bottom = 8 }
	config.window_background_opacity = 0.97

	-- ── Tab bar ──────────────────────────────────────────────────────────
	config.use_fancy_tab_bar         = true
	config.tab_bar_at_bottom         = false
	config.hide_tab_bar_if_only_one_tab = false
	config.window_frame = {
		font      = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
		font_size = 11.0,
		active_titlebar_bg   = t.bg_dark,
		inactive_titlebar_bg = t.bg_dark,
	}

	-- ── Misc ─────────────────────────────────────────────────────────────
	config.scrollback_lines      = 10000
	config.default_cursor_style  = "BlinkingBar"
	config.cursor_blink_rate     = 500
	-- "wezterm" TERM entry enables undercurl + 24-bit colour in Neovim
	config.term                  = "wezterm"

	-- ── Right-side status: date/time (mirrors lualine_z) ─────────────────
	wezterm.on("update-right-status", function(window, _pane)
		window:set_right_status(wezterm.format({
			{ Foreground = { Color = t.comment } },
			{ Text = wezterm.strftime("  %a %b %-d  %-I:%M %p  ") },
		}))
	end)
end

return M
