#!/bin/sh

rm -rf ~/.config/waybar/.theme.css
rm -rf ~/.config/wofi/.theme.css
rm -rf ~/.config/alacritty/.theme.toml
rm -rf ~/.config/foot/.theme.ini

ln -s ~/.config/foot/dark.ini ~/.config/foot/.theme.ini
ln -s ~/.config/waybar/dark.css ~/.config/waybar/.theme.css
ln -s ~/.config/wofi/dark.css ~/.config/wofi/.theme.css

pkill -SIGUSR1 foot
