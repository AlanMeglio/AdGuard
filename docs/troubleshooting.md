# 🛠️ Solución de Problemas (Troubleshooting)

Esta guía recopila los problemas más frecuentes al instalar y usar AdGuard Home, junto con sus soluciones probadas. Si tu problema no aparece acá, chequeá los [Issues abiertos](https://github.com/AlanMeglio/AdGuard/issues) o abrí uno nuevo.

---

## 🔍 Diagnóstico Rápido

Antes de nada, ejecutá estos comandos en tu servidor para ver el estado general:

```bash
# Ver si el servicio está corriendo
sudo systemctl status AdGuardHome

# Ver si hay puertos escuchando (deberías ver 53 y 3000/80)
sudo ss -tulpn | grep AdGuard

# Ver logs en tiempo real
journalctl -u AdGuardHome -f
```

---

## 🚫 Problemas de Instalación y Acceso

### 1. No puedo acceder al panel web (`http://IP:3000`)
*   **🔴 Síntoma**: El navegador tira error "Connection refused" o "Time out".
*   **🔍 Causa**: El servicio no está corriendo o el Firewall lo bloquea.
*   **✅ Solución**:
    1.  Verificá el servicio: `sudo systemctl status AdGuardHome`. Si dice `inactive` o `failed`, corré `sudo systemctl start AdGuardHome`.
    2.  Verificá el firewall: `sudo ufw status`. Si está activo y no permitiste el puerto 3000, hacelo: `sudo ufw allow 3000/tcp`.
    3.  Probá conexión local: Desde el mismo servidor, `curl -v http://localhost:3000`.

### 2. Error "bind: address already in use" (Puerto 53 ocupado)
*   **🔴 Síntoma**: AdGuard falla al iniciar y en los logs dice que no puede atar el puerto 53.
*   **🔍 Causa**: Ubuntu viene con `systemd-resolved` que ya usa el puerto 53.
*   **✅ Solución**:
    1.  Deshabilitar el stub resolver de Ubuntu:
        ```bash
        sudo systemctl disable systemd-resolved
        sudo systemctl stop systemd-resolved
        ```
    2.  (Opcional) Cambiar el puerto en `/etc/systemd/resolved.conf` poniendo `DNSStubListener=no` y reiniciar.

---

## 🌐 Problemas de Red y DNS

### 3. Internet funciona pero NO bloquea publicidad
*   **🔴 Síntoma**: Navegás bien pero seguís viendo anuncios. El panel de AdGuard muestra "0 DNS Queries".
*   **🔍 Causa**: Tus dispositivos no están usando AdGuard como DNS.
*   **✅ Solución**:
    1.  Revisá la configuración DHCP de tu Router. ¿Pusiste la IP de AdGuard como DNS Primario?
    2.  ¿Tenés un DNS Secundario configurado (ej: 8.8.8.8)? **BORRALO**. Si tu PC falla el primero, va al segundo y se saltea el bloqueo.
    3.  En Windows/Android, desconectá y conectá el WiFi para renovar la IP.
    4.  Ciertos navegadores usan "DNS seguro" (DoH) propio. Desactivalo en Chrome/Firefox.

### 4. "No se puede resolver la dirección" (Sin Internet)
*   **🔴 Síntoma**: No podés abrir ninguna web.
*   **🔍 Causa**: AdGuard está caído o mal configurado (Upstream DNS fallando).
*   **✅ Solución**:
    1.  Entrá al panel > **Settings** > **DNS Settings**.
    2.  Probá los "Upstream DNS servers". Asegurate que haya válidos como `https://dns.cloudflare.com/dns-query` o `8.8.8.8`.
    3.  Hacé click en "Test upstreams".

---

## 📱 Problemas Específicos de Dispositivos/Apps

### 5. YouTube sigue mostrando anuncios
*   **🔴 Síntoma**: Los videos tienen publicidad.
*   **🔍 Causa**: Los anuncios de YouTube vienen del mismo dominio que el video (`youtube.com`).
*   **✅ Solución**: **DNS no puede bloquear anuncios de YouTube** de forma efectiva sin romper el sitio. Necesitás usar uBlock Origin en PC o YouTube Vanced/Revanced en Android. AdGuard Home NO es magia para YouTube.

### 6. WhatsApp / Instagram / Facebook no cargan
*   **🔴 Síntoma**: Las apps quedan cargando infinito o dan error de conexión.
*   **🔍 Causa**: Alguna lista de bloqueo es muy agresiva y bloqueó dominios de Facebook/Meta (ej: `graph.facebook.com` o `whatsapp.net`).
*   **✅ Solución**:
    1.  Andá al **Query Log** en AdGuard.
    2.  Intentá abrir la app en tu celular.
    3.  Mirá qué dominio aparece en ROJO (Bloqueado) en el log justo en ese momento.
    4.  Hacé click en "Unblock" (Desbloquear).

### 7. Netflix / Streaming lento o no carga
*   **🔴 Síntoma**: Netflix detecta proxy o no carga.
*   **🔍 Causa**: Geo-bloqueo o filtrado excesivo.
*   **✅ Solución**: Agregá los dominios de tu servicio de streaming a la "Allowlist" personalizada si ves que están siendo bloqueados.

---

## ⚡ Rendimiento y Recursos

### 8. Alto uso de CPU/RAM o Logs gigantes
*   **🔴 Síntoma**: La Raspberry Pi se calienta o se llena el disco.
*   **🔍 Causa**: Demasiados logs o intervalo de retención muy largo (ej: 90 días).
*   **✅ Solución**:
    1.  Andá a **Settings** > **General Settings**.
    2.  En "Logs configuration", bajá la retención a **24 horas** o **3 días**.
    3.  Hacé click en "Clear query log" para liberar espacio ya.

### 9. Lag en Juegos Online
*   **🔴 Síntoma**: Ping alto en CS:GO, Valorant, LoL.
*   **🔍 Causa**: El DNS suele afectar solo la conexión inicial, no el ping durante el juego. PERO, si tenés una lista de bloqueo enorme, el procesamiento puede tardar ms extra.
*   **✅ Solución**:
    1.  Usá servidores Upstream rápidos (Cloudflare 1.1.1.1 suele ser más rápido que Google).
    2.  Desactivá "Optimistic Caching" si tenés problemas de resolución inestables.

---

## 🛡️ VPN y AdGuard

### 10. Mi VPN corporativa no conecta
*   **🔴 Síntoma**: Al activar VPN del trabajo, falla.
*   **🔍 Causa**: Conflicto de rutas o DNS.
*   **✅ Solución**: Las VPNs suelen forzar sus propios DNS. Esto es normal. Mientras uses la VPN, probablemente no uses AdGuard.
