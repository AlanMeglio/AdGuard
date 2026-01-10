# AdGuard Home en Hardware Reciclado: Tu Propio DNS Sinkhole

Transformá esa notebook vieja en un escudo de privacidad para toda tu red.

## 🎯 ¿Qué es esto?

Este proyecto nace de la idea de **costo cero y reciclaje tecnológico**. En lugar de comprar hardware nuevo, reutilizamos una notebook en desuso (o una Máquina Virtual) para montar un servidor DNS local que bloquea publicidad y rastreadores en todos los dispositivos de la casa (Smart TV, celulares, consolas, PC) sin instalar software en cada uno.

### ¿Por qué hacer esto?

- **Bloqueo a nivel de red**: Elimina anuncios en apps y webs antes de que lleguen a tus dispositivos
- **Privacidad**: Tus consultas DNS no pasan por Google o tu ISP; vos tenés el control
- **Ahorro de ancho de banda**: Al no descargar la publicidad, las páginas cargan más rápido
- **Hardware Reciclado**: Dale una segunda vida a equipos antiguos (consume muy pocos recursos)

![1-neofetch](https://github.com/user-attachments/assets/a6814d32-0c78-4112-a071-1c0e958cb29f)

*El servidor corriendo en Ubuntu Server con recursos mínimos.*

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

### 1. Preparación del Sistema

Antes de instalar AdGuard Home, asegurate de tener configurada una **IP Estática** en tu servidor. Podés seguir la [guía de configuración de IP estática](docs/ip-estatica.md).

### 2. Configuración del Firewall

Abrí los puertos necesarios para el funcionamiento de AdGuard:

```bash
sudo ufw allow ssh
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 80/tcp
sudo ufw allow 3000/tcp
sudo ufw enable
```

**Puertos explicados:**
- `53`: Puerto DNS (obligatorio)
- `80` o `3000`: Panel de administración web
- `22`: SSH para acceso remoto

### 3. Instalación de AdGuard Home

Ejecutá el script oficial de instalación automatizada:

```bash
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
```

![2-install](https://github.com/user-attachments/assets/05521794-ca77-4ea7-85f0-48c67e2dfb77)

*Script de instalación finalizado mostrando IP y puertos.*

### 4. Configuración Inicial

Una vez instalado, abrí el navegador en cualquier dispositivo de tu red e ingresá a:

```
http://[IP-DE-TU-SERVIDOR]:3000
```

Seguí el asistente de configuración:

1. **Puerto de administración**: Dejá `3000` o cambialo a `80`
2. **Puerto DNS**: `53` (obligatorio, no cambiar)
3. **Creá un usuario y contraseña** para el panel de administración
4. **Configurá los DNS upstream**: Dejá los valores por defecto o usá:
   - Cloudflare: `1.1.1.1` y `1.0.0.1`
   - Quad9: `9.9.9.9` y `149.112.112.112`

![3-dashboard](https://github.com/user-attachments/assets/610ca5a4-6b95-4d89-9d4a-df6eaaea0d55)

*Panel de control principal bloqueando rastreadores.*

---

## 🌐 Configuración del Router

Para que AdGuard funcione en **toda tu red**, configurá tu router para que use el servidor como DNS:

1. Entrá a la configuración de tu router (generalmente `192.168.0.1` o `192.168.1.1`)
2. Buscá la sección **DHCP** o **LAN Settings**
3. Configurá los DNS:
   - **DNS Primario**: IP de tu servidor AdGuard (ej: `192.168.1.100`)
   - **DNS Secundario**: La misma IP del servidor o dejalo vacío

> ⚠️ **IMPORTANTE**: NO pongas DNS públicos como `8.8.8.8` en el secundario, ya que los dispositivos saltarán el bloqueo de AdGuard.

### Verificación

Para verificar que está funcionando correctamente:

1. Desde cualquier dispositivo, visitá: https://adguard.com/en/test.html
2. Deberías ver el mensaje: **"AdGuard DNS is working"**

---

## 🔧 Configuración Avanzada (Opcional)

### Listas de Bloqueo Recomendadas

AdGuard viene con listas por defecto, pero podés agregar más:

**En el panel de AdGuard:**
1. Andá a **Filtros** → **Listas de filtros DNS**
2. Agregá estas listas populares:

```
AdGuard DNS Filter (incluido por defecto)
Peter Lowe's List: https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus
StevenBlack Hosts: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
```

### HTTPS para el Panel Web

Si querés acceder al panel de forma segura desde afuera de tu red:

1. Instalá un certificado SSL (Let's Encrypt)
2. Configuralo en **Configuración** → **Encriptación**
3. Usá un servicio como DuckDNS para tener un dominio gratuito

---

## 🛠️ Solución de Problemas

### Veo publicidad en mi celular Android

**Causa**: Android tiene una función llamada "DNS Privado" que ignora la configuración de red local.

**Solución**: 
1. Andá a **Ajustes** → **Conexión y compartir** → **DNS Privado**
2. Ponelo en **DESACTIVADO**

En algunos móviles está en: **Ajustes** → **Redes e Internet** → **DNS privado**

---

### Instagram o Apps se congelan un momento

**Causa**: A veces se bloquean dominios necesarios para la carga inicial (Falsos Positivos).

**Solución**: 
Agregá reglas de excepción en el panel de AdGuard:

1. Andá a **Filtros** → **Reglas personalizadas**
2. Agregá estas líneas:

```
@@||graph.instagram.com^
@@||graph.facebook.com^
@@||api.instagram.com^
```

---

### Internet anda lento en algunos sitios

**Causa**: Conflicto con la resolución IPv6 de tu proveedor.

**Solución**:
1. En AdGuard, andá a **Configuración** → **Configuración DNS**
2. Activá **"Deshabilitar la resolución de direcciones IPv6"**

---

### El servidor no arranca después de reiniciar

**Causa**: AdGuard no se configuró como servicio de inicio automático.

**Solución**:
```bash
sudo systemctl enable AdGuardHome
sudo systemctl start AdGuardHome
```

Verificá el estado con:
```bash
sudo systemctl status AdGuardHome
```

---

## 📊 Mantenimiento

### Actualizar AdGuard Home

Desde el panel web: **Configuración** → **General** → **Buscar actualizaciones**

O desde terminal:
```bash
sudo /opt/AdGuardHome/AdGuardHome -s stop
sudo /opt/AdGuardHome/AdGuardHome --update
sudo /opt/AdGuardHome/AdGuardHome -s start
```

### Hacer Backup de la Configuración

**Desde el panel**: **Configuración** → **General** → **Exportar configuración**

**Desde terminal**:
```bash
sudo cp /opt/AdGuardHome/AdGuardHome.yaml ~/adguard-backup-$(date +%Y%m%d).yaml
```

---

## 📈 Estadísticas de Uso Real

En mi caso, después de 1 mes de uso continuo:

- **Consultas totales**: ~500,000
- **Consultas bloqueadas**: ~180,000 (36%)
- **Dominios únicos bloqueados**: ~15,000
- **Consumo de RAM**: 150-200MB
- **Uso de CPU**: <5% promedio

> Esto equivale a **no descargar ~2.5GB de publicidad** en un mes.

---

## 🤝 Contribuciones

¿Encontraste un error o querés mejorar la guía? 

1. Hacé un fork del repositorio
2. Creá una rama para tu feature (`git checkout -b feature/mejora`)
3. Hacé commit de tus cambios (`git commit -am 'Agrego mejora X'`)
4. Push a la rama (`git push origin feature/mejora`)
5. Abrí un Pull Request

---

## 📚 Recursos Adicionales

- [Documentación oficial de AdGuard Home](https://github.com/AdguardTeam/AdGuardHome/wiki)
- [Guía de configuración de IP estática](docs/ip-estatica.md) *(próximamente)*
- [Lista de compatibilidad de routers](docs/routers-compatibles.md) *(próximamente)*
- [Comparación con Pi-hole](docs/adguard-vs-pihole.md) *(próximamente)*

---

## 📝 Créditos

- **Software**: [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome), desarrollado por AdGuard Team
- **Guía de implementación**: Realizada por [Alan Meglio](https://github.com/AlanMeglio) con fines educativos
- **Comunidad**: Gracias a todos los que reportaron issues y mejoraron esta guía

---

## ⚖️ Licencia

Este proyecto está licenciado bajo la [Licencia MIT](LICENSE) - mirá el archivo LICENSE para más detalles.

---

## ❓ FAQ

**¿Funciona con cualquier router?**  
Sí, siempre que tu router permita cambiar los servidores DNS en la configuración DHCP.

**¿Puedo usar esto en una Raspberry Pi?**  
¡Absolutamente! De hecho, es el hardware ideal para este proyecto.

**¿Afecta la velocidad de navegación?**  
En general, la mejora. Al bloquear anuncios, las páginas cargan más rápido. La latencia DNS es mínima (~5-15ms en red local).

**¿Bloquea anuncios en YouTube?**  
No completamente. Los anuncios de YouTube están integrados en el video mismo, pero sí bloquea rastreadores y algunos anuncios display.

**¿Necesito conocimientos técnicos avanzados?**  
No. Si sabés instalar Ubuntu Server y acceder a la configuración de tu router, podés hacer esto.

---

Si tenés dudas sobre esta implementación, **[abrí un Issue](https://github.com/AlanMeglio/AdGuard/issues)** y te ayudamos. 🚀
