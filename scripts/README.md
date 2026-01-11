# 🛠️ Scripts de Automatización

En esta carpeta encontrarás herramientas para facilitarte la vida con AdGuard Home.

## Lista de Scripts

### 🚀 Gestión Principal
*   **`install.sh`**: Script maestro de instalación. Detecta tu OS, baja AdGuard y configura el Firewall.
    *   Uso: `sudo ./install.sh`
*   **`update.sh`**: Actualiza AdGuard a la última versión disponible en GitHub, haciendo un backup previo por seguridad.
    *   Uso: `sudo ./update.sh`
*   **`uninstall.sh`**: **¡Cuidado!** Elimina AdGuard Home, el servicio systemd y limpia archivos.
    *   Uso: `sudo ./uninstall.sh`

### 💾 Backups
*   **`backup.sh`**: Crea un archivo `.tar.gz` comprimido con toda tu configuración (`AdGuardHome.yaml` y carpeta `data/`). Los guarda en `~/adguard-backups/`. Ideal para poner en un Cronjob semanal.
    *   Uso: `./backup.sh`
*   **`restore.sh`**: Restaura un backup previo. Si rompiste algo, usá esto.
    *   Uso: `sudo ./restore.sh [archivo]` (o sin argumentos para usar el último)

## 📝 Notas
*   Todos los scripts deben tener permisos de ejecución: `chmod +x *.sh`
*   La mayoría requiere `sudo` porque tocan servicios del sistema y puertos protegidos.

[← Volver al README principal](../README.md)
