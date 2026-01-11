# 🌐 Configuración de IP Estática

Para que AdGuard Home funcione correctamente como servidor DNS de tu red, **necesita tener una dirección fija**. Si la IP del servidor cambia (que es lo normal con DHCP dinámico), todos tus dispositivos se quedarán sin internet porque no sabrán a quién preguntarle las direcciones web.

## 🎓 Conceptos Básicos

*   **IP Privada (LAN)**: Es la dirección "interna" de tu dispositivo. Ej: `192.168.1.50`.
*   **Gateway (Puerta de Enlace)**: Es la IP de tu router. Ej: `192.168.1.1` o `192.168.0.1`.
*   **Máscara de Red (Netmask)**: Define el tamaño de tu red. Casi siempre es `255.255.255.0` o `/24`.
*   **DNS**: Quien traduce nombres (google.com) a IPs. Normalmente es tu router o Google (`8.8.8.8`). Ahora será tu servidor AdGuard.

### ⚠️ Antes de empezar: Elegí una IP libre
Elegí una IP que esté fuera del rango DHCP automático de tu router para evitar conflictos.
Una buena práctica es usar números altos, por ejemplo:
*   Si tu router es `192.168.1.1`, usá -> `192.168.1.200`
*   Si tu router es `192.168.0.1`, usá -> `192.168.0.200`
*   Si tu router es `10.0.0.1`, usá -> `10.0.0.200`

---

## 🐧 Método 1: Configurar en el Servidor (Recomendado)

### Opción A: Ubuntu Server 20.04 / 22.04 / 24.04 (Netplan)

Ubuntu Server usa **Netplan**.

1.  Averiguá el nombre de tu interfaz de red:
    ```bash
    ip a
    # Buscá algo como 'eth0', 'enp3s0', 'ens33'. Ignorá 'lo' (loopback).
    ```

2.  Entrá al directorio de configuración:
    ```bash
    cd /etc/netplan/
    ls
    # Verás un archivo .yaml, ej: 00-installer-config.yaml o 50-cloud-init.yaml
    ```

3.  Editalo con nano:
    ```bash
    sudo nano 00-installer-config.yaml
    ```

4.  Modificá el contenido con mucho cuidado con la indentación (usá espacios, no tabs):

    ```yaml
    network:
      version: 2
      ethernets:
        enp3s0:                 # <--- REEMPLAZAR con TU interfaz
          dhcp4: no
          addresses:
            - 192.168.1.200/24  # <--- TU IP estática elegida
          routes:
            - to: default
              via: 192.168.1.1  # <--- IP de tu Router (Gateway)
          nameservers:
            addresses:
              - 1.1.1.1         # DNS temporal (Cloudflare)
              - 8.8.8.8         # DNS temporal (Google)
    ```

5.  Probá la configuración (si falla, vuelve atrás automáticamente):
    ```bash
    sudo netplan try
    # Si todo va bien, apretá ENTER para confirmar.
    ```

6.  Aplicá los cambios:
    ```bash
    sudo netplan apply
    ```

### Opción B: Raspberry Pi OS / Debian (dhcpcd)

En Raspberry Pi OS o Debian clásico se suele usar `dhcpcd.conf`.

1.  Editá el archivo de configuración:
    ```bash
    sudo nano /etc/dhcpcd.conf
    ```

2.  Andá al final del archivo y agregá:

    ```bash
    interface eth0          # <--- Tu interfaz (eth0 es cable, wlan0 es wifi)
    static ip_address=192.168.1.200/24
    static routers=192.168.1.1
    static domain_name_servers=1.1.1.1 8.8.8.8
    ```

3.  Reiniciá para aplicar:
    ```bash
    sudo reboot
    ```

---

## 📡 Método 2: Reserva de IP desde el Router (DHCP Static Lease) - Alternativo

Si no querés tocar la config del servidor, podés decirle a tu router que **siempre le asigne la misma IP** a tu dispositivo (basándose en su dirección MAC).

1.  Obtené la dirección MAC de tu servidor:
    ```bash
    ip link show
    # Buscá donde dice "link/ether xx:xx:xx:xx:xx:xx"
    ```

2.  Ingresá a tu router (Ver guía [Routers Compatibles](routers-compatibles.md)).

3.  Buscá la sección **LAN** o **DHCP Server**.

4.  Buscá opción **"Static Lease"**, **"Address Reservation"** o **"Reserva de Direcciones"**.

5.  Agregá una nueva entrada:
    *   **MAC Address**: `xx:xx:xx:xx:xx:xx` (la de tu server)
    *   **IP Address**: `192.168.1.200` (la que querés)

6.  Guardá y reiniciá el servidor para que tome la nueva IP.

---

## ✅ Verificación

Después de configurar, verificá que todo esté bien:

1.  **Check IP**: `ip a` (debería mostrar la estática).
2.  **Check Internet**: `ping google.com` (debería responder).
3.  **Check Gateway**: `ping 192.168.1.1` (debería responder tu router).

## 🆘 Troubleshooting

*   **Pérdida de conexión SSH**: Si cambiaste la IP y estabas por SSH, se cortará. Conectate a la nueva IP (`ssh usuario@192.168.1.200`).
*   **"Destination Host Unreachable"**: Pusiste mal la IP del Gateway o la Máscara de red.
*   **"Temporary failure in name resolution"**: Configuraste mal los `nameservers` en el archivo. Asegurate de poner `1.1.1.1` o `8.8.8.8` hasta que AdGuard esté instalado.
      routes:
        - to: default
          via: 192.168.1.1   # IP de tu router
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

3. Aplicá los cambios:
```bash
sudo netplan apply
```

4. Verificá la IP:
```bash
ip a
```

### Método 2: Desde el Router (DHCP Reservation)

Si no querés tocar Ubuntu, podés reservar la IP desde tu router:
- Entrá al panel del router (ej: 192.168.0.1)
- Buscá "DHCP Reservation" o "Reserva de IP"
- Asigná una IP fija a la MAC del servidor