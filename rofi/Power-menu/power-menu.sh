#!/usr/bin/env bash

actions=$(echo -e "  Lock\n  Shutdown\n  Reboot\n  Suspend\n  Hibernate\n󰞘  Logout")

# Display logout menu
selected_option=$(echo -e "$actions" | rofi -dmenu \
    -i \
    -p "Power Menu" \
    -theme ~/.config/rofi/Power-menu/power.rasi)

# Perform actions based on the selected option
case "$selected_option" in
*Lock)
  loginctl lock-session
  ;;
*Shutdown)
  systemctl poweroff
  ;;
*Reboot)
  systemctl reboot
  ;;
*Suspend)
  systemctl suspend
  ;;
*Hibernate)
  systemctl hibernate
  ;;
*Logout)
  loginctl kill-session "$XDG_SESSION_ID"
  ;;
esac
