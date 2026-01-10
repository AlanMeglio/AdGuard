# Configuración de IP Estática en Ubuntu Server

Una IP estática es fundamental para que AdGuard funcione correctamente.

## Configuración con Netplan

Editar archivo:
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

Ejemplo:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 1.0.0.1
```

Aplicar:
```bash
sudo netplan apply
```

[← Volver al README principal](../README.md)
