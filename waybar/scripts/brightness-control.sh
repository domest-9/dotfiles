#!/bin/bash

get_brightness() {
    current=$(brightnessctl get)
    max=$(brightnessctl max)
    echo $((current * 100 / max))
}

get_icon() {
    level=$(get_brightness)
    if [ "$level" -eq 0 ]; then
        echo "volume-level-muted"
    elif [ "$level" -lt 33 ]; then
        echo "volume-level-low"
    elif [ "$level" -lt 66 ]; then
        echo "volume-level-medium"
    else
        echo "volume-level-high"
    fi
}

send_notification() {
    brightness=$(get_brightness)
    icon=$(get_icon)
    notify-send -a "state" -r 91191 -i "$icon" -h int:value:"$brightness" "Brightness: ${brightness}%" -u low
}

case "$1" in
    i)  brightnessctl set +5% && send_notification ;;
    d)  brightnessctl set 5%- && send_notification ;;
    *)  echo "Usage: $0 [i|d]" && exit 1 ;;
esac
    i)  brightnessctl set +5% && notify ;;
    d)  brightnessctl set 5%- && notify ;;
    *)  echo "Usage: $0 [i|d]" && exit 1 ;;
esac
    # Increase brightness
    brightnessctl set +5%
    level=$(brightnessctl g)
    send_notification
    ;;
  d)
    # Decrease brightness
    brightnessctl set 5%-
    level=$(brightnessctl g)
    send_notification
    ;;
  *)
    print_error
    ;;
esac
action_volume() {
  case "${1}" in
  i)
    # Increase volume if below 100
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
    if [ "$current_vol" -lt 100 ]; then
      new_vol=$((current_vol + 2))
      [ "$new_vol" -gt 100 ] && new_vol=100
      pactl set-sink-volume @DEFAULT_SINK@ "${new_vol}%"
    fi
    ;;
  d)
    # Decrease volume if above 0
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
    new_vol=$((current_vol - 2))
    [ "$new_vol" -lt 0 ] && new_vol=0
    pactl set-sink-volume @DEFAULT_SINK@ "${new_vol}%"
    ;;
  esac
}

select_output() {
  if [ "$@" ]; then
    desc="$*"
    device=$(pactl list sinks | grep -C2 -F "Description: $desc" | grep Name | cut -d: -f2 | xargs)
    if pactl set-default-sink "$device"; then
      notify-send -r 91190 "Activated: $desc"
    else
      notify-send -r 91190 "Error activating $desc"
    fi
  else
    pactl list sinks | grep -ie "Description:" | awk -F ': ' '{print $2}' | sort
  fi
}

# Evaluate device option
while getopts iops: DeviceOpt; do
  case "${DeviceOpt}" in
  i)
    nsink=$(pactl list sources short | awk '{print $2}')
    [ -z "${nsink}" ] && echo "ERROR: Input device not found..." && exit 0
    srce="--default-source"
    ;;
  o)
    nsink=$(pactl list sinks short | awk '{print $2}')
    [ -z "${nsink}" ] && echo "ERROR: Output device not found..." && exit 0
    srce=""
    ;;
  p)
    nsink=$(playerctl --list-all | grep -w "${OPTARG}")
    [ -z "${nsink}" ] && echo "ERROR: Player ${OPTARG} not active..." && exit 0
    # shellcheck disable=SC2034
    srce="${nsink}"
    ;;
  s)
    # Select an output device
    select_output "$@"
    exit
    ;;
  *) print_error ;;
  esac
done

# Set default variables
shift $((OPTIND - 1))

# Execute action
case "${1}" in
i) action_volume i ;;
d) action_volume d ;;
m) pactl set-sink-mute @DEFAULT_SINK@ toggle && notify_mute && exit 0 ;;
*) print_error ;;
esac

send_notification
