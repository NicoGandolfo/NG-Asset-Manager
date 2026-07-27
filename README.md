# NG Asset Manager

Herramienta desarrollada en PowerShell para la gestión de activos TI, permitiendo registrar cambios, entregas y devoluciones de equipos de forma rápida y automatizada.

---

## 🚀 Características

- Registro de cambios de equipos
- Registro de entregas
- Registro de devoluciones
- Historial de movimientos
- Búsqueda por colaborador
- Búsqueda por hostname
- Búsqueda por número de serie
- Eliminación lógica de registros
- Generación automática de correos (Outlook Web)
- Exportación a CSV y TXT
- Versión ejecutable (.exe)

---

## 🛠️ Tecnologías

- PowerShell
- CSV
- Outlook Web
- PS2EXE

---

## 📦 Instalación

1. Descargar el archivo `.exe`
2. Ejecutar el programa
3. Completar los datos solicitados

---

## ⚙️ Configuración

Antes de usar la herramienta, configure los correos según su organización dentro del script:

```powershell
$para = "destinatario@empresa.com"
$cc = "soporte@empresa.com"
```

---

## 📁 Estructura

```
Datos/
    Cambios.csv
    Cambios.txt
```

---

## 🎯 Objetivo del proyecto

Durante mi trabajo en soporte TI detecté que el registro de cambios de equipos y la generación de correos era un proceso repetitivo y manual.

Esta herramienta fue desarrollada para automatizar ese proceso, reducir errores y ahorrar tiempo en tareas operativas.

---

## 👨‍💻 Autor

Nicolás Gandolfo

---

## 📄 Licencia

MIT License