# 🐳 Instalación con Docker

Si preferís tener todo containerizado y limpio, usar Docker es una excelente opción. Esta guía asume que ya tenés Docker instalado en tu sistema.

## 📦 Docker Compose (Recomendado)

La forma más fácil de mantener esto es con Docker Compose.

1.  Creá una carpeta para el proyecto:
    ```bash
    mkdir adguard-docker
    cd adguard-docker
    ```

2.  Creá un archivo `docker-compose.yaml`:
    ```bash
    nano docker-compose.yaml
    ```

3.  Pegá el siguiente contenido:

```yaml
version: "3"

services:
  adguardhome:
    image: adguard/adguardhome
    container_name: adguardhome
    restart: unless-stopped
    # Mapeo de puertos
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp" # Solo si vas a usar DHCP
      - "68:68/udp" # Solo si vas a usar DHCP
      - "80:80/tcp" # Interfaz web (http)
      - "443:443/tcp" # Interfaz web (https)
      - "443:443/udp" # DNS-over-QUIC
      - "3000:3000/tcp" # Instalación inicial
    # Persistencia de datos
    volumes:
      - ./work:/opt/adguardhome/work
      - ./conf:/opt/adguardhome/conf
```

4.  ⚠️ **Conflicto de puerto 53 en Ubuntu**:
    Si estás en Ubuntu, el puerto 53 suele estar ocupado por `systemd-resolved`. Tenés que liberarlo antes de correr Docker.
    Ver guía en [Troubleshooting](troubleshooting.md#2-error-bind-address-already-in-use-puerto-53-ocupado).

5.  Arrancá el contenedor:
    ```bash
    docker-compose up -d
    ```

6.  Abrí `http://TU-IP:3000` para configurar.

## 🐢 Instalación con Docker Run (Comando simple)

Si no querés usar compose:

```bash
docker run --name adguardhome \
    --restart unless-stopped \
    -v $(pwd)/work:/opt/adguardhome/work \
    -v $(pwd)/conf:/opt/adguardhome/conf \
    -p 53:53/tcp -p 53:53/udp \
    -p 67:67/udp -p 68:68/udp \
    -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp \
    -d adguard/adguardhome
```

## 📝 Notas Importantes

*   **Red**: En Docker, la IP origen de las consultas a veces aparece como la IP interna del gateway de Docker (`172.x.x.1`). Para ver las IPs reales de los clientes, quizás necesites usar el modo de red `host` (`network_mode: host` en compose), pero esto solo funciona bien en Linux, no en Docker Desktop Windows/Mac.
*   **Actualizar**:
    ```bash
    docker-compose pull
    docker-compose up -d
    ```
