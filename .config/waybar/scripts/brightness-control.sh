#!/usr/bin/env bash

# Usage: brightness-control.sh -o i  # increase
#        brightness-control.sh -o d  # decrease

print_error() {
  cat <<"EOF"
Usage: ./brightness-control.sh -o [i|d]
  i -- increase brightness (+5%)
  d -- decrease brightness (-5%)
EOF
  exit 1
}

while getopts o: opt; do
  case "${opt}" in
    o)
      case $OPTARG in
        i)
          brightnessctl set +5%
          ;;
        d)
          brightnessctl set 5%-
          ;;
        *)
          print_error
          ;;
      esac
      ;;
    *)
      print_error
      ;;
  esac
done
