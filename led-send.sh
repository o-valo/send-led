#!/bin/bash
# Script: led-send.sh
# Version: 1.3.0
# Beschreibung: Sendet Text an die LED-Matrix via pypixelcolor

# Name des venv-Ordners
VENV_NAME="led_env"

# 1. Virtual Environment prüfen und aktivieren
if [[ -z "$VIRTUAL_ENV" ]]; then
    if [ -d "$VENV_NAME" ]; then
        source "$VENV_NAME/bin/activate"
    else
        echo "Fehler: Virtuelle Umgebung '$VENV_NAME' nicht gefunden."
        exit 1
    fi
fi

# --- Konfiguration ---
MAC_ADRESSE="AC:B8:89:3C:67:5B"
FARBE="000000"
FONT="VCR_OSD_MONO"

# --- Input-Logik ---
# Prüfen, ob Daten über eine Pipe kommen (stdin nicht mit Terminal verbunden)
if [ ! -t 0 ]; then
    TEXT_ZU_SENDEN=$(cat -)
# Wenn keine Pipe, prüfe ob Argumente übergeben wurden
elif [ $# -gt 0 ]; then
    TEXT_ZU_SENDEN="$*"
else
    echo "Fehler: Kein Text oder Befehl übergeben."
    echo "Nutzung: 'cat datei.txt | $0' oder '$0 \"Hallo Welt\"'"
    exit 1
fi

# Bereinigung: Zeilenumbrüche für die LED-Matrix entfernen
TEXT_ZU_SENDEN=$(echo "$TEXT_ZU_SENDEN" | tr -d '\n' | tr -d '\r')

echo "Sende (v$VERSION) an $MAC_ADRESSE: '$TEXT_ZU_SENDEN'"

# Aufruf von pypixelcolor
pypixelcolor -a "$MAC_ADRESSE" -c send_text "$TEXT_ZU_SENDEN" \
    animation=1 speed=100 bg_color="$FARBE" font="$FONT"

#EOF
