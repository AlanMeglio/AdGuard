#!/bin/bash
set -e

# Desinstalador de AdGuard Home
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}⚠️  ADVERTENCIA DE DESINSTALACIÓN ⚠️${NC}"
echo "Esto eliminará AdGuard Home y toda su configuración."
echo -e "Si AdGuard es tu único DNS, podrías perder acceso a internet hasta que reconfigures tu router/PC."
echo

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Necesitás permisos de root (sudo).${NC}"
    exit 1
fi

read -p "¿Estás 100% seguro que querés continuar? (escribí 'si' para confirmar): " CONFIRM
if [ "$CONFIRM" != "si" ]; then
    echo "Cancelado."
    exit 0
fi

echo -e "\n${YELLOW}[1/4] Deteniendo servicio...${NC}"
systemctl stop AdGuardHome || echo "Ya estaba detenido."

echo -e "${YELLOW}[2/4] Desinstalando servicio...${NC}"
/opt/AdGuardHome/AdGuardHome -s uninstall || echo "Fallo al desinstalar servicio integrado."
# Doble check systemd
if [ -f /etc/systemd/system/AdGuardHome.service ]; then
    rm /etc/systemd/system/AdGuardHome.service
    systemctl daemon-reload
fi

echo -e "${YELLOW}[3/4] Eliminando archivos...${NC}"
rm -rf /opt/AdGuardHome
echo "Directorio /opt/AdGuardHome eliminado."

echo -e "${YELLOW}[4/4] Limpiando...${NC}"
# Opcional: Remover reglas firewall?
read -p "¿Querés eliminar también las reglas de firewall (puertos 53, 3000, 80)? (s/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    ufw delete allow 53/tcp >/dev/null 2>&1
    ufw delete allow 53/udp >/dev/null 2>&1
    ufw delete allow 3000/tcp >/dev/null 2>&1
    ufw delete allow 80/tcp >/dev/null 2>&1
    echo "Reglas de firewall eliminadas."
fi

echo -e "\n${GREEN}✅ AdGuard Home ha sido desinstalado.${NC}"
echo "Acordate de cambiar los DNS de tu router o PC a 8.8.8.8 (Google) o 1.1.1.1 (Cloudflare) para recuperar internet."
