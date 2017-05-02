#!/bin/bash

# Archivo: NuevaPropiedad.sh
# --------------------------------------------- #
# Crear archivos y carpeta para nueva propiedad #
# --------------------------------------------- #

# Ejecución
# ------------------------------------------------------------------------ #
# Se llama al comando ./NuevaPropiedad C                                   #
# Se añade el tipo de propiedad para ver los que ya existen en el servidor #
# ------------------------------------------------------------------------ #

# Código no ejecutado
# --------------------------------------------------------------------------------------------------- #
# CADENA="Variable global"
# CADENA="Selecciona el código de la nueva propiedad"

# mostrar cadena en pantalla
# echo $CADENA

# Comprobar que no exista la carpeta de la propiedad
# if [ -d /opt/ ] Este comando busca la carpteta /opt/

# Código para escribir en un archivo las carpetas encontradas:
# find /mnt/Datos/Compartir/Servidor/Propiedades/ -iname "[$1]17[0-9][0-9].-*" -type d 1> listado.p
# --------------------------------------------------------------------------------------------------- #


# PENDIENTE: Leer archivo de propiedades y generar el código nuevo
# Falta copiar la plantilla de la ficha de la oficina
# Falta copiar la plantilla de OLX
# Limpiar cadena de la carpeta de propiedades para mostrar las propiedades más limpias
# Abortar proceso si ya existe el código [Ctl+C]
# Añadir IVA al precio definitivo
# Poner un if para mostrar coincidencias o avisar de que no existe el código


# CONFIGURACIONES
# ---------------------------------------------------------------
touch $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.facebook
export LANG = es_ES

carpeta="/mnt/Datos/Compartir/Servidor/Propiedades/1.Pendientes/"
propiedades="/mnt/Datos/Compartir/Servidor/Propiedades/"
# ---------------------------------------------------------------

# INPUTS
# ---------------------------------------------------------------
echo "Tipo de Propiedad [C|T|L|V]"
read tipo

# Buscar las carpetas del tipo indicado y mostrarlas:
find /mnt/Datos/Compartir/Servidor/Propiedades/ -iname "[$tipo]1[6-7][0-9][0-9].-*" -type d

echo "Escribe el código de tu nueva propiedad"
read codigo

# Compruebo si existe el código
echo Propiedades con el mismo código en la base de datos:
find $propiedades -iname "$codigo.-*" -type d

# Selecciona el tipo de moneda
echo Moneda [USD/Gs]
read moneda
# Selecciona el precio de venta del propietario
echo Precio de venta
read precio
# Marca si la comisión está incluida en el precio del propietario
echo ¿Comisión incluida? [si/no]
read comision_sn
# Selecciona la comisión acordada con el propietario
echo Comisión a aplicar [Total/%]
read com

# CÁLCULO DE PRECIOS Y COMISIONES
# ------------------------------------------------------
if [ $com -lt 100 ]; then
 if [ "$comision_sn" = 'no' ]; then
 comision="comisión no incluída"
 ((porcentaje = 100 - $com))
 ((precio2 = $precio * 100 / $porcentaje))
 echo Precio de venta aplicada la comisión [$precio2]
 echo Nuevo precio de venta definitivo
 read PVP
 else
  if [ "$comision_sn" = 'si' ]; then
  comision="comisión incluída"
  ((precio2 = $precio))
  ((PVP = $precio))
  ((porcentaje = 100 - $com))
  ((precio = $precio2 * $porcentaje / 100))
  fi
 ((com_total = $PVP - $precio))
 fi
fi

# Si la comisión es mayor de 100 entonces es una cantidad fija a sumar o restar del precio
# ------------------------------------------------------

echo "Escribe el barrio o distrito donde está ubicada la propiedad"
read ubicacion
echo "Escribe el nombre del propietario o contacto de la propiedad"
read contacto
echo "Apellidos del contacto"
read apellidos
echo Nota, apodo o recordatorio del contacto o la propiedad
read nota
echo "Relación del contacto con la propiedad [Propietario|Intermediario|Agente|Conocido]"
read relacion
echo "N C.I. del contacto"
read nci
echo "Escribe el número de teléfono del contacto"
read telefono

echo "¿Tiene el título al día? [si/no/otros]"
read _titulo
if [ "$_titulo" = 'si' ]; then
titulo="#TítuloAlDía"
fi

echo "¿Acepta vehículo como parte de pago? [si/no/otros]"
read _vehiculo
if [ "$_vehiculo" = 'si' ]; then
vehiculo="#AceptaVehiculo"
fi

echo "¿Precio negociable? [si/no/otros]"
read _negociable
if [ "$_negociable" = 'si' ]; then
negociable="#Negociable"
fi

echo "¿El propietario ofrece financiación? [si/no/otros]"
read _financiacion
if [ "$_financiacion" = 'si' ]; then
financiacion="#Financiable"
fi
# -------------------------------------------------------------------

# CARPETAS Y DOCUMENTOS
# -------------------------------------------------------------------
echo "Escribiendo los datos y carpetas ..."

# Creo las carpetas y archivos
mkdir $carpeta/"$codigo.-$contacto - $ubicacion"
mkdir $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.Fotos
mkdir $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.Favoritas
mkdir $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.Documentos
# -------------------------------------------------------------------

# FICHA
# -------------------------------------------------------------------
touch $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo

echo -e "$codigo
Ubicación: $ubicacion
Coordenadas GPS: \n
[$relacion]
Nombre: $contacto
Apellidos: $apellidos
Nº C.I.: $nci
Teléfono: $telefono\n
Nota: $nota\n
#Precio
Precio Propietario: $moneda $precio
Comisión: $com"%" [$comision]
Total Comisión: $com_total
Precio con comisión: $moneda $precio2
PVP: $moneda $PVP2

Precio negociable: $_negociable
Acepta vehículo como parte del precio: $_vehiculo
Titulo al día: $_titulo
Posibilidades de financiación: $_financiacion
" > $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo
# -------------------------------------------------------------------

# FACEBOOK
# ----------------------------------------------------------------
touch $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.facebook

echo -e "#$codigo
#GrupoEurogaVENDE
$ubicacion\n
" >> $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.facebook

printf "Precio: $moneda %'d" $PVP >> $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.facebook

echo -e "
$negociable
$vehiculo
$financiacion
$titulo

Para más información de esta y otras propiedades:

@GrupoEuroga
Av. Doctor Rodríguez de Francia 1788
Encarnación - Itapúa - Paraguay

Línea Alta: (021) 3387560
Móvil: (0985) 515925 [whatsapp]
Correo: inmo@grupoeuroga.com
https://www.facebook.com/GrupoEuroga
http://www.grupoeuroga.com/propiedades
http://www.grupoeuroga.com/$codigo
" >> $carpeta/"$codigo.-$contacto - $ubicacion"/$codigo.facebook
# -----------------------------------------------------------------

