# ⚔️ AdGuard Home vs Pi-hole: ¿Cuál elegir?

Si estás acá es porque seguramente escuchaste hablar de **Pi-hole**, el rey indiscutido del bloqueo de anuncios durante años. Pero este proyecto usa **AdGuard Home**. ¿Por qué?

Acá te contamos las diferencias clave para que entiendas la decisión, explicadas en criollo.

## 📊 Comparativa Rápida

| Característica | 🛡️ AdGuard Home | 🥧 Pi-hole |
| :--- | :--- | :--- |
| **Instalación** | **Muy simple** (un solo binario) | **Simple** (script `curl | bash`) |
| **Lenguaje** | Go (Compilado, rápido) | C + PHP + Python (web server aparte) |
| **Interfaz Web** | Moderna, rápida, todo en uno | Clásica, funcional, requiere `lighttpd`/`apache` |
| **DNS Encriptado**| ✅ **Nativo** (DoH/DoT en un click) | ❌ Requiere `cloudflared` o setup extra |
| **Control Parental**| ✅ Nativo (botón ON/OFF) | ❌ Requiere listas manuales |
| **Bloqueo Servicios**| ✅ Click para bloquear WhatsApp/TikTok | ❌ Requiere buscar dominios manuales |
| **Dependencias** | Ninguna (self-contained) | Varias (FTL, lighttpd, php) |

---

## 🔍 Análisis en Profundidad

### 1. Instalación y Mantenimiento
**AdGuard Home** es un solo archivo ejecutable. Lo bajás, lo corrés y chau. No necesita instalar PHP, ni configurar un servidor web como Apache o Nginx aparte. Esto lo hace **mucho más estable** en actualizaciones. Si actualizás Ubuntu, AdGuard no se rompe. Pi-hole a veces sufre cuando actualizás la versión de PHP.

### 2. DNS sobre HTTPS (DoH) y DoT
Esta es la **"killer feature"** por la que elegimos AdGuard.
*   **AdGuard Home**: Te permite configurar DNS encriptados (como Cloudflare o Google seguros) directo desde la interfaz gráfica.
*   **Pi-hole**: Para hacer lo mismo, tenés que instalar cosas extra (como `cloudflared`) y configurarlas por terminal. Un dolor de cabeza si recién arrancás.

### 3. Interfaz y Experiencia de Usuario
AdGuard se siente más moderno. Tiene un botón para "Bloquear Servicios" donde podés cortar el acceso a **TikTok, Facebook, WhatsApp, Steam, etc.** con un solo click. Ideal para control parental ("¡A dormir, sin TikTok!"). En Pi-hole tenés que buscar las listas de dominios manualmente.

### 4. Rendimiento
Pi-hole es extremadamente ligero y eficiente (escrito en C). AdGuard (en Go) usa un poquito más de RAM (quizás 20-30MB más), pero en cualquier hardware de los últimos 10 años (o una Raspberry Pi Zero) vuelan los dos. No es un factor decisivo hoy en día.

---

## 🏆 Veredicto: ¿Por qué usamos AdGuard Home?

Elegimos **AdGuard Home** para este tutorial porque:

1.  **Es más fácil para principiantes**: Menos cosas que se pueden romper en la instalación.
2.  **Todo incluido**: No necesitás aprender a configurar servidores web.
3.  **Seguridad**: Configurar DNS seguro (evitando que tu ISP espíe tus consultas) es trivial.
4.  **Control Parental**: Es mucho más potente si tenés chicos en casa.

**¿Cuándo usar Pi-hole?**
*   Si sos un purista del Open Source (AdGuard tiene partes open source pero la empresa es comercial).
*   Si te gusta la interfaz clásica y los gráficos de estadísticas detallados (son muy lindos los de Pi-hole).
*   Si tenés un hardware extremadamente limitado (ej: Raspberry Pi 1 original) donde cada MB de RAM cuenta.

[← Volver al README principal](../README.md)
