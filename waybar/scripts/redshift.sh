#!/bin/bash

# Fil for å lagre gammastep-tilstand
STATE_FILE="$HOME/.config/waybar/scripts/gammastep_state"

# Hvis filen ikke eksisterer, lag den
if [ ! -f "$STATE_FILE" ]; then
    echo "off" > "$STATE_FILE"
fi

# Les tilstanden fra filen
STATE=$(cat "$STATE_FILE")

# Hvis gammastep er "av", sett til 3500K
if [ "$STATE" == "off" ]; then
    gammastep -O 3500
    echo "on" > "$STATE_FILE"  # Sett tilstanden til "på"
else
    # Hvis gammastep er "på", tilbakestill til 6500K
    gammastep -x
    echo "off" > "$STATE_FILE"  # Sett tilstanden til "av"
fi

