#region CONFIGURACION
#=========================================================
# REGISTRO DE CAMBIOS DE EQUIPOS v1.0
# Nicolas Gandolfo
#=========================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "Registro de Equipos v1.0"

# UTF8
chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

#---------------------------------------------------------
# RUTAS
#---------------------------------------------------------

$rutaBase = [System.AppDomain]::CurrentDomain.BaseDirectory

#========================
# CONFIGURACIÓN
#========================

$rutaConfig = Join-Path $rutaBase "Config\config.json"
$carpetaConfig = Split-Path -Parent $rutaConfig

# Crear carpeta Config si no existe
if (!(Test-Path $carpetaConfig)) {
    New-Item -Path $carpetaConfig -ItemType Directory -Force | Out-Null
}

# Crear config.json con valores predeterminados si no existe
if (!(Test-Path $rutaConfig)) {

    $configPredeterminada = @{
        Correo = @{
            Para = "destinatario1@empresa.com;destinatario2@empresa.com"
            CC   = "soporte@empresa.com;supervisor@empresa.com"
        }
    }

    $configPredeterminada |
        ConvertTo-Json -Depth 5 |
        Set-Content -Path $rutaConfig -Encoding UTF8

    Write-Host ""
    Write-Host "Se creó el archivo de configuración:" -ForegroundColor Yellow
    Write-Host $rutaConfig -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Edite los destinatarios antes de generar correos." -ForegroundColor Yellow
    Write-Host ""

    Esperar
}

# Cargar configuración
try {
    $config = Get-Content -Path $rutaConfig -Raw -Encoding UTF8 |
        ConvertFrom-Json
}
catch {
    Write-Host ""
    Write-Host "No fue posible leer el archivo config.json." -ForegroundColor Red
    Write-Host "Revise que el formato JSON sea válido." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Detalle: $($_.Exception.Message)" -ForegroundColor DarkGray

    Esperar
    exit
}

$config = Get-Content $rutaConfig -Raw | ConvertFrom-Json

$carpetaDatos = Join-Path $rutaBase "Datos"

if (!(Test-Path $carpetaDatos)) {
    New-Item -ItemType Directory -Path $carpetaDatos | Out-Null
}

$archivoCSV = Join-Path $carpetaDatos "Cambios.csv"
$archivoTXT = Join-Path $carpetaDatos "Cambios.txt"

#---------------------------------------------------------
# CREAR ARCHIVOS
#---------------------------------------------------------

if (!(Test-Path $archivoCSV)) {

    "" | Out-File $archivoCSV -Encoding UTF8
    Remove-Item $archivoCSV

}

if (!(Test-Path $archivoTXT)) {

    New-Item $archivoTXT -ItemType File | Out-Null

}
#endregion

#region VARIABLES

#endregion

#region FUNCIONES GENERALES
function Mostrar-Titulo($Titulo){

    Clear-Host

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor DarkCyan
    Write-Host (" {0}" -f $Titulo) -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor DarkCyan
    Write-Host ""

}

function Esperar{

    Write-Host ""
    Read-Host "Presione ENTER para continuar"

}

function Pedir-Dato($Mensaje){

    do{

        $valor=Read-Host $Mensaje

        if([string]::IsNullOrWhiteSpace($valor)){

            Write-Host ""
            Write-Host "El campo no puede quedar vacio." -ForegroundColor Red
            Write-Host ""

        }

    }while([string]::IsNullOrWhiteSpace($valor))

    return $valor.Trim()

}

function Obtener-ID{

    if(Test-Path $archivoCSV){

        try{

            $cantidad=(Import-Csv $archivoCSV).Count

        }

        catch{

            $cantidad=0

        }

    }

    else{

        $cantidad=0

    }

    return ("CHG-{0:d6}" -f ($cantidad+1))

}

function Obtener-Fecha{

    return Get-Date -Format "dd/MM/yyyy HH:mm"

}

function Registrar-Cambio {

    Mostrar-Titulo "NUEVO CAMBIO DE EQUIPO"
	Write-Host "Seleccione tipo de operacion:" -ForegroundColor Yellow
	Write-Host "1. Cambio de equipo"
	Write-Host "2. Entrega (nuevo)"
	Write-Host "3. Devolucion"
	$tipoOp = Read-Host "Opcion"
	
	switch($tipoOp){

    "1"{ $Tipo = "CAMBIO" }
    "2"{ $Tipo = "ENTREGA" }
    "3"{ $Tipo = "DEVOLUCION" }

    default{

        Write-Host "Opcion invalida" -ForegroundColor Red
        Esperar
        return
    }
	
	
}
	
    $ID = Obtener-ID
    $Fecha = Obtener-Fecha

    Write-Host "ID generado: $ID" -ForegroundColor Yellow
    Write-Host ""

    #====================================================
    # COLABORADOR
    #====================================================

    Write-Host "===== COLABORADOR =====" -ForegroundColor Cyan

    $Nombre = Pedir-Dato "Nombre"
    $Correo = Pedir-Dato "Correo"

    #====================================================
    # EQUIPO NUEVO
    #====================================================

	if($Tipo -ne "DEVOLUCION"){

		Write-Host ""
		Write-Host "===== EQUIPO NUEVO =====" -ForegroundColor Green

		$NuevoMarca      = Pedir-Dato "Marca y modelo"
		$NuevoCPU        = Pedir-Dato "Procesador"
		$NuevoRAM        = Pedir-Dato "RAM"
		$NuevoDisco      = Pedir-Dato "Disco"
		$NuevoSerie      = Pedir-Dato "Serie"
		$NuevoHostname   = Pedir-Dato "Hostname"
		$NuevoActivo     = Pedir-Dato "Activo fijo"
	}
	else{
		$NuevoMarca="";$NuevoCPU="";$NuevoRAM="";$NuevoDisco="";$NuevoSerie="";$NuevoHostname="";$NuevoActivo=""
	}

    #====================================================
    # EQUIPO DEVUELTO
    #====================================================

	if($Tipo -ne "ENTREGA"){

		Write-Host ""
		Write-Host "===== EQUIPO DEVUELTO =====" -ForegroundColor Yellow

		$ViejoMarca      = Pedir-Dato "Marca y modelo"
		$ViejoCPU        = Pedir-Dato "Procesador"
		$ViejoRAM        = Pedir-Dato "RAM"
		$ViejoDisco      = Pedir-Dato "Disco"
		$ViejoSerie      = Pedir-Dato "Serie"
		$ViejoHostname   = Pedir-Dato "Hostname"
		$ViejoActivo     = Pedir-Dato "Activo fijo"
	}
	else{
		$ViejoMarca="";$ViejoCPU="";$ViejoRAM="";$ViejoDisco="";$ViejoSerie="";$ViejoHostname="";$ViejoActivo=""
	}

    #====================================================
    # OBJETO
    #====================================================

    $Cambio = [PSCustomObject]@{

        ID = $ID
        Fecha = $Fecha
		Tipo = $Tipo
		
        Estado = "ACTIVO"

        Colaborador = $Nombre
        Correo = $Correo

        NuevoMarca = $NuevoMarca
        NuevoCPU = $NuevoCPU
        NuevoRAM = $NuevoRAM
        NuevoDisco = $NuevoDisco
        NuevoSerie = $NuevoSerie
        NuevoHostname = $NuevoHostname
        NuevoActivo = $NuevoActivo

        ViejoMarca = $ViejoMarca
        ViejoCPU = $ViejoCPU
        ViejoRAM = $ViejoRAM
        ViejoDisco = $ViejoDisco
        ViejoSerie = $ViejoSerie
        ViejoHostname = $ViejoHostname
        ViejoActivo = $ViejoActivo

    }

    return $Cambio

}

function Guardar-CambioTXT($Cambio){

$Texto=@"

============================================================

ID: $($Cambio.ID)

Fecha: $($Cambio.Fecha)

COLABORADOR

Nombre : $($Cambio.Colaborador)

Correo : $($Cambio.Correo)

------------------------------------------------------------

EQUIPO NUEVO

Marca        : $($Cambio.NuevoMarca)

Procesador   : $($Cambio.NuevoCPU)

RAM          : $($Cambio.NuevoRAM)

Disco        : $($Cambio.NuevoDisco)

Serie        : $($Cambio.NuevoSerie)

Hostname     : $($Cambio.NuevoHostname)

Activo Fijo  : $($Cambio.NuevoActivo)

------------------------------------------------------------

EQUIPO DEVUELTO

Marca        : $($Cambio.ViejoMarca)

Procesador   : $($Cambio.ViejoCPU)

RAM          : $($Cambio.ViejoRAM)

Disco        : $($Cambio.ViejoDisco)

Serie        : $($Cambio.ViejoSerie)

Hostname     : $($Cambio.ViejoHostname)

Activo Fijo  : $($Cambio.ViejoActivo)

============================================================

"@

Add-Content $archivoTXT $Texto
Write-Host "Registro guardado en TXT correctamente" -ForegroundColor Green

}

function Guardar-CambioCSV($Cambio){

    if(Test-Path $archivoCSV){

        $Cambio | Export-Csv `
        -Path $archivoCSV `
        -NoTypeInformation `
        -Encoding UTF8 `
        -Append

    }
    else{

        $Cambio | Export-Csv `
        -Path $archivoCSV `
        -NoTypeInformation `
        -Encoding UTF8

    }

}

function Eliminar-Registro {

    $historial = Obtener-Historial

    if($historial.Count -eq 0){
        Write-Host "No hay registros." -ForegroundColor Red
        return
    }

    Mostrar-Historial $historial

    $registro = Seleccionar-Registro $historial

    if($null -eq $registro){
        return
    }

    Write-Host ""
    Write-Host "Vas a eliminar este registro:" -ForegroundColor Yellow
    Write-Host "$($registro.Colaborador) - $($registro.NuevoHostname)" -ForegroundColor Cyan

    $confirmacion = Read-Host "Escribe SI para confirmar"

    if($confirmacion -ne "SI"){
        Write-Host "Operacion cancelada." -ForegroundColor Red
        return
    }

    # Marcar como eliminado
    foreach($r in $historial){
        if($r.ID -eq $registro.ID){
            $r.Estado = "ELIMINADO"
        }
    }

    # Reescribir CSV completo
    $historial | Export-Csv `
        -Path $archivoCSV `
        -NoTypeInformation `
        -Encoding UTF8

    Write-Host "Registro eliminado correctamente." -ForegroundColor Green
}

function Obtener-Historial($IncluirEliminados = $false){

    if(!(Test-Path $archivoCSV)){
        return @()
    }

    $datos = Import-Csv $archivoCSV

    foreach($d in $datos){
        if(-not $d.PSObject.Properties["Estado"]){
            $d | Add-Member -MemberType NoteProperty -Name Estado -Value "ACTIVO"
        }
    }

    if(-not $IncluirEliminados){
        $datos = $datos | Where-Object {
            $_.Estado -ne "ELIMINADO"
        }
    }

    return $datos
}

function Mostrar-Historial($registros){

    $registros = @($registros)

    if($registros.Count -eq 0){
        Write-Host "No hay registros." -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "===== HISTORIAL =====" -ForegroundColor Cyan
    Write-Host ""

    for($i = 0; $i -lt $registros.Count; $i++){

        $r = $registros[$i]

        Write-Host "$($i+1). [$($r.ID)] $($r.Colaborador)"
        Write-Host "    Hostname Nuevo : $($r.NuevoHostname)"
        Write-Host "    Hostname Viejo : $($r.ViejoHostname)"
        Write-Host ""
    }
}

function Confirmar-Cambio($Cambio){

    Clear-Host

    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "           CONFIRMAR OPERACION" -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "ID: $($Cambio.ID)"
    Write-Host "Tipo: $($Cambio.Tipo)"
    Write-Host "Fecha: $($Cambio.Fecha)"
    Write-Host ""

    Write-Host "COLABORADOR" -ForegroundColor Yellow
    Write-Host "Nombre : $($Cambio.Colaborador)"
    Write-Host "Correo : $($Cambio.Correo)"
    Write-Host ""

    if($Cambio.Tipo -ne "DEVOLUCION"){

        Write-Host "EQUIPO NUEVO" -ForegroundColor Green
        Write-Host "Marca     : $($Cambio.NuevoMarca)"
        Write-Host "Hostname  : $($Cambio.NuevoHostname)"
        Write-Host "Serie     : $($Cambio.NuevoSerie)"
        Write-Host ""
    }

    if($Cambio.Tipo -ne "ENTREGA"){

        Write-Host "EQUIPO DEVUELTO" -ForegroundColor Yellow
        Write-Host "Marca     : $($Cambio.ViejoMarca)"
        Write-Host "Hostname  : $($Cambio.ViejoHostname)"
        Write-Host "Serie     : $($Cambio.ViejoSerie)"
        Write-Host ""
    }

    do{
        $resp = (Read-Host "¿Generar correo? (S/N)").ToUpper()
    }while($resp -notin @("S","N"))

    return ($resp -eq "S")
}

function Buscar-Historial($TipoBusqueda){

    $historial = Obtener-Historial | Where-Object {
    $_.Estado -ne "ELIMINADO"
}

    if($historial.Count -eq 0){
        Write-Host ""
        Write-Host "No existen registros." -ForegroundColor Red
        Esperar
        return
    }

    switch($TipoBusqueda){

    "COLABORADOR"{

        $texto = Read-Host "Ingrese nombre del colaborador"

        $resultados = @(
            $historial | Where-Object {
                $_.Colaborador -like "*$texto*"
            }
        )
    }

    "HOSTNAME"{

        $texto = Read-Host "Ingrese hostname"

        $resultados = @(
            $historial | Where-Object {
                $_.NuevoHostname -like "*$texto*" -or
                $_.ViejoHostname -like "*$texto*"
            }
        )
    }

    "SERIE"{

        $texto = Read-Host "Ingrese numero de serie"

        $resultados = @(
            $historial | Where-Object {
                $_.NuevoSerie -like "*$texto*" -or
                $_.ViejoSerie -like "*$texto*"
            }
        )
    }
}

    if($resultados.Count -eq 0){
        Write-Host ""
        Write-Host "No se encontraron coincidencias." -ForegroundColor Yellow
        Esperar
        return
    }
	
	Write-Host ""
	Write-Host "Resultados encontrados: $($resultados.Count)" -ForegroundColor Yellow
	
	$resultados = @($resultados)

	Write-Host ""

	Mostrar-Historial $resultados

	$registro = Seleccionar-Registro $resultados

if($null -ne $registro){

    if(Confirmar-Cambio $registro){

        Generar-Correo $registro

    }

}
}

function Seleccionar-Registro($registros){

    $registros = @($registros)

    if($registros.Count -eq 0){
        return $null
    }

    do{
        $op = Read-Host "Selecciona numero"
    }
    while(
        $op -notmatch '^\d+$' -or
        [int]$op -lt 1 -or
        [int]$op -gt $registros.Count
    )

    return $registros[[int]$op - 1]
}

function Generar-Correo($Cambio){

    #========================
    # TITULO
    #========================
    switch($Cambio.Tipo){
        "CAMBIO"     { $titulo = "Asignacion de Equipo: Renovación Tecnológica" }
        "ENTREGA"    { $titulo = "Entrega de equipo" }
        "DEVOLUCION" { $titulo = "Devolucion de equipo" }
        default      { $titulo = "Movimiento de equipo" }
    }

    $asunto = "$titulo - $($Cambio.Colaborador)"

    #========================
    # CUERPO
    #========================

    $cuerpo = "Hola a todos,`n`n"
    $cuerpo += "Se adjunta gestion por concepto de $titulo.`n`n"

    $cuerpo += "========================================`n"
    $cuerpo += "COLABORADOR`n"
    $cuerpo += "========================================`n"

    $cuerpo += "Colaborador: $($Cambio.Colaborador)`n"
    $cuerpo += "Correo: $($Cambio.Correo)`n`n"

    if($Cambio.Tipo -ne "DEVOLUCION"){
        $cuerpo += "========================================`n"
        $cuerpo += "EQUIPO NUEVO`n"
        $cuerpo += "========================================`n"

        $cuerpo += "Marca y modelo: $($Cambio.NuevoMarca)`n"
        $cuerpo += "Procesador: $($Cambio.NuevoCPU)`n"
        $cuerpo += "RAM: $($Cambio.NuevoRAM)`n"
        $cuerpo += "Disco: $($Cambio.NuevoDisco)`n"
        $cuerpo += "Serie: $($Cambio.NuevoSerie)`n"
        $cuerpo += "Hostname: $($Cambio.NuevoHostname)`n"
        $cuerpo += "Activo fijo: $($Cambio.NuevoActivo)`n`n"
    }

    if($Cambio.Tipo -ne "ENTREGA"){
        $cuerpo += "========================================`n"
        $cuerpo += "EQUIPO DEVUELTO`n"
        $cuerpo += "========================================`n"

        $cuerpo += "Marca y modelo: $($Cambio.ViejoMarca)`n"
        $cuerpo += "Procesador: $($Cambio.ViejoCPU)`n"
        $cuerpo += "RAM: $($Cambio.ViejoRAM)`n"
        $cuerpo += "Disco: $($Cambio.ViejoDisco)`n"
        $cuerpo += "Serie: $($Cambio.ViejoSerie)`n"
        $cuerpo += "Hostname: $($Cambio.ViejoHostname)`n"
        $cuerpo += "Activo fijo: $($Cambio.ViejoActivo)`n`n"
    }
        $cuerpo += "Aplicar las configuraciones de seguridad correspondientes, si procede."

    #========================
    # DESTINATARIOS (SOLO ;. Configurar los destinatarios según la organización)
    #========================

    # Personalice estos correos antes de utilizar la herramienta.

    $para = $config.Correo.Para
    $cc   = $config.Correo.CC
    
    # Personalice estos correos antes de utilizar la herramienta.

    #========================
    # ABRIR OUTLOOK (SIN BODY)
    #========================

    $asuntoEncoded = [System.Uri]::EscapeDataString($asunto)
    $paraEncoded   = [System.Uri]::EscapeDataString($para)

    if (
    [string]::IsNullOrWhiteSpace($para) -or
    $para -like "*@empresa.com*"
) {
    Write-Host ""
    Write-Host "Debe configurar los destinatarios en Config\config.json." -ForegroundColor Yellow
    Write-Host ""

    Esperar
    return
}

    $url = "https://outlook.office.com/mail/deeplink/compose?to=$paraEncoded&subject=$asuntoEncoded"

    Start-Process $url

    #========================
    # COPIAR CUERPO
    #========================

    Set-Clipboard -Value $cuerpo

    Write-Host ""
    Write-Host "Correo abierto correctamente." -ForegroundColor Green
    Write-Host "PASO 1: Pega el CUERPO con CTRL + V" -ForegroundColor Cyan

    #========================
    # ESPERA
    #========================

    Read-Host "Cuando pegues el cuerpo, presiona ENTER para copiar el CC"

    #========================
    # COPIAR CC
    #========================

    Set-Clipboard -Value $cc

    Write-Host "PASO 2: Pega el CC en el campo CC (CTRL + V)" -ForegroundColor Yellow
}

#endregion

#region REGISTRO

#endregion

#region GUARDADO

#endregion

#region CORREO

#endregion

#region BUSQUEDAS

#endregion

#region MENU
function Mostrar-Menu{

    Mostrar-Titulo "REGISTRO DE CAMBIO DE EQUIPOS"

    Write-Host "1. Registrar cambio"
    Write-Host "2. Buscar por..."
    Write-Host "3. Historial"
    Write-Host "4. Borrar Registro"
    Write-Host "5. Generar correo"
    Write-Host ""
    Write-Host "0. Salir"

    Write-Host ""

    return Read-Host "Seleccione una opcion"

}

function Menu-Busqueda{

    do{

        Clear-Host

        Write-Host "===== BUSCAR HISTORIAL =====" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Buscar por colaborador"
        Write-Host "2. Buscar por hostname"
        Write-Host "3. Buscar por numero de serie"
        Write-Host "4. Volver"
        Write-Host ""

        $opcion = Read-Host "Seleccione una opcion"

        switch($opcion){

            "1"{
                Buscar-Historial "COLABORADOR"
            }

            "2"{
                Buscar-Historial "HOSTNAME"
            }

            "3"{
                Buscar-Historial "SERIE"
            }

        }

    }while($opcion -ne "4")
}

#endregion

#region MAIN
do{

    $opcion=Mostrar-Menu

    switch($opcion){

		"1"{

			$Cambio = Registrar-Cambio

			Mostrar-Titulo "RESUMEN"

			Write-Host "ID: $($Cambio.ID)"
			Write-Host "Colaborador: $($Cambio.Colaborador)"

			$guardar = Read-Host "Guardar? (S/N)"

			if($guardar -match "^[Ss]$"){

				Guardar-CambioTXT $Cambio
				Guardar-CambioCSV $Cambio

				$correo = Read-Host "Generar correo? (S/N)"

				if($correo -match "^[Ss]$"){
					Generar-Correo $Cambio
				}
			}

			Esperar
}

		"2"{
			Menu-Busqueda
		}

		"3"{

			$historial = Obtener-Historial

			Mostrar-Historial $historial

			function Esperar
		}
        "4" { 
        Eliminar-Registro
        Esperar
    }

		"5"{

			$historial = Obtener-Historial

			if($historial.Count -eq 0){

				Write-Host "No hay registros para mostrar." -ForegroundColor Red
				Esperar
				break
			}

			Mostrar-Historial $historial

			Write-Host ""
			$seleccion = Seleccionar-Registro $historial

			if($null -eq $seleccion){
				break
			}

			Write-Host ""
			Write-Host "Generando correo..." -ForegroundColor Yellow

			Generar-Correo $seleccion

			Esperar
		}

        "0"{

            Write-Host ""
            Write-Host "Hasta luego."

        }

        default{

            Write-Host ""
            Write-Host "Opcion invalida." -ForegroundColor Red

            Esperar

        }

    }

}while($opcion -ne "0")
#endregion