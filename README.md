# AdGuard Home en Hardware Reciclado

![License](https://img.shields.io/github/license/AlanMeglio/AdGuard)
![GitHub stars](https://img.shields.io/github/stars/AlanMeglio/AdGuard)

Transformá esa notebook vieja en un escudo de privacidad para toda tu red.

---

## 🎯 ¿Qué es esto?

Este proyecto nace de la idea de **costo cero y reciclaje tecnológico**. En lugar de comprar hardware nuevo, reutilizamos una notebook en desuso (o una Máquina Virtual) para montar un servidor DNS local que bloquea publicidad y rastreadores en todos los dispositivos de la casa (Smart TV, celulares, consolas, PC) sin instalar software en cada uno.

### ¿Por qué hacer esto?

- **Bloqueo a nivel de red**: Elimina anuncios en apps y webs antes de que lleguen a tus dispositivos
- **Privacidad**: Tus consultas DNS no pasan por Google o tu ISP; vos tenés el control
- **Ahorro de ancho de banda**: Al no descargar la publicidad, las páginas cargan más rápido
- **Hardware Reciclado**: Dale una segunda vida a equipos antiguos (consume muy pocos recursos)

![Servidor corriendo en Ubuntu Server](https://private-user-images.githubusercontent.com/131933323/534256882-a6814d32-0c78-4112-a071-1c0e958cb29f.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjgwNzgyNDcsIm5iZiI6MTc2ODA3Nzk0NywicGF0aCI6Ii8xMzE5MzMzMjMvNTM0MjU2ODgyLWE2ODE0ZDMyLTBjNzgtNDExMi1hMDcxLTFjMGU5NThjYjI5Zi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTEwJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDExMFQyMDQ1NDdaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mN2YyNGQ0ZWM0MjdlM2Y4NjY5N2M0ZDYxMjRlYWYzZmMxY2JlNzYxZTdiOTk2MzgwYWM5ZGIxMTNmMWFmZTY5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.RPyNFpw_fyUbCIl0N6I6qUz_JLbSmSSwJEatWElXqpw)

*El servidor corriendo en Ubuntu Server con recursos mínimos.*

---

## 📖 Guías

### Primeros Pasos
- [Requisitos de Hardware](#-requisitos-de-hardware)
- [FAQ - Preguntas Frecuentes](#-faq)
- [Comparación con otras soluciones](docs/adguard-vs-pihole.md)

### Configuración
- [Instalación en Ubuntu Server](#-instalación-paso-a-paso)
- [Configuración de IP Estática](docs/ip-estatica.md)
- [Configuración del Router](#-configuración-del-router)
- [Lista de Routers Compatibles](docs/routers-compatibles.md)

### Instalación Avanzada
- [Instalación en Raspberry Pi](#-instalación-en-raspberry-pi)
- [Instalación con Docker](#-instalación-con-docker)
- [Instalación en Máquina Virtual](#-instalación-en-máquina-virtual)

### Mantenimiento
- [Backup y Restauración](#-mantenimiento)
- [Actualización de AdGuard Home](#actualizar-adguard-home)
- [Solución de Problemas](#-solución-de-problemas)

---

## 📋 Requisitos de Hardware

Este proyecto es muy liviano, ideal para equipos antiguos:

| Componente | Mínimo | Recomendado |
|------------|--------|-------------|
| **CPU** | Cualquier procesador 64-bit o ARM | Dual-core 1GHz+ |
| **RAM** | 512MB | 1GB |
| **Almacenamiento** | 500MB libres | 2GB libres |
| **Red** | WiFi funcional | Ethernet (RJ45) |
| **OS** | Ubuntu Server 20.04+ | Ubuntu Server 24.04 LTS |

> **💡 Tip**: La conexión por cable Ethernet reduce significativamente la latencia en las consultas DNS.

---

## 🚀 Instalación Paso a Paso

### Método 1: Instalación Rápida (Recomendado)

El script automático instala y configura todo por vos:

```bash
curl -s -S -L https://raw.githubusercontent.com/AlanMeglio/AdGuard/main/scripts/install.sh | sudo bash
```

**Tiempo estimado:** 5 minutos

### Método 2: Instalación Manual

<details>
<summary>Hacé click para ver los pasos manuales</summary>

#### 1. Preparación del Sistema

Asegurate de tener una **IP Estática** configurada. Seguí la [guía de configuración de IP estática](docs/ip-estatica.md).

#### 2. Configuración del Firewall

```bash
sudo ufw allow ssh
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 80/tcp
sudo ufw allow 3000/tcp
sudo ufw enable
```

**Puertos:**
- `53`: Puerto DNS (obligatorio)
- `80` o `3000`: Panel de administración web
- `22`: SSH para acceso remoto

#### 3. Instalación de AdGuard Home

```bash
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
```

![Instalación completada](https://private-user-images.githubusercontent.com/131933323/534256895-05521794-ca77-4ea7-85f0-48c67e2dfb77.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjgwNzgyNDcsIm5iZiI6MTc2ODA3Nzk0NywicGF0aCI6Ii8xMzE5MzMzMjMvNTM0MjU2ODk1LTA1NTIxNzk0LWNhNzctNGVhNy04NWYwLTQ4YzY3ZTJkZmI3Ny5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTEwJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDExMFQyMDQ1NDdaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0wMTg2NjUxYjUwMWI0MDY0MDUyM2YwOTUxMzM5ZjI2MjNmNGVjNTZiMDM2OTMwZDk1MDZkNWY2N2UzM2FiN2Q1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.XMhOtpYHs4wdvghoDX5aAsCS1P7gFJKXz5a5VI6PbkE)

*Script de instalación finalizado mostrando IP y puertos.*

#### 4. Configuración Inicial

Abrí el navegador e ingresá a: `http://[IP-DE-TU-SERVIDOR]:3000`

Seguí el asistente:
1. Puerto de administración: `3000` o `80`
2. Puerto DNS: `53` (obligatorio)
3. Creá usuario y contraseña
4. Configurá DNS upstream (Cloudflare: `1.1.1.1` y `1.0.0.1`)

![Panel de control AdGuard](https://private-user-images.githubusercontent.com/131933323/534256915-610ca5a4-6b95-4d89-9d4a-df6eaaea0d55.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjgwNzgyNDcsIm5iZiI6MTc2ODA3Nzk0NywicGF0aCI6Ii8xMzE5MzMzMjMvNTM0MjU2OTE1LTYxMGNhNWE0LTZiOTUtNGQ4OS05ZDRhLWRmNmVhYWVhMGQ1NS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTEwJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDExMFQyMDQ1NDdaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05ZjFkZTNiZDk1NmY5ODJjOWQxMzQzODNkNTYzNzhlMmIyYmZiZTljZGZjMjI3ZjNjNDA0M2YxNGZkZjA1ZTllJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.nhL8tu3mmLPFjjNjG1xPhdsVyBnd9drsGlln7wIRfks)

*Panel de control principal bloqueando rastreadores.*

</details>

---

## 🔧 Instalación en Otras Plataformas

### 🍓 Instalación en Raspberry Pi

<details>
<summary>Hacé click para ver instrucciones</summary>

AdGuard Home funciona perfectamente en Raspberry Pi (incluso en la Pi Zero):

```bash
# 1. Instalá Raspberry Pi OS Lite (sin escritorio)
# 2. Actualizá el sistema
sudo apt update && sudo apt upgrade -y

# 3. Ejecutá el script de instalación
curl -s -S -L https://raw.githubusercontent.com/AlanMeglio/AdGuard/main/scripts/install.sh | sudo bash
```

**Consumo de recursos en Pi:**
- RAM: ~80-120MB
- CPU: <5%
- Temperatura: +5°C sobre idle

</details>

### 🐳 Instalación con Docker

<details>
<summary>Hacé click para ver instrucciones</summary>

Si preferís usar Docker:

```bash
# Crear directorio para configuración
mkdir -p ~/adguard/work ~/adguard/conf

# Ejecutar contenedor
docker run -d \
  --name adguardhome \
  --restart unless-stopped \
  -v ~/adguard/work:/opt/adguardhome/work \
  -v ~/adguard/conf:/opt/adguardhome/conf \
  -p 53:53/tcp -p 53:53/udp \
  -p 3000:3000/tcp \
  adguard/adguardhome
```

Accedé al panel: `http://localhost:3000`

</details>

### 💻 Instalación en Máquina Virtual

<details>
<summary>Hacé click para ver instrucciones</summary>

Configuración recomendada para VM:

**VirtualBox / VMware:**
- 1 vCPU
- 1GB RAM
- 10GB disco
- Adaptador de red en modo Bridge

**Hyper-V:**
```powershell
New-VM -Name "AdGuard" -MemoryStartupBytes 1GB -Generation 2
Set-VMProcessor -VMName "AdGuard" -Count 1
```

Luego seguí la instalación normal de Ubuntu Server.

</details>

---

## 🌐 Configuración del Router

Para que AdGuard funcione en **toda tu red**, configurá tu router:

1. Entrá a la configuración (usualmente `192.168.0.1` o `192.168.1.1`)
2. Buscá **DHCP** o **LAN Settings**
3. **DNS Primario**: IP de tu servidor AdGuard
4. **DNS Secundario**: Misma IP o vacío

> ⚠️ **IMPORTANTE**: NO pongas DNS públicos (8.8.8.8) en el secundario.

**¿Tu router no está en la lista?** Consultá la [guía de routers compatibles](docs/routers-compatibles.md) con configuraciones específicas para ISPs argentinos.

### Verificación

Visitá https://adguard.com/en/test.html desde cualquier dispositivo. Deberías ver: **"AdGuard DNS is working"**

---

## 🔧 Configuración Avanzada

### Listas de Bloqueo Recomendadas

En el panel: **Filtros** → **Listas de filtros DNS**

```
AdGuard DNS Filter (incluido por defecto)
Peter Lowe's List: https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus
StevenBlack Hosts: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
```

### DNS Encriptado (DoH/DoT)

Configurá DNS upstream encriptado en **Configuración** → **Configuración DNS**:

```
https://1.1.1.1/dns-query (Cloudflare DoH)
https://dns.google/dns-query (Google DoH)
tls://1.1.1.1 (Cloudflare DoT)
```

---

## 🛠️ Solución de Problemas

### Veo publicidad en mi celular Android

**Causa:** DNS Privado activo.

**Solución:** 
`Ajustes` → `Conexión y compartir` → `DNS Privado` → **DESACTIVADO**

---

### Instagram o Apps se congelan

**Causa:** Falsos positivos.

**Solución:** Agregá excepciones en `Filtros` → `Reglas personalizadas`:
```
@@||graph.instagram.com^
@@||graph.facebook.com^
```

---

### Internet lento en algunos sitios

**Causa:** Conflicto IPv6.

**Solución:** 
`Configuración` → `Configuración DNS` → Activar **"Deshabilitar IPv6"**

---

### El servidor no arranca tras reiniciar

**Solución:**
```bash
sudo systemctl enable AdGuardHome
sudo systemctl start AdGuardHome
```

---

## 📊 Mantenimiento

### Actualizar AdGuard Home

**Desde el panel:** `Configuración` → `General` → `Buscar actualizaciones`

**Desde terminal:**
```bash
bash scripts/update.sh
```

### Hacer Backup

```bash
bash scripts/backup.sh
```

Backups guardados en: `~/adguard-backups/`

**Automatización (backup diario):**
```bash
crontab -e
# Agregar:
0 3 * * * /ruta/a/scripts/backup.sh
```

### Restaurar Backup

```bash
sudo systemctl stop AdGuardHome
sudo tar -xzf ~/adguard-backups/adguard_backup_FECHA.tar.gz -C /opt/AdGuardHome/
sudo systemctl start AdGuardHome
```

---

## 📈 Estadísticas de Uso Real

Después de 1 mes de uso continuo:

- **Consultas totales**: ~500,000
- **Consultas bloqueadas**: ~180,000 (36%)
- **Dominios únicos bloqueados**: ~15,000
- **Consumo de RAM**: 150-200MB
- **Uso de CPU**: <5% promedio

> Equivale a **no descargar ~2.5GB de publicidad** mensual.

---

## ❓ FAQ

<details>
<summary><strong>¿Funciona con cualquier router?</strong></summary>

Sí, siempre que permita cambiar los DNS en la configuración DHCP. El 99% de routers hogareños lo permiten.
</details>

<details>
<summary><strong>¿Puedo usar Raspberry Pi?</strong></summary>

¡Absolutamente! Es el hardware ideal. Funciona hasta en la Pi Zero.
</details>

<details>
<summary><strong>¿Afecta la velocidad?</strong></summary>

No. De hecho mejora la velocidad al bloquear anuncios. La latencia DNS es mínima (~5-15ms).
</details>

<details>
<summary><strong>¿Bloquea anuncios en YouTube?</strong></summary>

No completamente. Los anuncios de YouTube están integrados en el video, pero sí bloquea rastreadores.
</details>

<details>
<summary><strong>¿Necesito conocimientos técnicos?</strong></summary>

No. Si sabés instalar Ubuntu Server y acceder al router, podés hacer esto.
</details>

---

## 🤝 Contribuciones

¿Querés mejorar este proyecto? Lee la [guía de contribución](CONTRIBUTING.md).

### Formas de contribuir:
- 📝 Reportar bugs
- ✨ Sugerir mejoras
- 📚 Mejorar documentación
- 🌐 Agregar routers compatibles
- 💻 Enviar pull requests

---

## 📚 Recursos

- [Documentación oficial AdGuard](https://github.com/AdguardTeam/AdGuardHome/wiki)
- [Configuración de IP estática](docs/ip-estatica.md)
- [Routers compatibles](docs/routers-compatibles.md)
- [Comparación con Pi-hole](docs/adguard-vs-pihole.md)

---

## 📝 Créditos

- **Software**: [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) por AdGuard Team
- **Guía**: [Alan Meglio](https://github.com/AlanMeglio)

---

## ⚖️ Licencia

[MIT License](LICENSE) - Usá, modificá y compartí libremente.

---

## 🌟 ¿Te fue útil?

Si este proyecto te ayudó:
- ⭐ Dale una estrella al repositorio
- 🔄 Compartilo con otros
- 📺 Suscribite al [canal de YouTube](#) (link a tu canal)
- 💬 [Abrí un issue](https://github.com/AlanMeglio/AdGuard/issues) si tenés dudas

---

**Hecho con ❤️ en Argentina** 🇦🇷
