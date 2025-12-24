#!/bin/sh

rm -rf ~/.config/waybar/.theme.css
rm -rf ~/.config/wofi/.theme.css
rm -rf ~/.config/alacritty/.theme.toml

ln -s ~/.config/alacritty/dark.toml ~/.config/alacritty/.theme.toml
ln -s ~/.config/waybar/dark.css ~/.config/waybar/.theme.css
ln -s ~/.config/wofi/dark.css ~/.config/wofi/.theme.css
