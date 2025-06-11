#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    echo "Error: rofi is not installed. Please install rofi to use this script."
    exit 1
fi

# List images and pick one with rofi
cd "$WALLPAPER_DIR" || exit 1
shopt -s nullglob
SELECTED=$(for img in *.{jpg,png,jpeg}; do
    [ -f "$img" ] && echo -en "$(basename "$img")\0icon\x1f$WALLPAPER_DIR/$img\n"
done | rofi -dmenu -p "Select Wallpaper" -show-icons -theme ~/.config/rofi/Wallpaper-switcher/wallpaper.rasi)
shopt -u nullglob

# Convert selected filename back to full path
[ -z "$SELECTED" ] && exit 0
SELECTED="$WALLPAPER_DIR/$(basename "$SELECTED")"

# Update hyprpaper.conf
echo "preload = $SELECTED" > "$HYPAPER_CONF"
echo "wallpaper = ,$SELECTED" >> "$HYPAPER_CONF"

# Always restart hyprpaper for reliable wallpaper change
if command -v hyprpaper &> /dev/null; then
    pkill hyprpaper
    hyprpaper &
fi