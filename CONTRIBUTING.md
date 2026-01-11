# Guía de Contribución para AdGuard Home en Hardware Reciclado 👋

¡Hola! Gracias por interesarte en mejorar este proyecto de AdGuard Home en Hardware Reciclado. Como se trata de un proyecto educativo y abierto, cualquier ayuda es súper bienvenida, sea grande o chica.

Este documento es una guía para que sepas cómo contribuir de la mejor manera. Queremos que te sientas cómodo/a colaborando con nosotros.

## 🤝 Código de Conducta

Este proyecto y todos los que participan en él se rigen por nuestro [Código de Conducta](CODE_OF_CONDUCT.md). Al participar, se espera que mantengas un ambiente respetuoso y acogedor para todos. Por favor, leelo antes de empezar.

## 💡 ¿Cómo podés contribuir?

Hay muchas formas de ayudar, no hace falta que seas un experto en Bash o redes:

*   **Mejorar la documentación**: Si encontrás errores de ortografía, pasos que no están claros, o querés agregar más explicaciones, ¡metele para adelante!
*   **Configuraciones de Routers**: Si tenés un router (especialmente de proveedores de Argentina como Personal, Claro, Movistar, Telecentro, etc.) que no está en la lista, podés sumar tu guía de configuración.
*   **Scripts**: ¿Tenés scripts útiles para automatizar tareas relacionadas con AdGuard? Compartilos en la carpeta `scripts/`.
*   **Reportar Bugs**: Si algo no funciona como debería, avisanos creando un Issue.
*   **Traducciones**: Si bien el foco es español, traducciones a otros idiomas son bienvenidas.
*   **Capturas de Pantalla**: Imágenes claras del proceso ayudan mucho a los principiantes.

## 🚀 Guía paso a paso para hacer un Pull Request (PR)

Si ya tenés listo lo que querés aportar, seguí estos pasos:

1.  **Hacé un Fork** del repositorio a tu cuenta de GitHub.
2.  **Cloná el repositorio** a tu compu:
    ```bash
    git clone https://github.com/TU_USUARIO/AdGuard.git
    cd AdGuard
    ```
3.  **Creá una rama (branch)** nueva para tus cambios. Usá un nombre descriptivo:
    ```bash
    git checkout -b feature/nueva-config-fibertel
    # o
    git checkout -b fix/error-script-install
    ```
4.  **Hacé tus cambios**.
5.  **Subí los cambios (commit & push)**:
    ```bash
    git add .
    git commit -m "Agrega configuración para router Sagemcom FAST"
    git push origin feature/nueva-config-fibertel
    ```
6.  **Abrí un Pull Request**: Andá a tu fork en GitHub y verás un botón para crear el PR. Llená el formulario siguiendo la plantilla.

## 📝 Estándares de Código y Documentación

Para mantener el proyecto ordenado:

### Scripts Bash
*   Usar `src/shellcheck` si es posible para validar.
*   Incluir comentarios explicativos (en español) sobre qué hace cada bloque importante.
*   Usar nombres de variables descriptivos en inglés o español, pero sé consistente (ej: `install_dir` o `directorio_instalacion`).

### Markdown
*   Usar encabezados (`#`) correctamente jerarquizados.
*   Mantener el tono amigable y usar "vos".
*   Si agregás imágenes, usá textos alternativos descriptivos.

## 🔍 Proceso de Revisión

Cuando abras un PR, lo revisaremos lo antes posible.
*   Si todo está bien, lo aprobaremos y mergearemos.
*   Si hay cosas para mejorar, te dejaremos comentarios constructivos. No te lo tomes a mal, ¡es parte del proceso de aprendizaje!

## 🐛 Cómo reportar Bugs

Usá la pestaña de **Issues** y seleccioná el template de "Bug report".
*   Sé específico: ¿Qué pasó? ¿Qué esperabas que pasara?
*   Incluí logs si tenés.
*   Mencioná qué hardware y sistema operativo estás usando.

## ✨ Cómo sugerir nuevas funcionalidades

Si tenés una idea genial, abrí un **Issue** con el template de "Feature request".
*   Explicanos el problema que querés resolver.
*   Contanos tu idea de solución.

## 💻 Configuración del entorno de desarrollo local

Para probar los scripts, lo ideal es usar una máquina virtual (VirtualBox, VMware) con Ubuntu Server, o una Raspberry Pi de pruebas. **No pruebes scripts en desarrollo en tu servidor de producción o red principal si no estás seguro de lo que hacen.**

## 🐣 Good First Issues

Si sos nuevo/a en GitHub o en Open Source, buscá los issues etiquetados como `good first issue`. Son tareas más sencillas ideales para arrancar.

¡Gracias por sumarte! 🧉
