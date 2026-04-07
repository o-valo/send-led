#!/bin/bash

# --- Schnelle Alternative (Einzeiler) ---
# sudo pacman -S --needed python bluez bluez-utils && python -m venv led_env && ./led_env/bin/pip install pypixelcolor

# Installations-Skript fuer led-send.sh (Angepasst für CachyOS)
echo "--- Starte Installation von led-send ---"

# 1. System-Abhaengigkeiten installieren (CachyOS/Arch-Pakete)
echo "Pruefe System-Pakete..."
sudo pacman -Sy --needed python python-pip bluez bluez-utils

# Bluetooth-Dienst starten (Notwendig unter Arch/Cachy)
sudo systemctl enable --now bluetooth

# 2. Virtuelle Umgebung einrichten
VENV_NAME="led_env"
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Erstelle venv in $INSTALL_DIR/$VENV_NAME..."
python3 -m venv "$INSTALL_DIR/$VENV_NAME"
source "$INSTALL_DIR/$VENV_NAME/bin/activate"

# 3. pypixelcolor installieren
echo "Installiere pypixelcolor..."
pip install --upgrade pip
pip install pypixelcolor

# 4. Bluetooth-Scan (Optional zur Ermittlung der MAC)
echo ""
read -p "Moechtest du nach der MAC-Adresse deiner Matrix scannen? (y/n): " do_scan
if [[ "$do_scan" == "y" ]]; then
    echo "Suche nach Bluetooth-Geraeten..."
    hcitool scan
    echo ""
    echo "Bitte die gefundene MAC-Adresse manuell in led-send.sh eintragen."
fi

# 5. Ausfuehrungsrechte setzen
chmod +x "$INSTALL_DIR/led-send.sh"

echo "-------------------------------------------------------"
echo "Installation abgeschlossen!"
echo "-------------------------------------------------------"

#EOF
