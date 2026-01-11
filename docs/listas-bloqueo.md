# ⛔ Listas de Bloqueo (Blocklists)

El poder de AdGuard Home reside en sus listas. Por defecto viene con "AdGuard DNS filter", que es muy buena, pero podés agregar más para bloquear estafas, porno, tracking agresivo, etc.

## 🇦🇷 Listas Básicas (Recomendadas)

Estas suelen ser seguras (pocos falsos positivos).

1.  **AdGuard DNS filter** (Default)
    *   Bloquea ads generales y rastreadores.
2.  **AdAway Default Blocklist**
    *   URL: `https://adaway.org/hosts.txt`
    *   Clásica de Android, muy efectiva.

## 🛡️ Seguridad y Malware

Para proteger a la familia de sitios peligrosos.

*   **OISD Big** (La mejor "Set and Forget")
    *   URL: `https://big.oisd.nl`
    *   Incluye ads, malware, phishing. Muy mantenida.
*   **The Big List of Hacked Malware Web Sites**
    *   URL: `https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hosts`

## 🔞 Control Parental (Adultos)

Si querés bloquear contenido para adultos en toda la red.

*   **StevenBlack Adult**
    *   URL: `https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts`

## ⚠️ Cuidado con agregar de más

*   **Más no es mejor**: Agregar 50 listas va a ralentizar tu DNS y vas a romper sitios legítimos (falsos positivos).
*   **Whitelist**: Si agregás listas agresivas, preparate para usar la [Whitelist](../examples/whitelist-common.txt) cuando tu pareja te grite que no anda Instagram.
