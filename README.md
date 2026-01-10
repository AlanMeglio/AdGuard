AdGuard Home en Hardware Reciclado: Tu Propio DNS Sinkhole
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Transformá esa notebook vieja en un escudo de privacidad para toda tu red.

Este proyecto nace de la idea de costo cero y reciclaje tecnológico. En lugar de comprar hardware nuevo, reutilizamos una notebook en desuso (o una Máquina Virtual) para montar un servidor DNS local que bloquea publicidad y rastreadores en todos los dispositivos de la casa (Smart TV, celulares, consolas, PC) sin instalar software en cada uno.

¿Por qué hacer esto?

-Bloqueo a nivel de red: Elimina anuncios en apps y webs antes de que lleguen a tus dispositivos.

-Privacidad: Tus consultas DNS no pasan por Google o tu ISP; vos tenés el control.

-Ahorro de ancho de banda: Al no descargar la publicidad, las páginas cargan más rápido.

-Hardware Reciclado: Dale una segunda vida a equipos antiguos (consume muy pocos recursos).



<img width="979" height="512" alt="1-neofetch" src="https://github.com/user-attachments/assets/a6814d32-0c78-4112-a071-1c0e958cb29f" />


 El servidor corriendo en Ubuntu Server con recursos mínimos.

Requisitos
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Hardware: Notebook, PC antigua o Máquina Virtual (1vCPU y 512MB RAM sobran).

Conexión: Preferentemente por cable Ethernet (RJ45) al router para menor latencia.

Sistema Operativo: Ubuntu Server (LTS) o cualquier distro Linux.

Instalación Paso a Paso

Preparación del Sistema Se recomienda instalar Ubuntu Server en modo headless (sin interfaz gráfica) para maximizar recursos. Una vez instalado, asegurate de tener una IP Estática en el servidor.

Instalación de AdGuard Home Usamos el script de instalación automatizada oficial. Ejecutá este comando en tu terminal:

curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v


<img width="1115" height="628" alt="2-install" src="https://github.com/user-attachments/assets/05521794-ca77-4ea7-85f0-48c67e2dfb77" />


Script de instalación finalizado mostrando IP y puertos.

Configuración Inicial Una vez instalado:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
abrí el navegador en tu PC principal e ingresá a: http://[IP-DE-TU-SERVIDOR]:3000

Seguí el asistente de configuración:

Puerto de administración: 80 o 3000.

Puerto DNS: 53 (Obligatorio).


<img width="1281" height="958" alt="3-dashboard" src="https://github.com/user-attachments/assets/610ca5a4-6b95-4d89-9d4a-df6eaaea0d55" />


Panel de control principal bloqueando rastreadores.

Configuración del Router Para que funcione en toda la casa, tenés que configurar tu router para que use tu servidor como DNS.

Entrá a la configuración de tu router (generalmente 192.168.0.1 o 192.168.1.1).

Buscá la sección DHCP o LAN Settings.

En DNS Primario (DNS 1): Poné la IP estática de tu servidor AdGuard.

En DNS Secundario (DNS 2): DEJAR VACÍO o poner la misma IP del servidor. (Nota: Si ponés 8.8.8.8 como secundario, los dispositivos saltarán el bloqueo).

Solución de Problemas (Troubleshooting)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Veo publicidad en mi celular Android Android tiene una función llamada "DNS Privado" que ignora tu red local.

Solución: Andá a Ajustes > Conexión y compartir > DNS Privado y ponelo en DESACTIVADO.

Instagram o Apps se congelan un momento A veces se bloquean dominios necesarios para la carga inicial (Falsos Positivos).

Solución: Si notás lag en Instagram, agregá esta regla en Filtros > Reglas personalizadas: @@||graph.instagram.com^

Internet anda lento en algunos sitios Puede ser un conflicto con la resolución IPv6 de tu proveedor.

Solución: En AdGuard, andá a Configuración > Configuración DNS y activá "Deshabilitar la resolución de direcciones IPv6".

Créditos y Referencias:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Software: AdGuard Home, desarrollado por AdGuard Team.

Guía de implementación: Realizada por Alan Meglio con fines educativos.

Si tenés dudas sobre esta implementación, ¡no dudes en abrir un Issue!
