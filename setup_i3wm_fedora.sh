#!/bin/bash

# Script para configurar i3wm en Fedora

echo "Iniciando la configuración de i3wm en Fedora..."

# 1. Instalar paquetes necesarios
echo "Instalando paquetes: i3, py3status, picom, dunst, fastfetch, htop, rofi, feh, i3lock, arandr, xclip, pavucontrol..."
sudo dnf install -y i3 py3status picom dunst fastfetch htop rofi feh i3lock arandr xclip pavucontrol || { echo "Error al instalar paquetes. Saliendo."; exit 1; }
echo "Paquetes instalados correctamente."

# 2. Crear directorios de configuración si no existen
mkdir -p ~/.config/i3
mkdir -p ~/.config/py3status

# 3. Hacer copia de seguridad de las configuraciones existentes
echo "Realizando copias de seguridad de las configuraciones existentes..."
if [ -f ~/.config/i3/config ]; then
    cp ~/.config/i3/config ~/.config/i3/config.bak_$(date +%Y%m%d_%H%M%S)
    echo "Copia de seguridad de ~/.config/i3/config creada."
fi
if [ -f ~/.config/py3status/config ]; then
    cp ~/.config/py3status/config ~/.config/py3status/config.bak_$(date +%Y%m%d_%H%M%S)
    echo "Copia de seguridad de ~/.config/py3status/config creada."
fi

# 4. Configurar i3wm
echo "Configurando i3wm..."
I3_CONFIG_FILE=~/.config/i3/config

# Si no existe un archivo de configuración de i3, copiar el predeterminado
if [ ! -f "$I3_CONFIG_FILE" ]; then
    echo "No se encontró un archivo de configuración de i3. Copiando el predeterminado..."
    cp /etc/i3/config "$I3_CONFIG_FILE" || { echo "Error al copiar la configuración predeterminada de i3. Saliendo."; exit 1; }
fi

# Quitar bordes de las ventanas
if ! grep -q "for_window [class=\".*\"] border pixel 0" "$I3_CONFIG_FILE"; then
    echo "Añadiendo configuración para quitar bordes de ventanas..."
    echo "" >> "$I3_CONFIG_FILE"
    echo "# Quitar bordes de todas las ventanas" >> "$I3_CONFIG_FILE"
    echo "for_window [class=\".*\"] border pixel 0" >> "$I3_CONFIG_FILE"
else
    echo "La configuración para quitar bordes ya existe."
fi

# Cambiar dmenu por rofi
if grep -q "bindsym $mod+d exec dmenu_run" "$I3_CONFIG_FILE"; then
    echo "Cambiando dmenu por rofi en la configuración de i3..."
    sed -i 's/bindsym $mod+d exec dmenu_run/bindsym $mod+d exec rofi -show drun/g' "$I3_CONFIG_FILE"
else
    echo "La configuración de dmenu no se encontró o ya ha sido modificada."
fi

# Configurar py3status como la barra de estado
if grep -q "status_command i3status" "$I3_CONFIG_FILE"; then
    echo "Configurando py3status como la barra de estado..."
    sed -i 's/status_command i3status/status_command py3status/g' "$I3_CONFIG_FILE"
else
    echo "La configuración de i3status no se encontró o ya ha sido modificada para py3status."
fi
echo "Configuración de i3wm completada."

# 5. Configurar py3status
echo "Configurando py3status..."
PY3STATUS_CONFIG_FILE=~/.config/py3status/config

cat << EOF > "$PY3STATUS_CONFIG_FILE"
# ~/.config/py3status/config
# Generado por Gemini CLI agent

general {
    output_format = i3bar
    colors = true
    position = top
}

order += i3bar_workspace
order += time

time {
    format = %H:%M:%S
    format_time = %H:%M:%S
    format_date = %Y-%m-%d
}

# Ocultar el gestor de redes (asegurarse de que no haya módulos de red en el orden)
# Si necesitas un módulo de red en el futuro, puedes añadirlo aquí.
# Por ejemplo, para ver la IP:
# order += network
# network {
#     format_up = "🌐 {ip}"
#     format_down = "🌐 offline"
# }
EOF
echo "Configuración de py3status completada."

echo "Script de configuración de i3wm finalizado."
echo "Por favor, reinicia i3wm (Mod+Shift+R) o cierra y vuelve a iniciar sesión para aplicar los cambios."
