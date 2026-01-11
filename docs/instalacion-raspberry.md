# 🍓 Instalación en Raspberry Pi

La Raspberry Pi es el hogar ideal para AdGuard Home: consume poquísima energía, es silenciosa y barata. Funciona en cualquier modelo, desde la Pi Zero W hasta la Pi 5.

## 📋 Requisitos

*   Raspberry Pi (Cualquier modelo).
*   Tarjeta MicroSD (8GB o más. Recomendado: Clase 10).
*   Fuente de alimentación adecuada.
*   (Opcional) Cable Ethernet para mejor estabilidad.

## 🚀 Paso 1: Preparar el Sistema Operativo

Recomendamos usar **Raspberry Pi OS Lite** (sin interfaz gráfica) para ahorrar recursos.

1.  Descargá e instalá [Raspberry Pi Imager](https://www.raspberrypi.com/software/) en tu PC.
2.  Abrilo y elegí:
    *   **Dispositivo**: Tu modelo de Pi.
    *   **OS**: Raspberry Pi OS (other) -> **Raspberry Pi OS Lite (64-bit)** (o 32-bit si usás modelos viejos).
    *   **Almacenamiento**: Tu tarjeta SD.
3.  ⚠️ **IMPORTANTE**: Apretá el botón de engranaje (o CTRL+SHIFT+X) para configurar opciones avanzadas antes de escribir:
    *   Habilitar **SSH**: Con password o llave pública.
    *   Setear usuario y contraseña (ej: `pi` / `raspberry` - ¡Cambiá la pass!).
    *   Configurar WiFi (si no usás cable).
4.  Escribí la imagen ("Write").

## 🔌 Paso 2: Conexión Inicial

1.  Poné la SD en la Pi y enchufala.
2.  Esperá unos 2-3 minutos a que inicie.
3.  Busca la IP de la Pi en tu router o usá una app de escaneo de red en el celu (como Fing).
4.  Conectate por terminal:
    ```bash
    ssh pi@192.168.1.X
    ```

## 🛠️ Paso 3: Instalación de AdGuard

Una vez dentro de la terminal de la Pi, es igual que en cualquier Ubuntu/Debian.

1.  Actualizá el sistema:
    ```bash
    sudo apt update && sudo apt upgrade -y
    ```

2.  Configurá IP Estática (ver [Guía de IP Estática](ip-estatica.md)). **¡Fundamental!**

3.  Ejecutá nuestro script de instalación automática:
    ```bash
    curl -s -S -L https://raw.githubusercontent.com/AlanMeglio/AdGuard/main/scripts/install.sh | sudo bash
    ```
    *(Si no tenés internet para bajar este script, copiá y pegá el contenido de `install.sh` a un archivo nuevo)*.

## 💡 Tips para Raspberry Pi

*   **Temperatura**: Si usás una Pi 4 o 5, asegurate de que tenga disipadores o un fan chiquito. AdGuard no calienta mucho, pero mejor prevenir. Comprobá temperatura con `vcgencmd measure_temp`.
*   **SD Card**: Para extender la vida de tu SD, deshabilitá logs excesivos en AdGuard (Settings > General > Query logs retention: 24 hours).
