#!/bin/bash
set -e

# Configuración
AGH_DIR="/opt/AdGuardHome"
BINARY="$AGH_DIR/AdGuardHome"
SERVICE="AdGuardHome"
BACKUP_SCRIPT="./backup.sh"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔄 Actualizador de AdGuard Home${NC}"

# Verificar root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Por favor ejecutá como root.${NC}"
    exit 1
fi

# 1. Obtener versión local
if [ -f "$BINARY" ]; then
    CURRENT_VER=$($BINARY --version | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+")
    echo -e "Versión actual instalada: ${YELLOW}$CURRENT_VER${NC}"
else
    echo -e "${RED}No se encontró AdGuard Home en $BINARY${NC}"
    exit 1
fi

# 2. Obtener última versión de GitHub
echo "Buscando última versión online..."
LATEST_VER=$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VER" ]; then
    echo -e "${RED}Error al obtener la versión desde GitHub.${NC}"
    exit 1
fi

echo -e "Última versión disponible: ${GREEN}$LATEST_VER${NC}"

# 3. Comparar
if [ "$CURRENT_VER" == "$LATEST_VER" ]; then
    echo -e "${GREEN}Ya tenés la última versión instalada. ¡Todo joya!${NC}"
    exit 0
fi

echo -e "\nHay una actualización disponible."
read -p "¿Querés actualizar ahora? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado por el usuario."
    exit 0
fi

# 4. Backup automático
echo -e "\n${YELLOW}Realizando backup preventivo...${NC}"
if [ -f "$BACKUP_SCRIPT" ]; then
    bash "$BACKUP_SCRIPT" || { echo -e "${RED}El backup falló. Abortando update para seguridad.${NC}"; exit 1; }
else
    echo -e "${YELLOW}Advertencia: Script de backup no encontrado. Copiando carpeta manualmente a /tmp/agh_backup${NC}"
    cp -r "$AGH_DIR" "/tmp/agh_backup"
fi

# 5. Descargar y Actualizar
echo -e "Descargando actualización..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Detectar arquitectura para descarga correcta (simplificado para amd64/arm64)
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    FILE="AdGuardHome_linux_amd64.tar.gz"
elif [ "$ARCH" = "aarch64" ]; then
    FILE="AdGuardHome_linux_arm64.tar.gz"
elif [ "$ARCH" = "armv7l" ]; then
    FILE="AdGuardHome_linux_armv7.tar.gz"
else
    echo -e "${RED}Arquitectura $ARCH no soportada automáticamente por este script.${NC}"
    exit 1
fi

wget -q --show-progress "https://github.com/AdguardTeam/AdGuardHome/releases/download/${LATEST_VER}/${FILE}"

echo "Descomprimiendo..."
tar -xzf "$FILE"

echo "Deteniendo servicio..."
systemctl stop "$SERVICE"

echo "Reemplazando binario..."
cp AdGuardHome/AdGuardHome "$BINARY"
chmod +x "$BINARY"

echo "Reiniciando servicio..."
systemctl start "$SERVICE"

# 6. Verificación
sleep 2
if systemctl is-active --quiet "$SERVICE"; then
    echo -e "${GREEN}✅ Actualización completada a $LATEST_VER${NC}"
    rm -rf "$TEMP_DIR"
else
    echo -e "${RED}❌ El servicio falló al arrancar tras la actualización.${NC}"
    echo "Iniciando Rollback..."
    # Lógica simple de rollback
    if [ -d "/tmp/agh_backup" ]; then
        cp -r "/tmp/agh_backup/AdGuardHome" "$BINARY"
        systemctl start "$SERVICE"
        echo "Rollback completado. Versión restaurada."
    else
        echo "Por favor restaurá el backup manualmente desde el archivo .tar.gz creado."
    fi
    exit 1
fi
