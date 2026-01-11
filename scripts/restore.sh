#!/bin/bash
set -e

# Resturador de Backup para AdGuard Home
# Uso: sudo ./restore.sh [archivo_backup.tar.gz]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔄 Restaurador de AdGuard Home${NC}"

# 1. Verificar root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Este script debe correrse como root (sudo).${NC}"
    exit 1
fi

# 2. Obtener archivo de backup
BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
    echo -e "${YELLOW}No especificaste archivo. Buscando el más reciente en ~/adguard-backups/...${NC}"
    BACKUP_FILE=$(ls -t "$HOME/adguard-backups"/adguard_backup_*.tar.gz 2>/dev/null | head -n1)
    
    if [ -z "$BACKUP_FILE" ]; then
        echo -e "${RED}No se encontraron backups automáticos.${NC}"
        echo "Uso manual: sudo ./restore.sh /ruta/al/archivo.tar.gz"
        exit 1
    fi
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}El archivo $BACKUP_FILE no existe.${NC}"
    exit 1
fi

echo -e "Archivo seleccionado: ${YELLOW}$BACKUP_FILE${NC}"
read -p "¿Estás seguro de que querés restaurar este backup? Se sobreescribirá la config actual. (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    exit 0
fi

# 3. Detener servicio
echo "Deteniendo AdGuardHome..."
systemctl stop AdGuardHome || echo -e "${YELLOW}El servicio no estaba corriendo o falló al parar.${NC}"

# 4. Restaurar
echo "Restaurando archivos en /opt/AdGuardHome/..."
# Asumimos que el tar se creó relativo a /opt o tiene la estructura correcta
# El script backup.sh generaba el tar con -C /opt "AdGuardHome"
# Así que al descomprimir en /opt debería quedar bien.

tar -xzf "$BACKUP_FILE" -C /opt

# 5. Fix permisos (importante)
echo "Ajustando permisos..."
# Ajustar esto si usás un usuario específico, por defecto instalación manual suele ser root,
# pero si se usó el instalador oficial, es root.
chown -R root:root /opt/AdGuardHome
chmod -R 755 /opt/AdGuardHome

# 6. Reiniciar servicio
echo "Iniciando servicio..."
systemctl start AdGuardHome

if systemctl is-active --quiet AdGuardHome; then
    echo -e "${GREEN}✅ Restauración completada con éxito!${NC}"
else
    echo -e "${RED}❌ El servicio falló al arrancar. Revisá logs: journalctl -u AdGuardHome -f${NC}"
    exit 1
fi
