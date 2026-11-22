# Omarchy Customizations

Please apply these customizations to my Omarchy setup (omitting items already managed by stowed dotfiles such as `foot` and `nvim`):

1. **Hyprland Input (`~/.config/hypr/input.lua`):**
   - Map Caps Lock to Control:
     ```lua
     hl.config({ input = { kb_options = "ctrl:nocaps" } })
     ```

2. **Hyprland Look & Feel (`~/.config/hypr/looknfeel.lua`):**
   - Enable frosted glass blur:
     ```lua
     require("default.hypr.glass")()
     ```
   - Make Antigravity, Herdr App, and Emacs glassy:
     ```lua
     o.window("[Aa]ntigravity", { opacity = "0.88 0.85" })
     o.window("herdr-app", { opacity = "0.88 0.85" })
     o.window("[Ee]macs", { opacity = "0.88 0.85" })
     ```

3. **Scroll Direction (`~/.config/hypr/input.lua`):**
   - Configure natural scrolling for touchpads only while keeping standard wheel scrolling for physical mice:
     ```lua
     hl.config({
       input = {
         natural_scroll = false,
         touchpad = {
           natural_scroll = true,
         },
       },
     })
     ```
   - Reload Hyprland and verify with `hyprctl reload && hyprctl configerrors`.

4. **Sync Zen Browser with Omarchy Theme:**
   - In all Zen profiles under `~/.config/zen/`, ensure `~/.config/zen/<profile>/user.js` has:
     ```js
     user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
     user_pref("browser.tabs.allow_transparent_browser", true);
     user_pref("widget.transparent-windows", true);
     ```
   - Create an executable Omarchy theme hook at `~/.config/omarchy/hooks/theme-set.d/20-zen-sync` that reads `~/.local/state/omarchy/current/theme/colors.toml`, parses the active theme colors, and generates `~/.config/zen/<profile>/chrome/userChrome.css` across all profiles.
   - In `userChrome.css`, make `#zen-toolbar-background` translucent with `backdrop-filter: blur(16px)` and an opacity of `0.90` (derived from theme background), clear `#zen-browser-background::before` and `::after`, and ensure `#appcontent` and `.browserSidebarContainer` stay 100% solid/opaque.
   - Run the hook to apply the current theme immediately.

5. **Scrolling Workspace Layout & Column Resizing:**
   - In `~/.config/hypr/looknfeel.lua`, configure the scrolling layout so each window defaults to 1 full screen width (`0.97` width with subtle peek margin) and define preconfigured widths:
     ```lua
     hl.config({
       general = {
         layout = "scrolling",
       },
       scrolling = {
         column_width = 0.97,
         explicit_column_widths = "0.5, 0.75, 0.97",
       },
     })
     ```
   - In `~/.config/hypr/bindings.lua`, rebind `Super + Alt + F` to set column full width via `layoutmsg` so focus navigation remains unlocked, and add native column resize shortcuts that work reliably across all columns (including the rightmost):
     ```lua
     o.rebind("SUPER + ALT + F", "Full width column", hl.dsp.layout("colresize 0.97"))
     o.rebind("SUPER + code:21", "Expand column width", hl.dsp.layout("colresize +conf"))
     o.rebind("SUPER + code:20", "Shrink column width", hl.dsp.layout("colresize -conf"))
     o.bind("SUPER + equal", "Expand column width", hl.dsp.layout("colresize +conf"))
     o.bind("SUPER + minus", "Shrink column width", hl.dsp.layout("colresize -conf"))
     o.rebind("SUPER + ALT + code:21", "Set column full width (0.97)", hl.dsp.layout("colresize 0.97"))
     o.rebind("SUPER + ALT + code:20", "Set column half width (0.5)", hl.dsp.layout("colresize 0.5"))
     o.bind("SUPER + ALT + equal", "Set column full width (0.97)", hl.dsp.layout("colresize 0.97"))
     o.bind("SUPER + ALT + minus", "Set column half width (0.5)", hl.dsp.layout("colresize 0.5"))
     ```

6. **Idle & Display Off Behavior (`~/.config/omarchy/shell.json`):**
   - Disable screensaver and turn display off after 2 minutes of idle:
     ```json
     "idle": {
       "lock": 120,
       "screensaver": 0
     }
     ```

7. **Monitor Navigation Keybindings (`~/.config/hypr/bindings.lua`):**
   - Rebind `Super + Ctrl + Left/Right` (and `Up/Down`) to move focus across monitors:
     ```lua
     o.rebind("SUPER + CTRL + LEFT", "Focus on left monitor", hl.dsp.focus({ monitor = "l" }))
     o.rebind("SUPER + CTRL + RIGHT", "Focus on right monitor", hl.dsp.focus({ monitor = "r" }))
     o.bind("SUPER + CTRL + UP", "Focus on above monitor", hl.dsp.focus({ monitor = "u" }))
     o.bind("SUPER + CTRL + DOWN", "Focus on below monitor", hl.dsp.focus({ monitor = "d" }))
     ```

8. **Rclone Google Drive Bisync (`~/.config/systemd/user/rclone-bisync.{service,timer}`):**
   - The systemd user units are stowed from dotfiles (syncing `~/GoogleDrive/sync` ↔ `gdrive:sync` every 3 minutes).
   - On a new device:
     1. Configure the `gdrive` remote: `rclone config` (do not commit `~/.config/rclone/rclone.conf`).
     2. Create the local sync directory: `mkdir -p ~/GoogleDrive/sync`
     3. Run the initial resync: `rclone bisync ~/GoogleDrive/sync gdrive:sync --resync`
     4. Enable and start the timer:
        ```bash
        systemctl --user daemon-reload
        systemctl --user enable --now rclone-bisync.timer
        ```
