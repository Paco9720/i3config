#!/bin/bash

# ===================================================================================
# Script para instalar y configurar i3wm en Fedora 42 (Versión con Rofi y Nitrogen)
#
# Incluye:
#   - i3wm (el gestor de ventanas)
#   - i3status (para la barra de estado)
#   - rofi (lanzador de aplicaciones mejorado)
#   - picom (compositor para transparencias y efectos)
#   - nitrogen (para gestionar fondos de pantalla)
#   - alacritty (un terminal moderno y rápido)
#
# Personalización:
#   - Elimina los bordes de las ventanas.
# ===================================================================================

echo "### Iniciando la instalación de i3wm y dependencias (con Rofi y Nitrogen) ###"

# --- 1. INSTALACIÓN DE PAQUETES ---
# Se utiliza dnf, el gestor de paquetes de Fedora. El flag -y confirma automáticamente.
echo ">-> Instalando paquetes necesarios (i3, i3status, rofi, picom, nitrogen, alacritty)..."
sudo dnf install -y i3 i3status rofi picom nitrogen alacritty

# Comprobar si la instalación fue exitosa
if [ $? -ne 0 ]; then
    echo "!!! Error: La instalación de paquetes falló. Abortando el script."
    exit 1
fi

echo ">>-> ¡Paquetes instalados correctamente!"
echo ""


# --- 2. CONFIGURACIÓN DE I3WM ---
echo ">>-> Configurando i3 para eliminar los bordes de las ventanas..."

# Rutas de los archivos de configuración
I3_CONFIG_DIR="$HOME/.config/i3"
I3_CONFIG_FILE="$I3_CONFIG_DIR/config"

# Crear el directorio de configuración de i3 si no existe
mkdir -p "$I3_CONFIG_DIR"

# Copiar la configuración por defecto de i3 si el usuario no tiene una
if [ ! -f "$I3_CONFIG_FILE" ]; then
    echo ">>-> No se encontró configuración previa. Creando una a partir de la plantilla por defecto..."
    cp /etc/i3/config "$I3_CONFIG_FILE"
fi

# Añadir la regla para eliminar los bordes al final del archivo de configuración.
# Se comprueba primero si la regla ya existe para no añadirla múltiples veces.
BORDER_RULE="for_window [class=\"^.*\"] border pixel 0"

if grep -qF -- "$BORDER_RULE" "$I3_CONFIG_FILE"; then
    echo ">>-> La regla para eliminar los bordes ya existe en tu configuración. No se necesita hacer nada."
else
    echo ">>-> Añadiendo la regla para eliminar bordes al archivo de configuración..."
    echo "" >> "$I3_CONFIG_FILE"
    echo "# --- Personalización: Eliminar bordes de todas las ventanas --- " >> "$I3_CONFIG_FILE"
    echo "$BORDER_RULE" >> "$I3_CONFIG_FILE"
    echo ">>-> Regla añadida con éxito."
fi

echo ""
echo "### ¡Instalación y configuración completadas! ###"
echo ""
echo "--------------------------------------------------------------------------------"
echo "NOTA IMPORTANTE: Para usar 'rofi' como lanzador de aplicaciones:"
echo "1. Abre tu archivo de configuración de i3: $I3_CONFIG_FILE"
echo "2. Busca la línea que contiene 'dmenu_run' (normalmente 'bindsym $mod+d exec dmenu_run')."
echo "3. Reemplázala por esta línea: bindsym $mod+d exec \"rofi -show drun\""
echo "4. Guarda el archivo y recarga la configuración de i3 con: $mod+Shift+r"
echo "--------------------------------------------------------------------------------"
echo ""
echo "Para usar i3wm, por favor, cierra tu sesión actual."
echo "En la pantalla de inicio de sesión, busca un icono (normalmente una rueda dentada) y selecciona 'i3' antes de introducir tu contraseña."
