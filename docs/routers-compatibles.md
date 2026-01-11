# 📡 Guía Definitiva de Configuración de Routers (Argentina)

Esta guía te ayudará a configurar tu router para que use **AdGuard Home** como servidor DNS y bloquee publicidad en **toda tu casa**.

⚠️ **Objetivo**: Cambiar el **DNS Server** (o DNS Primario) en la configuración **DHCP** de tu router para que apunte a la IP estática de tu servidor AdGuard (ej: `192.168.1.200`).

---

## 📊 Resumen Rápido por ISP (Argentina)

| Empresa / Router | IP de Acceso Típica | Usuario Def. | Contraseña Def. | Dificultad |
| :--- | :--- | :--- | :--- | :--- |
| **Personal Flow (Fibertel)** | `192.168.0.1` | `admin` | `cisco` / `motorola` / `f4st3360` | 🔴 Alta (Suelen bloquear opción) |
| **Claro Fibra (Huawei/ZTE)** | `192.168.1.1` o `100.1` | `admin` | Ver etiqueta router | 🟡 Media |
| **Movistar Fibra (Askey/Mitrastar)**| `192.168.1.1` | `admin` | Ver etiqueta router | 🟢 Baja |
| **Telecentro (Sagemcom)** | `192.168.0.1` | `admin` | `admin` | 🔴 Alta |
| **TP-Link** | `192.168.0.1` | `admin` | `admin` | 🟢 Muy Baja |
| **Mikrotik** | `192.168.88.1` | `admin` | *(vacío)* | 🟡 Media (Técnico) |

---

## 🛠️ Tutoriales Paso a Paso

### 1. TP-Link (Genérico para routers propios)
La mayoría de los TP-Link tienen una interfaz similar.

1.  Abrí `http://192.168.0.1` o `http://tplinkwifi.net`.
2.  Ingresá usuario y contraseña (usualmente `admin` / `admin`).
3.  Andá al menú lateral izquierdo: **DHCP** > **DHCP Settings**.
4.  Buscá los campos:
    *   **Primary DNS**: Ingresá la IP de tu AdGuard (ej: `192.168.0.200`).
    *   **Secondary DNS**: ¡Dejálo vacío! O poné la misma IP del AdGuard.
    *   *(Nota: Si ponés 8.8.8.8 acá, los anuncios se filtrarán igual)*.
5.  Clic en **Save**.
6.  Reiniciá el router para que los dispositivos tomen el cambio.

### 2. Personal Flow (Ex-Fibertel) - Sagemcom / Technicolor
Estos routers suelen venir con la configuración de DNS bloqueada por el proveedor.

**Opción A: Intentar configurar**
1.  Entrá a `192.168.0.1`.
2.  Logueate (probá usuario `custadmin` o `admin` y pass `f4st3360` o lo que diga la etiqueta).
3.  Buscá la pestaña **Basic** o **LAN**.
4.  Si ves "DNS Servers", cambialos.
5.  Si están en gris (deshabilitados), pasá a la **Opción B**.

**Opción B: Desactivar DHCP (Modo Bridge falso)**
Si no te deja cambiar DNS:
1.  En el router de Flow, **DESACTIVÁ** el servidor DHCP (`DHCP Server: Disable`).
2.  En **AdGuard Home**, andá a **Settings > DHCP Settings**.
3.  Habilitá el servidor DHCP de AdGuard Home.
4.  ¡Ahora AdGuard controlará las IPs de tu red y asignará sus propios DNS!

### 3. Claro Fibra (Huawei HG8245 / ZTE)
Suelen ser más flexibles.

1.  Entrá a `192.168.1.1`.
2.  Usuario `admin`, contraseña suele ser `Claro123` o lo que diga la etiqueta (al reverso, dice "Web Password").
3.  Andá a la pestaña **LAN**. 
4.  Buscá **DHCP Server Configuration**.
5.  Donde dice **Primary DNS**, poné la IP de tu AdGuard.
6.  Clic en **Apply**.

### 4. Movistar Fibra (Router HGU)
Bastante estándar.

1.  Entrá a `192.168.1.1`.
2.  Pass está en la etiqueta abajo del equipo.
3.  Entrá al "Menú Avanzado" (generalmente un link chiquito).
4.  Andá a **Advanced Setup** > **LAN**.
5.  Buscá **DNS Server IP Address**.
6.  Desmarcá "Use IP Router as DNS" si existe.
7.  Poné tu IP de AdGuard en Primary.
8.  **Save/Apply**.

### 5. Mikrotik (RouterOS)
Para usuarios avanzados.

1.  Abrí WinBox o WebFig (`192.168.88.1`).
2.  Andá a **IP** > **DHCP Server**.
3.  Pestaña **Networks**.
4.  Doble clic en tu red (usualmente `192.168.88.0/24`).
5.  En el campo **DNS Servers**:
    *   Clic en la flecha para abajo para abrir el campo.
    *   Poné la IP de AdGuard.
    *   Asegurate de que sea la ÚNICA IP (o la primera).
6.  **OK**.

---

## 🚫 ¿Qué hago si mi ISP bloqueó el cambio de DNS?

Es muy común en Argentina (especialmente módems nuevos de Fibertel y Telecentro). Si no podés editar los DNS en la sección DHCP, tenés 3 soluciones:

1.  **Solución de Oro (Router Propio)**: Comprá un router TP-Link/Asus barato. Conectalo al módem de tu ISP. Pedí al ISP que ponga su módem en "Modo Bridge" (o simplemente conectá el tuyo al puerto LAN). Configurá todo en TU router.
2.  **Solución de Plata (DHCP de AdGuard)**: Desactivá el DHCP del router del ISP y activá el DHCP en AdGuard Home. (Requiere que el router ISP permita desactivar DHCP).
3.  **Solución de Bronce (Manual)**: Configurar el DNS manualmente en cada dispositivo (celular, PC, TV). Es tedioso pero funciona.

## ✅ ¿Cómo verificar que funciona?

1.  En tu PC/Celular, desconectá y reconectá el WiFi (para renovar la IP).
2.  Ingresá al panel de AdGuard Home (`http://tu-ip:3000`).
3.  Andá al **Dashboard**.
4.  Navegá un poco por internet en tu celular.
5.  Deberías ver que el contador de "DNS Queries" empieza a subir. ¡Estás conectado!
