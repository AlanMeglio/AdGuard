# Política de Seguridad

## Versiones Soportadas

Dado que este proyecto está en constante evolución y se basa en software de terceros (AdGuard Home, Ubuntu), solo brindamos soporte oficial sobre la última versión documentada en la rama `main` del repositorio.

| Versión | Soportada          |
| ------- | ------------------ |
| v1.x    | :white_check_mark: |
| < v1.0  | :x:                |

## Reporte de Vulnerabilidades

Tomamos la seguridad muy en serio. Si descubrís una vulnerabilidad de seguridad en los scripts de instalación, en la configuración sugerida, o en la documentación, por favor **NO abras un Issue público**.

En su lugar, por favor enviá un reporte por correo electrónico a `meglioalan@gmail.com`. Intenta incluir:
*   Descripción detallada de la vulnerabilidad.
*   Pasos para reproducirla (Proof of Concept).
*   Impacto potencial.

Nos comprometemos a revisar tu reporte en un plazo de 48-72 horas y a mantenerte informado sobre la corrección.

## Recomendaciones de Seguridad Críticas

Al configurar un servidor DNS en tu red local, estás manejando un componente crítico de tu infraestructura. Seguí estas recomendaciones:

### 1. ⚠️ NUNCA expongas el panel de administración a Internet
El panel de AdGuard Home (puerto 3000 o 80) debe ser accesible **únicamente desde tu red local (LAN)**. No hagas port forwarding de estos puertos en tu router hacia internet.

### 2. 🛡️ Firewall (UFW)
Asegurate de que el firewall del servidor Ubuntu esté siempre activo y solo permita tráfico necesario:
*   Entrada DNS (53 TCP/UDP)
*   Entrada Panel Web (3000/80 TCP) - restringido a IPs locales si es posible.
*   SSH (22) - idealmente con autenticación por clave pública, no password.

### 3. 🔑 Contraseñas Fuertes
*   Cambiá la contraseña por defecto de tu usuario de Ubuntu.
*   Usá una contraseña fuerte y única para el panel de administración de AdGuard Home.

### 4. 🔄 Actualizaciones
Mantené actualizado tanto el sistema operativo como AdGuard Home.
*   Ubuntu: `sudo apt update && sudo apt upgrade` regularmente.
*   AdGuard Home: Verificá actualizaciones desde el panel web o usá nuestro script `scripts/update.sh`.

### 5. 💾 Backups
Antes de cualquier cambio mayor, realizá un backup de tu configuración. Usá el script `scripts/backup.sh` incluido en este repositorio.

## Lo que NO debés hacer

*   ❌ No deshabilites SELinux o AppArmor si no sabés exactamente por qué.
*   ❌ No ejecutes scripts de internet sin leerlos antes (incluidos los nuestros).
*   ❌ No compartas tu IP pública ni tus credenciales en capturas de pantalla o logs compartidos.

¡Gracias por ayudar a mantener segura esta comunidad!
