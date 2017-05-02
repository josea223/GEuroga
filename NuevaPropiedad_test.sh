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
# Enlace directo a Google Maps [https://www.google.com.py/maps/place/$coordenadas]


# CONFIGURACIONES
# ---------------------------------------------------------------
export LANG=es_ES

pendientes="01.Nueva"
propiedades="/mnt/Datos/Compartir/Servidor/Propiedades"
carpeta="$propiedades/$pendientes"
# ---------------------------------------------------------------

# INPUTS
# ---------------------------------------------------------------
echo "Tipo de Propiedad [C|T|L|V]"
read tipo

echo \n"Listado de propiedades 2016 - 2017 del tipo '$tipo'"\n"."\n".."\n"..."
find $propiedades -iname "[$tipo]1[6-7][0-9][0-9].-*" -type d
echo "Fin del listado"\n

# Compruebo si existe el código
echo "Escribe el código de tu nueva propiedad"
read codigo
echo "Propiedades con el mismo código en la base de datos:"\n"."\n".."\n"..."
find $propiedades -iname "$codigo.-*" -type d
echo "Fin del listado"\n
# ----------------------------------------------------------------

# Ubicación de la propiedad
echo "Escribe el barrio o distrito donde está ubicada la propiedad [Se usa para nombrar la carpeta de la propiedad]"
read ubicacion
echo "Escribe la ubicación a publicar con el formato [Distrito - Departamento - País]"
read localizacion
echo "Tipo de acceso hasta la propiedad [Asfaltado/Empedrado/Enripiado/Tierra/NA]"
read acceso
echo "Coordenadas GPS [lat, long]"
read coordenadas
echo "Publicar localización en Google Maps [si/no]"
read localizacion_sn
# ----------------------------------------------------------------

# Servicios y otros de la propiedad
echo "Acceso a suministro de agua [si/no]"
read _agua
echo "Acceso a suministro eléctrico [si/no]"
read _electricidad


# -------------------------------------------------------------------

# Datos del contacto
echo "Escribe el nombre del propietario o contacto de la propiedad"
read contacto
echo "Apellidos del contacto"
read apellidos
echo "Nota, apodo o recordatorio del contacto o la propiedad"
read nota
echo "Relación del contacto con la propiedad [Propietario|Intermediario|Agente|Conocido]"
read relacion
echo "N C.I. del contacto"
read nci
echo "Escribe el número de teléfono del contacto"
read telefono
# ------------------------------------------------------------------

# Dimensiones y superficie de la propiedad
echo "Superficie total [???? m2/has]"
read superficie
echo "Medida del frente del terreno [???? m/km]"
read frente
echo "Medida de fondo del terreno [???? m/km]"
read fondo
# -----------------------------------------------
# Datos de registro de la propiedad

echo "¿Tiene el título al día? [si/no/otros]"
read _titulo

echo "Cta. Cte. Catastral de la propiedad"
read catastro
echo "Número de finca"
read finca
# -----------------------------------------------
# Precio y comisión
echo "Moneda [USD/Gs]"
read moneda
echo "Precio de venta"
read precio
echo "¿Comisión incluida? [si/no]"
read comision_sn
echo "Comisión a aplicar [Total/%]"
read com

echo "¿Acepta vehículo como parte de pago? [si/no/otros]"
read _vehiculo

echo "¿Precio negociable? [si/no/otros]"
read _negociable

echo "¿El propietario ofrece financiación? [si/no/otros]"
read _financiacion

# ------------------------------------------------
# Otros
echo "Otras observaciones para la inmobiliaria"
read observaciones
echo "Texto para el anuncio"
read anuncio
# --------------------------------------------------

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

PVP2=$(printf "%'d" $PVP)

# FORMATEO DE MEDIDAS Y SERVICIOS

if [ "$_agua" = 'si' ]; then
agua="#SuministroDeAgua"
fi

if [ "$_electricidad" = 'si' ]; then
electricidad="#SuministroElectrico"
fi

if [ "$_financiacion" = 'si' ]; then
financiacion="#Financiable"
fi

if [ "$_negociable" = 'si' ]; then
negociable="#Negociable"
fi

if [ "$_vehiculo" = 'si' ]; then
vehiculo="#AceptaVehiculo"
fi

if [ "$_titulo" = 'si' ]; then
titulo="#TítuloAlDía"
fi

# Sin terminar -----
if [ "$frente" -gt 0 ]; then
 if [ $superficie -gt 0 ]; then # Error: [: 360.10: se esperaba una expresión entera
  $dimensiones="$frente x $fondo ($superficie)"
 fi
 $dimensiones="$frente x $fondo" # Error: =12 x 31: no se encontró la orden
else
 if [ "$superficie" -gt 0 ]; then
  $dimensiones=$superficie
 else
  $dimensiones= 0
 fi
fi

extras=""
if [ "$dimensiones" -gt 0 ]; then
$extras="$dimensiones" # Error: [: : se esperaba una expresión entera
fi
# ------------------------------------------------------------------

# CARPETAS Y DOCUMENTOS
# -------------------------------------------------------------------
echo "Escribiendo los datos y carpetas ..."

#Nueva carpeta
carpeta_nueva="$carpeta/$codigo.-$contacto - $ubicacion"

mkdir "$carpeta_nueva"
mkdir "$carpeta_nueva"/$codigo.Fotos
mkdir "$carpeta_nueva"/$codigo.Favoritas
mkdir "$carpeta_nueva"/$codigo.Documentos
# -------------------------------------------------------------------

# FOTOS
# ---------------------------------------------------------------------
cd $carpeta/$codigo
mv $codigo.NoPublicar "$carpeta_nueva"/$codigo.Fotos
#cp * "$carpeta_nueva"/$codigo.Fotos
for file in *; do convert $file -resize 900 -quality 65 $codigo.900px-$file;done
mv * "$carpeta_nueva"/$codigo.Favoritas
cd "$carpeta_nueva"
# ----------------------------------------------------------------------

# FICHAS
# -------------------------------------------------------------------
# Ficha propiedad

echo -e "$codigo
# Localización
Ubicación: $ubicacion
Localización: $localizacion
Coordenadas GPS: $coordenadas\n

# Datos
Acceso: $acceso
Dimensiones: $frente x $fondo
Superficie: $superficie
Agua:	$agua
Electricidad: $electricidad
Observaciones: $observaciones
Anuncio: $anuncio

#Precio
Precio Propietario: $moneda $precio
Comisión: $com"%" [$comision]
Total Comisión: $moneda $com_total
Precio con comisión: $moneda $precio2
PVP: $moneda $PVP
Precio negociable: $_negociable
Acepta vehículo como parte del precio: $_vehiculo
Posibilidades de financiación: $_financiacion

#Título
Titulo al día: $_titulo
Cta. Cte. Catastral: $catastro
N. Finca: $finca
" > $codigo
# -------------------------------------------------------------------
# Ficha contacto

echo -e "$codigo
[$relacion]
Nombre: $contacto
Apellidos: $apellidos
Nº C.I.: $nci
Teléfono: $telefono\n
Nota: $nota\n
" > $codigo.contacto

# ----------------------------------------------------------------
# Anuncio Facebook

echo -e "#$codigo [Nuestra Referencia]
#GrupoEurogaVENDE
$localizacion
$extras
$anuncio

Precio: $moneda $PVP2

$negociable
$vehiculo
$financiacion
$titulo
$agua
$electricidad

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
" >> $codigo.facebook
# -----------------------------------------------------------------
# Anuncio Clasipar

echo -e "#$codigo [Nuestra Referencia]
#GrupoEurogaVENDE
$localizacion\n
$anuncio

Precio: $moneda $PVP2

$negociable
$vehiculo
$financiacion
$titulo
$agua
$electricidad

Para más información de esta y otras propiedades:
@GrupoEuroga
Av. Doctor Rodríguez de Francia 1788
Encarnación - Itapúa - Paraguay
" >> $codigo.clasipar
# -----------------------------------------------------------------

