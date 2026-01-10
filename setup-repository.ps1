# Script de Setup del Repositorio AdGuard para Windows
# Autor: Alan Meglio

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "║        Setup del Repositorio AdGuard              ║" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar que existe README.md
if (-not (Test-Path "README.md")) {
    Write-Host "[ERROR] No se encontró README.md en el directorio actual" -ForegroundColor Red
    Write-Host "Ejecutá este script desde la raíz del repositorio AdGuard" -ForegroundColor Red
    exit 1
}

Write-Host "[✓] README.md encontrado (no se modificará)`n" -ForegroundColor Green

# Función para crear archivo
function Create-File {
    param (
        [string]$FilePath,
        [string]$Content
    )
    
    if (Test-Path $FilePath) {
        Write-Host "[SKIP] $FilePath ya existe" -ForegroundColor Yellow
    } else {
        $Content | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "[OK] Creado: $FilePath" -ForegroundColor Green
    }
}

# Crear estructura de carpetas
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "[1/4] Creando estructura de carpetas..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "docs" | Out-Null
New-Item -ItemType Directory -Force -Path "scripts" | Out-Null
New-Item -ItemType Directory -Force -Path ".github" | Out-Null

Write-Host "[OK] Carpeta: docs/" -ForegroundColor Green
Write-Host "[OK] Carpeta: scripts/" -ForegroundColor Green
Write-Host "[OK] Carpeta: .github/" -ForegroundColor Green

# Crear archivos en /docs
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "[2/4] Creando archivos en /docs..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$ipEstatica = @"
# Configuración de IP Estática en Ubuntu Server

Una IP estática es **fundamental** para que AdGuard funcione correctamente.

## 🎯 ¿Por qué necesito una IP estática?

Si tu servidor cambia de IP cada vez que se reinicia, los dispositivos perderían acceso al DNS.

## 🔧 Configuración con Netplan

``````bash
sudo nano /etc/netplan/00-installer-config.yaml
``````

Ejemplo de configuración:

``````yaml
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
``````

Aplicar cambios:

``````bash
sudo netplan apply
``````

[← Volver al README principal](../README.md)
"@

Create-File "docs\ip-estatica.md" $ipEstatica

$routersCompatibles = @"
# Routers Compatibles con AdGuard Home

Configuración para routers comunes en Argentina.

## 🇦🇷 TP-Link (Archer C6, C7, C9)

**Acceso:** http://192.168.0.1  
**Usuario:** admin  
**Contraseña:** admin

**Pasos:**
1. Advanced → Network → DHCP Server
2. Primary DNS: IP de tu servidor AdGuard
3. Secondary DNS: vacío o misma IP
4. Guardar y reiniciar

✅ **Compatible**

## 🇦🇷 Movistar

**Acceso:** http://192.168.1.1  

**Pasos:**
1. Application → DHCP
2. DNS Primary: IP de AdGuard
3. DNS Secondary: vacío
4. Apply

⚠️ Algunos modelos vienen bloqueados.

[← Volver al README principal](../README.md)
"@

Create-File "docs\routers-compatibles.md" $routersCompatibles

$comparison = @"
# AdGuard Home vs Pi-hole

## 🎯 Comparación Rápida

| Característica | AdGuard Home | Pi-hole |
|----------------|--------------|---------|
| **Lenguaje** | Go | PHP + C |
| **RAM** | ~100-150MB | ~50-100MB |
| **Interfaz** | Moderna | Clásica |
| **DNS Encriptado** | ✅ Nativo | ⚠️ Con plugins |

## 🏁 Conclusión

**Nuevos usuarios:** AdGuard Home (más fácil)  
**Avanzados:** Pi-hole (más control)

[← Volver al README principal](../README.md)
"@

Create-File "docs\adguard-vs-pihole.md" $comparison

# Crear archivos en /scripts
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "[3/4] Creando archivos en /scripts..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$installScript = @"
#!/bin/bash
# Script de instalación de AdGuard Home

echo "Instalando AdGuard Home..."
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
"@

Create-File "scripts\install.sh" $installScript

$backupScript = @"
#!/bin/bash
# Script de backup de AdGuard Home

BACKUP_DIR="`$HOME/adguard-backups"
DATE=`$(date +%Y%m%d_%H%M%S)

mkdir -p "`$BACKUP_DIR"
echo "Creando backup..."
sudo systemctl stop AdGuardHome
sudo tar -czf "`$BACKUP_DIR/adguard_backup_`$DATE.tar.gz" -C /opt/AdGuardHome AdGuardHome.yaml data/
sudo systemctl start AdGuardHome
echo "Backup completado: `$BACKUP_DIR/adguard_backup_`$DATE.tar.gz"
"@

Create-File "scripts\backup.sh" $backupScript

$updateScript = @"
#!/bin/bash
# Script de actualización de AdGuard Home

echo "Actualizando AdGuard Home..."
sudo systemctl stop AdGuardHome
sudo /opt/AdGuardHome/AdGuardHome --update
sudo systemctl start AdGuardHome
echo "Actualización completada"
"@

Create-File "scripts\update.sh" $updateScript

$scriptsReadme = @"
# Scripts de Automatización

Scripts útiles para AdGuard Home.

## 📜 Disponibles

- **install.sh**: Instalación automática
- **backup.sh**: Backup de configuración  
- **update.sh**: Actualización automática

## 🚀 Uso

``````bash
chmod +x *.sh
bash install.sh
``````

[← Volver al README principal](../README.md)
"@

Create-File "scripts\README.md" $scriptsReadme

# Crear archivos en /.github
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "[4/4] Creando archivos en /.github..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$issueTemplate = @"
---
name: Reporte de Problema
about: Reportá un bug o problema
---

## 📋 Descripción del Problema

## 🔄 Pasos para Reproducir

1. 
2. 
3. 

## 🖥️ Información del Sistema

**Sistema Operativo:**  
**Versión de AdGuard:**  
**Hardware:**

## ✔️ Checklist

- [ ] Revisé troubleshooting
- [ ] Verifiqué firewall
- [ ] Reinicié AdGuard
"@

Create-File ".github\ISSUE_TEMPLATE.md" $issueTemplate

$prTemplate = @"
## 📝 Descripción

## 🎯 Tipo de Cambio

- [ ] 🐛 Bug fix
- [ ] ✨ Nueva característica
- [ ] 📚 Documentación
- [ ] 🌐 Router nuevo

## ✅ Checklist

- [ ] Probé mis cambios
- [ ] Actualicé documentación
- [ ] Sigo el estilo del proyecto
"@

Create-File ".github\PULL_REQUEST_TEMPLATE.md" $prTemplate

# CONTRIBUTING.md
$contributing = @"
# Guía de Contribución

¡Gracias por considerar contribuir! 🎉

## 🤝 Cómo Contribuir

### Reportar Bugs
1. Verificá que no exista un issue similar
2. Usá el template de issue
3. Incluí toda la información

### Pull Requests
1. Fork del repositorio
2. Creá rama: ``git checkout -b feature/nombre``
3. Commit: ``git commit -m "feat: descripción"``
4. Push: ``git push origin feature/nombre``
5. Abrí Pull Request

## 📋 Estándares

- Comentá tu código
- Probá antes de hacer PR
- Mantené el estilo existente

**¡Gracias por contribuir!** 🚀
"@

Create-File "CONTRIBUTING.md" $contributing

# Resumen final
Write-Host "`n╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                   ║" -ForegroundColor Green
Write-Host "║        ¡Setup completado exitosamente!           ║" -ForegroundColor Green
Write-Host "║                                                   ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "       ARCHIVOS CREADOS:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Write-Host "Documentación (docs/):" -ForegroundColor Green
Write-Host "  - ip-estatica.md"
Write-Host "  - routers-compatibles.md"
Write-Host "  - adguard-vs-pihole.md"

Write-Host "`nScripts (scripts/):" -ForegroundColor Green
Write-Host "  - install.sh"
Write-Host "  - backup.sh"
Write-Host "  - update.sh"
Write-Host "  - README.md"

Write-Host "`nGitHub (.github/):" -ForegroundColor Green
Write-Host "  - ISSUE_TEMPLATE.md"
Write-Host "  - PULL_REQUEST_TEMPLATE.md"

Write-Host "`nRaíz:" -ForegroundColor Green
Write-Host "  - CONTRIBUTING.md"
Write-Host "  - README.md (sin modificar ✓)"

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "       PRÓXIMOS PASOS:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Write-Host "1. Revisá los archivos creados" -ForegroundColor Green
Write-Host "2. Hacé commit:" -ForegroundColor Green
Write-Host "   git add ." -ForegroundColor Yellow
Write-Host '   git commit -m "docs: agregar estructura completa"' -ForegroundColor Yellow
Write-Host "   git push origin main" -ForegroundColor Yellow

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan