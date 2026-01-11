# 🛡️ AdGuard Home en Hardware Reciclado

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/AlanMeglio/AdGuard?style=social)](https://github.com/AlanMeglio/AdGuard/stargazers)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20LTS-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![AdGuard](https://img.shields.io/badge/AdGuard-Home-66B574?logo=adguard&logoColor=white)](https://adguard.com/en/adguard-home/overview.html)

> 🔄 Transformá esa notebook vieja en un escudo de privacidad para toda tu red

![Servidor corriendo en Ubuntu Server](https://github.com/user-attachments/assets/e3881c6e-316c-4444-88f7-6c7635936041)

*El servidor corriendo en Ubuntu Server con recursos mínimos.*

---

## 📋 Tabla de Contenidos

- [¿Qué es esto?](#-qué-es-esto)
- [¿Por qué hacer esto?](#-por-qué-hacer-esto)
- [Requisitos](#-requisitos)
- [Configurar IP Estática](#-configurar-ip-estática)
- [Instalación](#-instalación)
- [Configuración del Router](#-configuración-del-router)
- [Listas de Bloqueo](#-listas-de-bloqueo-recomendadas)
- [Verificación](#-verificar-que-funciona)
- [Problemas Comunes](#-solución-de-problemas)
- [Mantenimiento](#-mantenimiento)
- [FAQ](#-preguntas-frecuentes)
- [Contribuir](#-contribuciones)

---

## 🎯 ¿Qué es esto?

Este proyecto nace de la idea de **costo cero y reciclaje tecnológico**. En lugar de comprar hardware nuevo, reutilizamos una notebook en desuso (o una Máquina Virtual) para montar un servidor DNS local que bloquea publicidad y rastreadores en todos los dispositivos de la casa: Smart TV, celulares, consolas, tablets y PCs, sin instalar software en cada uno.

---

## 💡 ¿Por qué hacer esto?

- **🚫 Bloqueo a nivel de red**: Elimina anuncios en apps y webs antes de que lleguen a tus dispositivos
- **🔒 Privacidad total**: Tus consultas DNS no pasan por Google o tu ISP; vos tenés el control
- **⚡ Ahorro de ancho de banda**: Al no descargar publicidad, las páginas cargan más rápido y gastás menos datos
- **♻️ Hardware reciclado**: Dale una segunda vida a equipos antiguos que consumen muy pocos recursos
- **💰 Costo cero**: No necesitás comprar nada nuevo, usás lo que ya tenés

---

## 📦 Requisitos

### Hardware (Opción A: Notebook/PC Reciclado)

| Componente | Mínimo | Recomendado | Notas |
|------------|--------|-------------|-------|
| **CPU** | 1 núcleo (x86_64 o ARM) | Dual-core 1GHz+ | Cualquier Intel Celeron, Pentium, i3 viejo sirve |
| **RAM** | 512MB | 1GB | AdGuard usa ~150MB en promedio |
| **Almacenamiento** | 4GB libres | 8GB libres | Para logs y configuración |
| **Red** | WiFi funcional | Puerto Ethernet (RJ45) | Cable reduce latencia a ~5ms |
| **Consumo** | 5-10W en idle | - | Menos que un cargador de celular |

### Hardware (Opción B: Máquina Virtual)

- **Hipervisor**: VirtualBox / VMware / Proxmox / Hyper-V
- **Recursos**: 1 vCPU, 512MB RAM, 8GB disco
- **Red**: Adaptador en modo Puente (Bridge) para que tenga IP en tu red local

### Hardware (Opción C: Raspberry Pi)

- **Modelos compatibles**: Pi 3, 4, 5, Zero W, Zero 2 W
- **SD Card**: 8GB mínimo (Clase 10)
- **Fuente**: 5V 2.5A oficial

### Software

- **Sistema Operativo**: Ubuntu Server 22.04 LTS o 24.04 LTS ([Descargar aquí](https://ubuntu.com/download/server))
- **Acceso SSH**: PuTTY (Windows) o Terminal (Linux/macOS)
- **Navegador**: Para acceder al panel web de configuración

### Red

- **Router**: Cualquier router hogareño con acceso a configuración DHCP
- **Credenciales de admin**: Usuario y contraseña del router
- **IP libre**: Una IP fija en tu rango local (ej: 192.168.1.100)

---

## 🌐 Configurar IP Estática

**Antes de instalar AdGuard**, es fundamental que el servidor tenga una IP fija para que los dispositivos siempre lo encuentren.

### Método 1: Desde Ubuntu Server (Netplan)

1. Identificá tu interfaz de red:

```bash
ip a
```

Vas a ver algo como `enp0s3`, `eth0`, `ens33` o `wlan0`.

2. Editá el archivo de configuración:

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

3. Reemplazá todo el contenido por esto (ajustá los valores a tu red):

```yaml
network:
  version: 2
  ethernets:
    enp0s3:              # CAMBIÁ esto por tu interfaz (del paso 1)
      dhcp4: no
      addresses:
        - 192.168.1.100/24    # IP estática que elegís para el servidor
      routes:
        - to: default
          via: 192.168.1.1     # IP de tu router (gateway)
      nameservers:
        addresses:
          - 8.8.8.8            # DNS temporales (después usaremos AdGuard)
          - 1.1.1.1
```

4. Aplicá los cambios:

```bash
sudo netplan apply
```

5. Verificá que funcionó:

```bash
ip a
```

Deberías ver tu nueva IP fija (192.168.1.100 en este ejemplo).

### Método 2: Desde el Router (Reserva DHCP)

Si no querés tocar la configuración de Ubuntu, podés reservar la IP desde el router:

1. Entrá al panel del router (ej: `192.168.0.1` o `192.168.1.1`)
2. Buscá **"DHCP Reservation"**, **"Reserva de IP"** o **"IP Binding"**
3. Encontrá tu servidor en la lista de dispositivos conectados
4. Asigná una IP fija basada en su dirección MAC
5. Guardá y reiniciá el servidor

> **💡 Tip**: El Método 1 es más confiable porque la IP está configurada en el propio servidor.

---

## 🚀 Instalación

### Paso 1: Actualizar el Sistema

Antes de empezar, actualizá Ubuntu:

```bash
sudo apt update && sudo apt upgrade -y
```

### Paso 2: Configurar el Firewall

Abrí los puertos necesarios:

```bash
sudo ufw allow ssh
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 80/tcp
sudo ufw allow 3000/tcp
sudo ufw enable
```

**Explicación de puertos:**
- `22` (SSH): Acceso remoto al servidor
- `53` (DNS): Puerto obligatorio para consultas DNS
- `80` o `3000`: Panel de administración web
- `443` (HTTPS): Opcional, para panel seguro

### Paso 3: Instalar AdGuard Home

Ejecutá el script oficial de instalación:

```bash
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
```

![Instalación completada](https://github.com/user-attachments/assets/13538a5b-8a72-41c3-ae64-fbce2dcf496f)

*Script de instalación finalizado mostrando IP y puertos.*

El script va a:
1. Descargar la última versión de AdGuard Home
2. Instalar el servicio
3. Configurarlo para iniciarse automáticamente
4. Mostrarte la IP y puerto para acceder

**Tiempo estimado: 2-5 minutos**

### Paso 4: Configuración Inicial

Una vez instalado, abrí tu navegador en cualquier dispositivo de la red y andá a:

```
http://[IP-DE-TU-SERVIDOR]:3000
```

Ejemplo: `http://192.168.1.100:3000`

El asistente te va a guiar:

1. **Interfaces de escucha**:
   - Puerto web: `3000` (o `80` si preferís)
   - Puerto DNS: `53` (obligatorio, no cambiar)

2. **Crear usuario administrador**:
   - Usuario: el que quieras
   - Contraseña: segura y que recuerdes

3. **Configurar DNS upstream** (servidores DNS que AdGuard va a consultar):
   ```
   Cloudflare:
   1.1.1.1
   1.0.0.1
   
   Google (alternativo):
   8.8.8.8
   8.8.4.4
   ```

4. Hacé click en **"Siguiente"** y luego **"Abrir panel de control"**

![Panel de control AdGuard]<img width="1227" height="958" alt="4" src="https://github.com/user-attachments/assets/f0909a6c-6762-4652-ba77-0714d3745fef" />

*Panel de control principal bloqueando rastreadores.*

---

## 🔧 Configuración del Router

Para que AdGuard funcione en **toda tu red**, tenés que configurar el router para que use tu servidor como DNS principal.

### Configuración General

1. Abrí un navegador e ingresá a la IP de tu router (comúnmente):
   - `192.168.0.1`
   - `192.168.1.1`
   - `192.168.1.254`

2. Ingresá con tu usuario y contraseña de administrador

3. Buscá la sección:
   - **"DHCP"**
   - **"LAN Settings"**
   - **"Configuración de red local"**
   - **"Internet"**

4. Configurá los DNS:
   - **DNS Primario**: `192.168.1.100` (la IP de tu servidor AdGuard)
   - **DNS Secundario**: **DEJAR VACÍO** o poner la misma IP

> ⚠️ **MUY IMPORTANTE**: NO pongas DNS públicos como `8.8.8.8` o `1.1.1.1` en el secundario. Si lo hacés, cuando AdGuard esté ocupado o caído, los dispositivos van a saltar el bloqueo.

5. Guardá los cambios y reiniciá el router

### Routers Comunes en Argentina

| Marca Router | IP de Acceso | Usuario | Contraseña | Ubicación DNS |
|--------------|--------------|---------|------------|---------------|
| **Arnet/Telecom** | 192.168.1.1 | admin | admin | Configuración Avanzada > LAN > DNS Primario |
| **Claro** | 192.168.0.1 | admin | admin | Red > DHCP > Servidor DNS |
| **Fibertel** | 192.168.0.1 | admin | password | Configuración > Red Local > DNS |
| **Movistar** | 192.168.1.1 | 1234 | 1234 | Configuración Avanzada > DHCP > DNS |
| **Personal Flow** | 192.168.0.1 | admin | admin | Configuración de Red > DNS |
| **TP-Link** | 192.168.0.1 | admin | admin | Network > DHCP Server > Primary DNS |
| **Mikrotik** | 192.168.88.1 | admin | (vacía) | IP > DHCP Server > Networks > DNS Server |
| **D-Link** | 192.168.0.1 | admin | (vacía) | Setup > Network Settings |
| **Netgear** | 192.168.1.1 | admin | password | Basic > Internet > Domain Name Server |

> **📝 Nota**: Estos son valores por defecto. Si no funcionan, buscá la etiqueta debajo del router.

---

## 📋 Listas de Bloqueo Recomendadas

AdGuard ya incluye listas por defecto, pero podés agregar estas para mejor cobertura:

### Cómo Agregar Listas

1. Entrá al panel de AdGuard: `http://192.168.1.100`
2. Andá a **Filtros** → **Listas de filtros DNS**
3. Hacé click en **"Agregar lista de bloqueo"**
4. Seleccioná **"Agregar una lista personalizada"**
5. Pegá la URL y hacé click en **"Guardar"**

### Listas Esenciales

```
AdGuard DNS Filter
(Incluida por defecto - bloquea +300.000 dominios)

OISD Big List
https://big.oisd.nl/
(Lista unificada - bloquea +1.000.000 de dominios)

Steven Black Hosts
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
(Bloquea ads, malware y rastreadores)

Peter Lowe's Ad Server List
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus
(Lista ligera y eficiente)
```

### Listas para Argentina/LATAM

```
EasyList Spanish
https://easylist-downloads.adblockplus.org/easylistspanish.txt
(Publicidad en sitios en español)

Fanboy's Spanish/Portuguese
https://www.fanboy.co.nz/fanboy-espanol.txt
(Complementa la anterior)
```

### Listas Anti-Rastreo

```
AdGuard Tracking Protection
(Incluida por defecto)

EasyPrivacy
https://easylist-downloads.adblockplus.org/easyprivacy.txt
(Bloquea trackers y analytics)
```

> **⚡ Tip**: No agregues demasiadas listas (con 3-5 bien elegidas alcanza). Más listas = más consumo de RAM y posibles falsos positivos.

---

## ✅ Verificar que Funciona

### Test 1: Verificar DNS desde la Terminal

Desde cualquier dispositivo conectado a tu red, abrí una terminal (CMD en Windows) y ejecutá:

```bash
nslookup google.com
```

Deberías ver algo como:

```
Server:  192.168.1.100
Address: 192.168.1.100#53

Non-authoritative answer:
Name:    google.com
Address: 142.250.xxx.xxx
```

✅ Si la IP del **Server** es la de tu AdGuard, está funcionando.

❌ Si ves `8.8.8.8` u otra IP, el router no está configurado correctamente.

### Test 2: Verificar Bloqueo de Publicidad

Visitá estos sitios desde tu celular o PC (sin adblocker en el navegador):

- **Test de AdGuard**: https://adguard.com/en/test.html
  - Deberías ver: ✅ **"AdGuard DNS is working"**

- **Test exhaustivo**: https://d3ward.github.io/toolz/adblock.html
  - Deberías ver la mayoría de pruebas en verde (bloqueado)

- **Can You Block It**: https://canyoublockit.com/
  - Deberías pasar la mayoría de tests

### Test 3: Ver Estadísticas en el Panel

Entrá a `http://192.168.1.100` y revisá:

- **Consultas bloqueadas** > 0 (debería ir subiendo)
- **Lista de clientes**: Tus dispositivos conectados
- **Registro de consultas**: DNS queries en tiempo real

---

## 🛠️ Solución de Problemas

### 🔴 Veo publicidad en mi celular Android

**Causa**: Android tiene una función llamada "DNS Privado" que ignora la configuración de red local.

**Solución**:
1. Andá a `Ajustes` → `Conexión y compartir` (o `Red e Internet`)
2. Buscá **"DNS Privado"** o **"Private DNS"**
3. Seleccioná **"Desactivado"** o **"Off"**
4. Guardá y reiniciá la conexión WiFi

**Alternativa**: Configurar DNS privado con AdGuard:
- Seleccioná "Nombre del proveedor de DNS privado"
- Ingresá: `dns.adguard.com` (si tenés AdGuard DNS público)

---

### 🔴 Instagram, Facebook o WhatsApp se congelan

**Causa**: AdGuard bloquea dominios de rastreo que estas apps usan para cargar contenido.

**Solución**: Agregá excepciones en `Filtros` → `Reglas personalizadas`:

```
@@||graph.instagram.com^
@@||graph.facebook.com^
@@||whatsapp.com^
@@||wa.me^
```

Guardá y recargá la app.

---

### 🔴 Internet anda lento o sitios no cargan

**Causa**: Conflicto con resolución IPv6 o DNS upstream lento.

**Solución 1 - Deshabilitar IPv6**:
1. `Configuración` → `Configuración DNS`
2. Activá **"Deshabilitar la resolución de direcciones IPv6"**
3. Guardá cambios

**Solución 2 - Cambiar DNS upstream**:
Probá con estos (más rápidos para Argentina):

```
Cloudflare:
1.1.1.1
1.0.0.1

Google:
8.8.8.8
8.8.4.4
```

---

### 🔴 El servidor no arranca después de reiniciar

**Causa**: El servicio no está habilitado para inicio automático.

**Solución**:

```bash
sudo systemctl enable AdGuardHome
sudo systemctl start AdGuardHome
sudo systemctl status AdGuardHome
```

Deberías ver: `Active: active (running)`

---

### 🔴 No puedo acceder al panel web (Error de conexión)

**Verificá paso a paso**:

1. ¿El servidor está prendido?
```bash
ping 192.168.1.100
```

2. ¿AdGuard está corriendo?
```bash
sudo systemctl status AdGuardHome
```

3. ¿El firewall está bloqueando el puerto?
```bash
sudo ufw status
```

4. ¿Estás usando el puerto correcto?
- Por defecto es: `http://192.168.1.100:3000`
- Puede que hayas configurado puerto 80: `http://192.168.1.100`

---

### 🔴 Dispositivos Apple (iPhone/iPad) siguen mostrando publicidad

**Causa**: iCloud Private Relay activo (bypass DNS local).

**Solución**:
1. `Ajustes` → `[Tu nombre]` → `iCloud`
2. `Private Relay` → **Desactivar**

---

## 🔧 Mantenimiento

### Actualizar AdGuard Home

**Método 1: Desde el panel web** (más fácil)
1. Entrá a `http://192.168.1.100`
2. `Configuración` → `General`
3. Si hay actualizaciones disponibles, hacé click en **"Actualizar"**

**Método 2: Desde terminal**
```bash
sudo /opt/AdGuardHome/AdGuardHome -s stop
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
sudo /opt/AdGuardHome/AdGuardHome -s start
```

---

### Hacer Backup de la Configuración

**Manual (recomendado)**:

```bash
# Detener AdGuard
sudo systemctl stop AdGuardHome

# Crear backup
sudo tar -czf ~/adguard_backup_$(date +%Y%m%d).tar.gz -C /opt/AdGuardHome/ .

# Reiniciar AdGuard
sudo systemctl start AdGuardHome
```

El backup se guarda en: `~/adguard_backup_20260110.tar.gz`

**Backup automático diario**:

```bash
# Crear script
nano ~/backup_adguard.sh
```

Pegá esto:

```bash
#!/bin/bash
BACKUP_DIR=~/adguard-backups
mkdir -p $BACKUP_DIR
sudo tar -czf $BACKUP_DIR/adguard_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /opt/AdGuardHome/ .

# Mantener solo los últimos 7 backups
ls -t $BACKUP_DIR/adguard_backup_*.tar.gz | tail -n +8 | xargs -r rm
```

Hacelo ejecutable:

```bash
chmod +x ~/backup_adguard.sh
```

Programá backup diario a las 3 AM:

```bash
crontab -e
# Agregá esta línea:
0 3 * * * /home/TU_USUARIO/backup_adguard.sh
```

---

### Restaurar Backup

```bash
# Detener AdGuard
sudo systemctl stop AdGuardHome

# Restaurar
sudo tar -xzf ~/adguard_backup_20260110.tar.gz -C /opt/AdGuardHome/

# Reiniciar
sudo systemctl start AdGuardHome
```

---

### Ver Logs en Tiempo Real

Para debuggear problemas:

```bash
sudo journalctl -u AdGuardHome -f
```

Presioná `Ctrl+C` para salir.

---

### Limpiar Logs Antiguos

Si el disco se está llenando:

1. Panel web: `Configuración` → `General`
2. **Intervalo de registro de consultas**: Cambiar a `1 día` o `1 hora`
3. `Configuración` → `DNS` → `Registro de consultas`
4. Click en **"Limpiar registro"**

---

## ❓ Preguntas Frecuentes

<details>
<summary><strong>¿Funciona con cualquier router?</strong></summary>

Sí, siempre que permita cambiar los servidores DNS en la configuración DHCP. El 99% de routers hogareños modernos lo permiten. Si tu router del ISP no lo permite, podés conseguir un router neutro por ~$15-30 USD.

</details>

<details>
<summary><strong>¿Puedo usar Raspberry Pi en lugar de una notebook?</strong></summary>

¡Absolutamente! De hecho, es el hardware ideal para este proyecto. Funciona perfecto en:
- Raspberry Pi 5, 4, 3
- Raspberry Pi Zero 2 W
- Raspberry Pi Zero W (más lento pero funciona)

Consumo: 2-5W, silencioso, sin ruido.

</details>

<details>
<summary><strong>¿Afecta la velocidad de internet?</strong></summary>

No. De hecho puede mejorar la velocidad porque:
- No descargás publicidad (ahorrás ~30-40% de ancho de banda)
- El DNS local responde más rápido que uno remoto (~5-15ms vs ~30-100ms)
- Cache de DNS reduce consultas repetidas

</details>

<details>
<summary><strong>¿Bloquea anuncios en YouTube?</strong></summary>

**Parcialmente**. AdGuard bloquea:
- ✅ Rastreadores y analytics de YouTube
- ✅ Algunos anuncios de banner
- ❌ Anuncios integrados en el video (estos están mezclados con el contenido)

Para bloquear anuncios de video necesitás extensiones de navegador como uBlock Origin o YouTube Vanced (Android).

</details>

<details>
<summary><strong>¿Necesito conocimientos técnicos avanzados?</strong></summary>

No. Si podés:
- Instalar Ubuntu Server siguiendo una guía
- Copiar y pegar comandos en una terminal
- Acceder a la configuración de tu router

...entonces podés hacer esto sin problemas. El tutorial está pensado para principiantes.

</details>

<details>
<summary><strong>¿Cuánto consume de electricidad?</strong></summary>

Depende del hardware:
- Notebook vieja: 10-25W (~$50-100 ARS/mes)
- Raspberry Pi 4: 5-8W (~$20-40 ARS/mes)
- PC de escritorio: 40-80W (~$150-300 ARS/mes)

Comparación: Una heladera consume ~100-200W.

</details>

<details>
<summary><strong>¿Puedo desactivarlo temporalmente?</strong></summary>

Sí, tenés varias opciones:

1. **Desde el panel**: Desactivar filtros temporalmente
2. **Desde el router**: Volver a poner DNS de tu ISP
3. **En dispositivos específicos**: Configurar DNS manual (8.8.8.8)

</details>

<details>
<summary><strong>¿Es legal usar AdGuard?</strong></summary>

Sí, es 100% legal en Argentina y el mundo. Estás controlando tu propia red doméstica. Es como usar un adblocker en el navegador, pero a nivel de red.

</details>

<details>
<summary><strong>¿Qué pasa si se cae el servidor?</strong></summary>

Los dispositivos automáticamente van a usar el DNS secundario (si configuraste uno) o el DNS de tu ISP. Vas a tener internet sin problemas, pero sin bloqueo de publicidad hasta que lo arregles.

**Tip**: Para alta disponibilidad, podés montar 2 servidores AdGuard (uno principal, uno backup).

</details>

<details>
<summary><strong>¿Funciona fuera de mi casa (4G/5G)?</strong></summary>

No automáticamente. AdGuard Home solo funciona en tu red local (WiFi de tu casa).

**Para usarlo afuera de casa**:
- Configurá una VPN a tu casa (WireGuard, OpenVPN)
- Usá AdGuard DNS público (pero perdés el control local)

</details>

<details>
<summary><strong>¿Puedo bloquear sitios específicos?</strong></summary>

Sí! Desde `Filtros` → `Reglas personalizadas`:

```
# Bloquear un dominio completo
||facebook.com^

# Bloquear con subdominios
||*.tiktok.com^

# Bloquear solo www
||www.instagram.com^
```

Útil para control parental o productividad.

</details>

---

## 📊 Estadísticas de Uso Real

Datos reales después de **1 mes de uso continuo** en casa:

| Métrica | Valor |
|---------|-------|
| **Consultas totales** | ~500,000 |
| **Consultas bloqueadas** | ~180,000 (36%) |
| **Dominios únicos bloqueados** | ~15,000 |
| **Consumo de RAM** | 150-200MB |
| **Uso de CPU** | <5% promedio |
| **Ancho de banda ahorrado** | ~2.5GB/mes |

**Dispositivos protegidos**: 2 PCs, 3 celulares, 1 Smart TV, 1 tablet, 2 consolas = **9 dispositivos simultáneos**

---

## 🤝 Contribuciones

¿Querés mejorar este proyecto? ¡Todas las contribuciones son bienvenidas!

### Formas de contribuir:

- 🐛 **Reportar bugs**: [Abrí un issue](https://github.com/AlanMeglio/AdGuard/issues)
- 💡 **Sugerir mejoras**: Compartí tus ideas
- 📝 **Mejorar documentación**: Corregí errores o agregá info
- 🌐 **Agregar routers**: Compartí configuraciones de otros routers
- 💻 **Pull requests**: Contribuí con código o scripts

### Cómo contribuir:

1. Forkeá el repositorio
2. Creá un branch: `git checkout -b mejora/descripcion`
3. Hacé tus cambios y commit: `git commit -m 'Agregar nueva funcionalidad'`
4. Push al branch: `git push origin mejora/descripcion`
5. Abrí un Pull Request

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [AdGuard Home Wiki](https://github.com/AdguardTeam/AdGuardHome/wiki)
- [AdGuard DNS Knowledge Base](https://adguard-dns.io/kb/)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)

### Comunidad

- [Foro oficial de AdGuard](https://forum.adguard.com/)
- [Reddit: r/Adguard](https://www.reddit.com/r/Adguard/)
- [Reddit: r/selfhosted](https://www.reddit.com/r/selfhosted/)

### Alternativas

- **Pi-hole**: Similar a AdGuard, más antiguo, comunidad más grande
- **NextDNS**: Servicio cloud (no self-hosted)
- **Unbound**: DNS recursivo (más complejo de configurar)

---

## 📝 Créditos

- **Software**: [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) por AdGuard Team
- **Tutorial y documentación**: [Alan Meglio](https://github.com/AlanMeglio)
- **Inspiración**: Comunidad de r/selfhosted y r/Adguard

---

## ⚖️ Licencia

Este proyecto está licenciado bajo [MIT License](LICENSE).

**Resumen**: Podés usar, copiar, modificar, fusionar, publicar, distribuir, sublicenciar y/o vender copias de este software libremente.

---

## 🌟 ¿Te fue útil?

Si este proyecto te ayudó:
- ⭐ Dale una estrella al repositorio
- 🔄 Compartilo con otros
- 💬 [Abrí un issue](https://github.com/AlanMeglio/AdGuard/issues) si tenés dudas o sugerencias
- 🤝 Contribuí con mejoras

---
