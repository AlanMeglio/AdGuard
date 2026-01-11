#!/bin/bash
set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función de log
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

# Banner
echo -e "${GREEN}"
echo "🛡️  Instalador de AdGuard Home en Hardware Reciclado"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"

# 1. Verificar permisos de root
if [ "$EUID" -ne 0 ]; then
  error "Por favor ejecutá este script como root (sudo ./install.sh)"
fi

# 2. Detectar Sistema Operativo
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    error "No se pudo detectar el sistema operativo."
fi

success "Sistema operativo detectado: $OS $VER"

# Validar soporte básico (Ubuntu/Debian)
if [[ "$ID" != "ubuntu" && "$ID" != "debian" && "$ID_LIKE" != "debian" ]]; then
    echo -e "${YELLOW}[WARN]${NC} Este script fue probado en Ubuntu/Debian. Podría fallar en tu sistema."
    read -p "¿Querés continuar de todas formas? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

# 3. Actualizar sistema e instalar dependencias
log "Actualizando lista de paquetes..."
apt-get update -qq || error "Fallo al actualizar repositorios"

log "Instalando dependencias necesarias (curl, tar, ufw)..."
apt-get install -y curl tar ufw -qq || error "Fallo al instalar dependencias"

# 4. Configurar Firewall (UFW)
log "Configurando Firewall (UFW)..."

# Permitir SSH para no quedarnos afuera
ufw allow ssh > /dev/null
ufw allow 22/tcp > /dev/null

# Puertos necesarios para AdGuard Home
# DNS
ufw allow 53/tcp > /dev/null
ufw allow 53/udp > /dev/null
# DHCP (si se usa)
ufw allow 67/udp > /dev/null
ufw allow 68/udp > /dev/null
# Interfaz Web (Install y Admin)
ufw allow 80/tcp > /dev/null
ufw allow 443/tcp > /dev/null
ufw allow 3000/tcp > /dev/null
# HTTPS DNS (DoH)
ufw allow 853/tcp > /dev/null

# Habilitar firewall si no está activo (opcional, pregunta al usuario o lo hace directo)
# Aquí lo habilitamos con --force para automatizar
ufw --force enable > /dev/null
success "Firewall configurado correctamente."

# 5. Descargar e Instalar AdGuard Home
log "Descargando e instalando AdGuard Home..."

# Usamos el script oficial de instalación que es robusto y setea systemd
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v || error "Fallo la instalación de AdGuard Home"

# 6. Verificaciones finales
if systemctl is-active --quiet AdGuardHome; then
    success "Servicio AdGuardHome corriendo correctamente."
else
    error "El servicio AdGuardHome no parece estar corriendo. Revisá los logs con: journalctl -u AdGuardHome"
fi

# Obtener IP local para mostrar
IP_LOCAL=$(hostname -I | awk '{print $1}')

echo -e "\n${GREEN}✅ Instalación completada con éxito!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "📋 \033[1mPróximos pasos:\033[0m"
echo -e "   1. Abrí tu navegador en la misma red."
echo -e "   2. Ingresá a: ${YELLOW}http://$IP_LOCAL:3000${NC}"
echo -e "   3. Seguí el asistente de configuración web."
echo -e "\n   Para ver el estado del servicio: ${BLUE}sudo systemctl status AdGuardHome${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
