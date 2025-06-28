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

# Paths for theme assets
WAYBAR_CSS_SRC="$THEME_DIR/$THEME/waybar.css"
WAYBAR_CSS_DEST="$HOME/.config/waybar/waybar.css"
ROFI_COLORS_SRC="$THEME_DIR/$THEME/colors.rasi"
ROFI_COLORS_DEST="$HOME/.config/rofi/colors.rasi"
KITTY_COLORS_SRC="$THEME_DIR/$THEME/kitty-colors.conf"
KITTY_COLORS_DEST="$HOME/.config/kitty/colors.conf"

# --- Functions ---
function set_gtk_theme {
    # Placeholder: implement GTK theme switching if desired
    :
}

function set_icon_theme {
    # Placeholder: implement icon theme switching if desired
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

# --- Ensure Rofi directory exists ---
mkdir -p "$HOME/.config/rofi"

# --- Waybar ---
if [ -f "$WAYBAR_CSS_SRC" ]; then
    killall waybar 2>/dev/null || true
    sleep 0.5
    cp "$WAYBAR_CSS_SRC" "$WAYBAR_CSS_DEST"
    nohup waybar >/dev/null 2>&1 &
    sleep 0.5
else
    echo "Waybar CSS theme not found for $THEME"
    > "$WAYBAR_CSS_DEST"
fi

# --- Rofi Colors ---
if [ -f "$ROFI_COLORS_SRC" ]; then
    cp "$ROFI_COLORS_SRC" "$ROFI_COLORS_DEST"
    echo "Updated Rofi colors: $ROFI_COLORS_DEST"
else
    echo "Rofi colors.rasi not found for $THEME"
    > "$ROFI_COLORS_DEST"
fi

# --- Kitty Colors ---
if [ -f "$KITTY_COLORS_SRC" ]; then
    mkdir -p "$(dirname "$KITTY_COLORS_DEST")"
    cp "$KITTY_COLORS_SRC" "$KITTY_COLORS_DEST"
    # Reload kitty colors if kitty is running
    if pgrep -x kitty >/dev/null; then
        killall -SIGUSR1 kitty
    fi
    echo "Updated Kitty colors: $KITTY_COLORS_DEST"
else
    echo "Kitty colors not found for $THEME"
fi

# --- Notify ---
notify-send "Theme switched to $THEME" "GTK, Icon, Waybar, Rofi and Kitty colors have been updated."
