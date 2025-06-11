#!/usr/bin/env bash

# Este script usa iwctl para mostrar info básica de la red Wi-Fi actual

# Verificamos si iwctl está instalado
if ! command -v iwctl &>/dev/null; then
  echo '{"text": "󰤫", "tooltip": "iwctl no está instalado"}'
  exit 1
fi

# Obtenemos el nombre de la interfaz Wi-Fi conectada
interface=$(iwctl station list | awk '/Connected/ {print $2}')
if [ -z "$interface" ]; then
  echo '{"text": "󰤮 ", "tooltip": "Wi-Fi apagado o no conectado"}'
  exit 0
fi

# Obtenemos los detalles de la conexión
info=$(iwctl station "$interface" show)

ssid=$(echo "$info" | awk -F ': ' '/Connected network/ {print $2}')
signal=$(echo "$info" | awk -F ': ' '/Signal/ {print $2}')
channel=$(echo "$info" | awk -F ': ' '/Channel/ {print $2}')
ip=$(ip a show "$interface" | awk '/inet / {print $2}' | cut -d/ -f1)

# Elegimos icono según la señal
icon="󰤯" # Por defecto: no señal
if [ "$signal" -ge 80 ]; then
  icon="󰤨"
elif [ "$signal" -ge 60 ]; then
  icon="󰤥"
elif [ "$signal" -ge 40 ]; then
  icon="󰤢"
elif [ "$signal" -ge 20 ]; then icon="󰤟"; fi

tooltip=":: ${ssid}\nip address: ${ip}\nsignal: ${signal}\nchannel: ${channel}"

echo "{\"text\": \"${icon}\", \"tooltip\": \"${tooltip}\"}"
