# wezterm config

Personal WezTerm configuration. Tokyo Night theme, JetBrainsMono Nerd Font, modular Lua structure.

## Structure

```
~/.config/wezterm/
├── wezterm.lua       entry point
├── appearance.lua    font, colors, window, tab bar, status
└── keys.lua          keybindings, pane navigation, mouse
```

## Keybindings

Leader key: `CTRL+S` (1 s timeout). Press `CTRL+S` twice to send raw `CTRL+S` to the shell.

### Panes

| Action | Keys |
|---|---|
| Split right | `LEADER` `\` |
| Split down | `LEADER` `-` |
| Zoom / unzoom | `LEADER` `z` |
| Close pane | `LEADER` `x` |
| Navigate | `ALT` + `h` / `j` / `k` / `l` |
| Resize | `ALT+SHIFT` + `H` / `J` / `K` / `L` |

Pane navigation is smart: when Neovim is focused, `ALT+hjkl` is forwarded to Neovim instead of switching WezTerm panes. Neovim maps `<A-hjkl>` to `smart-splits.nvim` cursor movement, so the key crosses both Neovim split and WezTerm pane boundaries transparently.

### Tabs

| Action | Keys |
|---|---|
| New tab | `LEADER` `t` |
| Close tab | `LEADER` `w` |
| Previous / next | `ALT` `[` / `ALT` `]` |
| Switch by number | `ALT` `1`–`9` |
| Move tab left / right | `ALT+SHIFT` `{` / `}` |

### Workspaces

| Action | Keys |
|---|---|
| Project launcher | `LEADER` `p` |

`LEADER+p` scans `$HOME` (up to depth 5) for git repositories using `fd`, presents them in a fuzzy picker, and opens the selected directory in a named workspace. Existing workspaces are preserved in the background and can be switched back to with the same picker.

### Other

| Action | Keys |
|---|---|
| Copy mode | `LEADER` `Enter` |
| Reload config | `LEADER` `r` |
| Increase / decrease font size | `CTRL` `=` / `CTRL` `-` |
| Reset font size | `CTRL` `0` |

Right-click pastes from the clipboard.

## Neovim compatibility

`config.term = "wezterm"` sets `$TERM` to the WezTerm terminfo entry, which provides:

- **True 24-bit color** — `termguicolors` works correctly
- **Undercurl** — wavy LSP diagnostics render as intended
- **Mouse** — click and scroll pass through to Neovim
- **OSC 52 clipboard** — yanking into the system clipboard works over SSH
