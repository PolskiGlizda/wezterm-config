local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

-- Returns true when the active pane is running Neovim/Vim.
local function is_vim(pane)
	local proc = pane:get_foreground_process_info()
	if not proc then return false end
	return proc.name:find("n?vim") ~= nil
end

local dir_map = { h = "Left", j = "Down", k = "Up", l = "Right" }

-- Smart directional move: passes ALT+h/j/k/l through to Neovim when it's
-- focused, otherwise activates the adjacent WezTerm pane.
-- Neovim side (add to keymaps.lua):
--   for _, k in ipairs({ "h", "j", "k", "l" }) do
--     vim.keymap.set({ "n", "t" }, "<A-" .. k .. ">", "<C-w>" .. k)
--   end
local function nav_key(key)
	return {
		key  = key,
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action(act.SendKey({ key = key, mods = "ALT" }), pane)
			else
				win:perform_action(act.ActivatePaneDirection(dir_map[key]), pane)
			end
		end),
	}
end

function M.apply(config)
	config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }

	config.keys = {
		-- ── Pane splits ──────────────────────────────────────────────────
		{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-",  mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "z",  mods = "LEADER", action = act.TogglePaneZoomState },
		{ key = "x",  mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

		-- ── Pane navigation (smart: WezTerm ↔ Neovim) ───────────────────
		nav_key("h"), nav_key("j"), nav_key("k"), nav_key("l"),

		-- ── Pane resize (ALT+SHIFT+hjkl) ─────────────────────────────────
		{ key = "H", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left",  3 }) },
		{ key = "J", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down",  3 }) },
		{ key = "K", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up",    3 }) },
		{ key = "L", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },

		-- ── Tabs ─────────────────────────────────────────────────────────
		{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "[", mods = "ALT",    action = act.ActivateTabRelative(-1) },
		{ key = "]", mods = "ALT",    action = act.ActivateTabRelative(1) },
		{ key = "{", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = "}", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },

		-- ── Copy mode ────────────────────────────────────────────────────
		{ key = "Enter", mods = "LEADER", action = act.ActivateCopyMode },

		-- ── Config reload ────────────────────────────────────────────────
		{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

		-- ── Font size ────────────────────────────────────────────────────
		{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = act.ResetFontSize },

		-- ── Pass CTRL+S through when leader is pressed twice ─────────────
		{ key = "s", mods = "LEADER|CTRL", action = act.SendKey({ key = "s", mods = "CTRL" }) },
	}

	-- ALT+1..9 to jump to tab by index
	for i = 1, 9 do
		table.insert(config.keys, {
			key    = tostring(i),
			mods   = "ALT",
			action = act.ActivateTab(i - 1),
		})
	end

	-- Right-click pastes from clipboard
	config.mouse_bindings = {
		{
			event  = { Down = { streak = 1, button = "Right" } },
			mods   = "NONE",
			action = act.PasteFrom("Clipboard"),
		},
	}
end

return M
