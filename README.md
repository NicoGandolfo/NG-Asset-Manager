# NG Asset Manager

Herramienta desarrollada en PowerShell para registrar, consultar y gestionar movimientos de activos tecnológicos dentro de una organización.

Permite documentar entregas, devoluciones y cambios de equipos, mantener un historial local y generar correos para Outlook Web a partir de la información registrada.

---

## Características

- Registro de entregas de equipos.
- Registro de devoluciones de equipos.
- Registro de cambios de equipos.
- Historial local de movimientos.
- Búsqueda por nombre del colaborador.
- Búsqueda por hostname.
- Búsqueda por número de serie.
- Eliminación lógica de registros.
- Exportación automática a CSV.
- Exportación automática a TXT.
- Generación de correos para Outlook Web.
- Configuración externa mediante JSON.
- Creación automática de carpetas y archivos necesarios.
- Validación del archivo de configuración.
- Compatibilidad con ejecución desde PowerShell y conversión a `.exe`.

---

## Tecnologías utilizadas

- PowerShell
- Objetos `PSCustomObject`
- Archivos CSV
- Archivos TXT
- JSON
- Outlook Web
- PS2EXE

---

## Estructura del proyecto

```text
NG-Asset-Manager/
│
├── Config/
│   └── config.json
│
├── Datos/
│   ├── Cambios.csv
│   └── Cambios.txt
│
├── NG Asset Manager.ps1
├── README.md
├── CHANGELOG.md
├── LICENSE
└── .gitignore
```

Las carpetas `Config` y `Datos` pueden ser creadas automáticamente por la aplicación durante su primera ejecución.

Los archivos de configuración y datos locales están excluidos del repositorio mediante `.gitignore`.

---

## Requisitos

Para ejecutar el código fuente se necesita:

- Windows 10 o Windows 11.
- Windows PowerShell 5.1 o PowerShell 7.
- Acceso a Outlook Web para utilizar la generación de correos.

No se requiere una base de datos ni la instalación de módulos adicionales para ejecutar el script.

---

## Ejecución desde PowerShell

1. Descargue o clone el repositorio.
2. Abra la carpeta del proyecto.
3. Ejecute el archivo:

```text
NG Asset Manager.ps1
```

También puede ejecutarlo desde PowerShell:

```powershell
& ".\NG Asset Manager.ps1"
```

Dependiendo de la política de ejecución configurada en Windows, puede ser necesario iniciar PowerShell con:

```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\NG Asset Manager.ps1"
```

> Utilice `ExecutionPolicy Bypass` únicamente para ejecutar una copia del proyecto obtenida desde una fuente confiable.

---

## Configuración

Durante la primera ejecución, la aplicación crea automáticamente el archivo:

```text
Config/config.json
```

El archivo contiene los destinatarios utilizados por la función de generación de correos:

```json
{
  "Correo": {
    "Para": "destinatario1@empresa.com;destinatario2@empresa.com",
    "CC": "soporte@empresa.com;supervisor@empresa.com"
  }
}
```

Antes de generar un correo, reemplace los valores de ejemplo por las direcciones correspondientes a su organización.

Por ejemplo:

```json
{
  "Correo": {
    "Para": "soporte.ti@organizacion.com",
    "CC": "supervisor.ti@organizacion.com"
  }
}
```

Para configurar varios destinatarios, sepárelos mediante punto y coma:

```json
{
  "Correo": {
    "Para": "destinatario1@organizacion.com;destinatario2@organizacion.com",
    "CC": "supervisor@organizacion.com"
  }
}
```

El archivo `config.json` no se incluye en el repositorio para evitar publicar configuraciones locales o información perteneciente a una organización.

---

## Datos generados

Los movimientos registrados se almacenan localmente dentro de la carpeta:

```text
Datos/
```

La aplicación utiliza dos archivos:

```text
Cambios.csv
Cambios.txt
```

### `Cambios.csv`

Contiene los registros en un formato estructurado que puede abrirse con:

- Microsoft Excel.
- LibreOffice Calc.
- PowerShell.
- Herramientas de análisis de datos.

### `Cambios.txt`

Contiene una representación legible de los movimientos registrados.

Estos archivos no se incluyen en el repositorio porque pueden contener información de colaboradores y activos tecnológicos.

---

## Tipos de movimientos

### Entrega

Registra la asignación de un equipo a un colaborador.

Puede incluir información como:

- Nombre del colaborador.
- Correo.
- Hostname.
- Número de serie.
- Procesador.
- Memoria RAM.
- Disco.
- Activo fijo.

### Devolución

Registra la devolución de un equipo previamente asignado.

### Cambio

Registra la entrega de un nuevo equipo y la devolución del equipo anterior dentro de una misma operación.

---

## Búsqueda de registros

La herramienta permite consultar el historial utilizando:

- Nombre del colaborador.
- Hostname.
- Número de serie.

Los registros marcados como eliminados no aparecen en las búsquedas normales ni en la visualización del historial.

---

## Eliminación lógica

La aplicación utiliza eliminación lógica para conservar la integridad del historial.

En lugar de borrar permanentemente una entrada, el registro cambia su estado a:

```text
ELIMINADO
```

Los registros activos mantienen el estado:

```text
ACTIVO
```

Esto permite conservar la información original dentro del archivo CSV sin mostrar los registros eliminados durante el uso normal de la herramienta.

---

## Generación de correos

La herramienta puede generar correos relacionados con:

- Entregas.
- Devoluciones.
- Cambios de equipos.

El proceso funciona de la siguiente manera:

1. La aplicación genera el asunto y el cuerpo del mensaje.
2. Abre una ventana de redacción en Outlook Web.
3. Copia el cuerpo del correo al portapapeles.
4. Permite copiar posteriormente los destinatarios en copia.
5. El usuario revisa y envía el mensaje manualmente.

La aplicación no envía correos automáticamente.

---

## Versión ejecutable

El script puede convertirse en un ejecutable mediante el módulo PS2EXE:

```powershell
Install-Module ps2exe -Scope CurrentUser
```

Ejemplo de compilación:

```powershell
Invoke-PS2EXE `
    -InputFile ".\NG Asset Manager.ps1" `
    -OutputFile ".\NG Asset Manager.exe"
```

El archivo `.exe` no se almacena directamente en el repositorio.

Las versiones ejecutables oficiales pueden publicarse como archivos adjuntos dentro de la sección **Releases** de GitHub.

---

## Seguridad y privacidad

Este repositorio no debe contener:

- Correos corporativos reales.
- Nombres de colaboradores.
- Hostnames internos.
- Números de serie reales.
- Números de activo fijo.
- Archivos CSV o TXT generados durante el uso.
- Configuraciones internas de una organización.

Antes de publicar modificaciones o contribuciones, revise que no existan datos sensibles dentro del código, documentación o capturas de pantalla.

---

## Limitaciones actuales

- La información se almacena localmente y no utiliza una base de datos.
- No existe sincronización entre diferentes computadores.
- La herramienta está orientada principalmente a entornos Windows.
- La generación de correos depende de Outlook Web.
- El cuerpo y los destinatarios deben revisarse manualmente antes del envío.
- La interfaz actual funciona mediante consola.

---

## Posibles mejoras futuras

- Interfaz gráfica.
- Panel con tabla de registros.
- Exportación de reportes.
- Sistema de configuración ampliado.
- Validación avanzada de correos.
- Gestión de diferentes organizaciones.
- Base de datos local.
- Instalador para Windows.
- Registro de auditoría.
- Sistema de actualizaciones.

---

## Objetivo del proyecto

Este proyecto fue creado para automatizar una tarea frecuente dentro del soporte TI: registrar movimientos de equipos y preparar la comunicación asociada.

También forma parte de mi aprendizaje práctico de PowerShell, automatización, organización de proyectos y control de versiones con Git y GitHub.

---

## Changelog

Los cambios realizados en cada versión se encuentran documentados en:

```text
CHANGELOG.md
```

---

## Licencia

Este proyecto se distribuye bajo la licencia MIT.

Consulte el archivo:

```text
LICENSE
```

para obtener más información.

---

## Autor

**Nicolas Gandolfo**

Técnico en Conectividad y Redes, enfocado en soporte TI, automatización y administración de entornos Windows.

GitHub: [NicoGandolfo](https://github.com/NicoGandolfo)