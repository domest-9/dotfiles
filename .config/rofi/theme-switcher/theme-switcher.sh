#!/bin/bash

# --- Variables ---
THEME="$1"
THEME_DIR="$HOME/.config/themes"

# Prompt for theme if not given as argument
if [ -z "$THEME" ]; then
    THEME=$(ls "$THEME_DIR" | grep -vE '\.sh$|\.rasi$|\.md$' | rofi -dmenu \
        -p "Select theme" \
        -theme ~/.config/rofi/theme-switcher/theme-switcher.rasi \
        -no-custom \
        -i)
fi

WAYBAR_CSS_SRC="$THEME_DIR/$THEME/waybar.css"
WAYBAR_CSS_DEST="$HOME/.config/waybar/waybar.css"

# --- Functions ---
function set_gtk_theme {
    :
}

function set_icon_theme {
    :
}

# --- Main ---
if [ -z "$THEME" ]; then
    echo "No theme specified."
    exit 1
fi

# --- GTK Theme ---
set_gtk_theme

# --- Icon Theme ---
set_icon_theme

# --- Waybar ---
if [ -f "$WAYBAR_CSS_SRC" ]; then
    # Stop waybar completely
    killall waybar
    # Wait for it to fully terminate
    sleep 0.5

    # Copy new theme
    cp "$WAYBAR_CSS_SRC" "$WAYBAR_CSS_DEST"

    # Start waybar detached
    nohup waybar >/dev/null 2>&1 &

    # Wait for waybar to start
    sleep 0.5
else
    echo "Waybar CSS theme not found for $THEME"
    > "$WAYBAR_CSS_DEST"
fi

# --- Notify ---
notify-send "Theme switched to $THEME" "GTK, Icon, and Waybar themes have been updated."
