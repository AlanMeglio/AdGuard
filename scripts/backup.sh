#!/bin/bash
set -e

# Configuración
BACKUP_DIR="$HOME/adguard-backups"
ADGUARD_DIR="/opt/AdGuardHome"
SERVICE_NAME="AdGuardHome"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/adguard_backup_$TIMESTAMP.tar.gz"
RETENTION_DAYS=7

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función log
log() {
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

echo -e "${GREEN}📦 Iniciando Backup de AdGuard Home...${NC}"

# 1. Crear directorio si no existe
if [ ! -d "$BACKUP_DIR" ]; then
    log "Creando directorio de backups en $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# 2. Detener servicio
log "Deteniendo servicio $SERVICE_NAME..."
if systemctl is-active --quiet $SERVICE_NAME; then
    sudo systemctl stop $SERVICE_NAME || { echo -e "${RED}Error al detener el servicio${NC}"; exit 1; }
    SERVICE_WAS_RUNNING=true
else
    log "El servicio ya estaba detenido."
    SERVICE_WAS_RUNNING=false
fi

# 3. Crear Backup
log "Comprimiendo archivos desde $ADGUARD_DIR..."
# Usamos sudo porque /opt suele requerir root
if sudo tar -czf "$BACKUP_FILE" -C "/opt" "AdGuardHome"; then
    echo -e "${GREEN}Backup creado: $BACKUP_FILE${NC}"
else
    echo -e "${RED}Error al crear el archivo tar${NC}"
    # Intentar reiniciar servicio antes de salir
    if [ "$SERVICE_WAS_RUNNING" = true ]; then
        sudo systemctl start $SERVICE_NAME
    fi
    exit 1
fi

# 4. Reiniciar servicio
if [ "$SERVICE_WAS_RUNNING" = true ]; then
    log "Reiniciando servicio $SERVICE_NAME..."
    sudo systemctl start $SERVICE_NAME
fi

# 5. Verificar integridad
log "Verificando integridad del archivo..."
if tar -tzf "$BACKUP_FILE" > /dev/null; then
    echo -e "${GREEN}✅ Verificación de integridad exitosa.${NC}"
else
    echo -e "${RED}❌ El archivo de backup parece estar corrupto.${NC}"
    exit 1
fi

# 6. Limpiar backups viejos
log "Limpiando backups antiguos (manteniendo últimos $RETENTION_DAYS)..."
ls -t "$BACKUP_DIR"/adguard_backup_*.tar.gz | tail -n +$((RETENTION_DAYS + 1)) | xargs -r rm --
# Nota: xargs -r evita error si no hay archivos para borrar

# Información final
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo -e "\n${GREEN}Backup completado exitosamente!${NC}"
echo -e "📁 Ubicación: $BACKUP_FILE"
echo -e "💾 Tamaño: $SIZE"

# Tip para remote copy
# echo "Tip: Podés copiar este backup a otra PC con: scp $BACKUP_FILE user@remote:/path"
