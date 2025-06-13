#!/bin/bash

# Waybar WiFi Status Module Script
# This script outputs JSON for waybar custom module

# Get WiFi interface (usually wlan0 or wlp*)
get_wifi_interface() {
    nmcli device | grep wifi | head -1 | awk '{print $1}'
}

# Get WiFi status and connection info
get_wifi_info() {
    local interface=$(get_wifi_interface)
    
    # Check if WiFi is enabled
    if ! nmcli radio wifi | grep -q "enabled"; then
        echo '{"text": "󰤮", "tooltip": "WiFi Disabled", "class": "disabled"}'
        return
    fi
    
    # Get active connection
    local connection=$(nmcli -t -f NAME connection show --active 2>/dev/null | grep -E '^[^lo]' | head -1)
    
    if [ -z "$connection" ]; then
        echo '{"text": "󰤯", "tooltip": "Not Connected", "class": "disconnected"}'
        return
    fi
    
    # Get connection details
    local ssid=$(nmcli -t -f 802-11-wireless.ssid connection show "$connection" 2>/dev/null | cut -d: -f2)
    local signal=$(nmcli -f IN-USE,SIGNAL device wifi | grep "^\*" | awk '{print $2}' | tr -d '%')
    local security=$(nmcli -t -f 802-11-wireless-security.key-mgmt connection show "$connection" 2>/dev/null | cut -d: -f2)
    local ip=$(nmcli -t -f IP4.ADDRESS connection show "$connection" 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
    local speed=$(nmcli -f GENERAL.CONNECTION,GENERAL.SPEED device show "$interface" 2>/dev/null | grep SPEED | awk '{print $2}' | head -1)
    
    # Fallback if SSID is empty (use connection name)
    if [ -z "$ssid" ] || [ "$ssid" = "--" ]; then
        ssid="$connection"
    fi
    
    # Determine signal strength icon and class
    local icon="󰤟"
    local class="excellent"
    
    if [ -n "$signal" ] && [ "$signal" != "--" ]; then
        if [ "$signal" -ge 80 ]; then
            icon="󰤨"
            class="excellent"
        elif [ "$signal" -ge 60 ]; then
            icon="󰤥"
            class="good"
        elif [ "$signal" -ge 40 ]; then
            icon="󰤢"
            class="fair"
        elif [ "$signal" -ge 20 ]; then
            icon="󰤟"
            class="poor"
        else
            icon="󰤯"
            class="weak"
        fi
    fi
    
    # Security icon
    local sec_icon=""
    if [ -n "$security" ] && [ "$security" != "--" ] && [ "$security" != "none" ]; then
        sec_icon="󰌾"
    else
        sec_icon="󰟆"
    fi
    
    # Format display text
    local display_text="$icon"
    local alt_text="$ssid"
    
    # Create tooltip with detailed info
    local tooltip="Network: $ssid"
    [ -n "$signal" ] && [ "$signal" != "--" ] && tooltip="$tooltip\nSignal: $signal%"
    [ -n "$ip" ] && tooltip="$tooltip\nIP: $ip"
    [ -n "$speed" ] && [ "$speed" != "--" ] && tooltip="$tooltip\nSpeed: $speed Mbps"
    [ -n "$security" ] && [ "$security" != "--" ] && [ "$security" != "none" ] && tooltip="$tooltip\nSecurity: $security" || tooltip="$tooltip\nSecurity: Open"
    
    # Output JSON
    echo "{\"text\": \"$display_text\", \"alt\": \"$alt_text\", \"tooltip\": \"$tooltip\", \"class\": \"$class\", \"percentage\": ${signal:-0}}"
}

# Handle click events
handle_click() {
    case "$1" in
        "left")
            # Left click - open WiFi manager
            /path/to/wifi-manager.sh &
            ;;
        "right")
            # Right click - toggle WiFi
            if nmcli radio wifi | grep -q "enabled"; then
                nmcli radio wifi off
                notify-send "WiFi" "Disabled" -t 2000
            else
                nmcli radio wifi on
                notify-send "WiFi" "Enabled" -t 2000
            fi
            ;;
        "middle")
            # Middle click - refresh/rescan
            nmcli device wifi rescan 2>/dev/null
            notify-send "WiFi" "Rescanning networks..." -t 2000
            ;;
    esac
}

# Main execution
if [ -n "$1" ]; then
    handle_click "$1"
else
    get_wifi_info
fi
