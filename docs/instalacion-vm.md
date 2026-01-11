# 💻 Instalación en Máquina Virtual (VM)

Si tenés una PC vieja, una notebook con pantalla rota o un servidor hogareño potente, podés virtualizar AdGuard Home.

## 📦 Opciones de Virtualización

### 1. Proxmox VE (Recomendado)
Si tenés un servidor dedicado (lab homelab).
1.  Creá un **CT (Contenedor LXC)** en lugar de una VM completa para ahorrar recursos.
2.  Template: Ubuntu 22.04 o Debian 12.
3.  Recursos: 1 Core, 512MB RAM, 4GB Disco.
4.  Red: IP Estática definida desde la config del contenedor.
5.  Entrá a la consola y ejecutá el script de instalación.

### 2. VirtualBox / VMware Workstation
Si querés correrlo en tu PC principal (Windows/Mac).
*   **Desventaja**: Tu PC tiene que estar prendida las 24hs para que haya internet en la casa.
*   **Configuración de Red**:
    *   Cambiar adaptador de red de "NAT" a **"Bridged Adapter" (Adaptador Puente)**.
    *   Esto hará que la VM tome una IP de tu router (ej: 192.168.1.50) en vez de una interna.

### 3. Notebook Vieja (Bare Metal)
Si tenés una netbook del gobierno o notebook vieja:
*   No necesitás virtualizar.
*   Instalá **Ubuntu Server** directo en el disco.
*   configurá que **NO se suspenda** cuando cerrás la tapa (`logind.conf` -> `HandleLidSwitch=ignore`).

## ⚙️ Pasos Genéricos

Cualquiera sea el método, una vez que tenés el Linux corriendo:

1.  Actualizar: `sudo apt update`
2.  Instalar Curl: `sudo apt install curl`
3.  Correr instalador:
    ```bash
    curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
    ```
