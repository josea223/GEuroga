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

# CAMBIOS
# Renombrado de las variables de rutas a carpetas y archivos (PATH_)
# Añadido los comandos para compiar las plantillas a la carpeta de la nueva propiedad
# Mostrar las rutas a las propiedades de una manera más limpia
# Abortar proceso si ya existe el código [Ctl+C]
# Añadir IVA a la comisión
# Renombrado de las fotos con código y número

# PENDIENTE:
# Leer archivo de propiedades y generar el código nuevo
# Falta colocar todas las plantillas en su carpeta
# Borrar carpeta original con fotos
# Enlace directo a Google Maps [https://www.google.com.py/maps/place/$coordenadas]


# CONFIGURACIONES
# ---------------------------------------------------------------
export LANG=es_ES

# RUTAS
nuevas="01.Nueva"
plantillas="00.Plantillas"
PATH_propiedades="/mnt/Datos/Compartir/Servidor/Propiedades"
PATH_carpeta="$PATH_propiedades/$nuevas"
PATH_plantillas="$PATH_propiedades/$plantillas"

# OTRAS VARIABLES / CONSTANTES
((IVA = 10 / 100 ))
# ---------------------------------------------------------------

# Me situo en la carpeta de propiedades para eliminar la ruta completa de las que coincidan con la búsqueda y que quede más clara la info en pantalla
cd $PATH_propiedades

# INPUTS
# ---------------------------------------------------------------
echo "Tipo de Propiedad [C|T|L|V]"
read tipo

echo "
Listado de propiedades 2016 - 2017 del tipo '$tipo'
.
..
..."
# Elimino la ruta absoluta de la búsqueda
# find $propiedades -iname "[$tipo]1[6-7][0-9][0-9].-*" -type d
find * -iname "[$tipo]1[6-7][0-9][0-9].-*" -type d
echo "Fin del listado \n"

# Compruebo si existe el código
echo "Escribe el código de tu nueva propiedad"
read codigo
echo "Propiedades con el mismo código en la base de datos:
.
..
..."
# Elimino la ruta absoluta de la búsqueda
#find $propiedades -iname "$codigo.-*" -type d
find * -iname "$codigo.-*" -type d
echo "Fin del listado"\n
# ----------------------------------------------------------------

# BREAK
echo "¿Deseas continuar la creación de una nueva propiedad con el código $cogido? [si/no]"
read continuar_sn
if [ "$continuar_sn" = 'si' ]; then

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
# Sumo el IVA a la comisión
((comIVA = $com + $IVA ))

# Comisión es porcentaje sobre precio de venta
if [ $comIVA -lt 100 ]; then

# COMISIÓN NO INCLUIDA EN EL PRECIO
# ------------------------------------------------
 if [ "$comision_sn" = 'no' ]; then
 comision="comisión no incluída"

# Cálculo del Precio del propietario y de la comisión
 ((porcentaje = 100 - $comIVA))
 ((precio2 = $precio * 100 / $porcentaje))

# Ajuste y redondeo del precio de venta
 echo Precio de venta aplicada la comisión [$precio2]
 echo Nuevo precio de venta definitivo
 read PVP
 else
# ------------------------------------------------

# COMISIÓN INCLUIDA EN EL PRECIO
# ------------------------------------------------
  if [ "$comision_sn" = 'si' ]; then
  comision="comisión incluída"
  ((precio2 = $precio))
  ((PVP = $precio))
  ((porcentaje = 100 - $comIVA))
  ((precio = $precio2 * $porcentaje / 100))
  fi
 ((com_total = $PVP - $precio))
 fi
fi
# ------------------------------------------------

# FORMATEO EL PRECIO DE VENTA A PUBLICAR
PVP2=$(printf "%'d" $PVP)

# FORMATEO DE TAGS DE MEDIDAS Y SERVICIOS
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
PATH_nueva_propiedad="$PATH_carpeta/$codigo.-$contacto - $ubicacion"

mkdir "$PATH_nueva_propiedad"
mkdir "$PATH_nueva_propiedad"/$codigo.Fotos
mkdir "$PATH_nueva_propiedad"/$codigo.Favoritas
mkdir "$PATH_nueva_propiedad"/$codigo.Documentos
# -------------------------------------------------------------------

# FOTOS
# ---------------------------------------------------------------------
cd $PATH_carpeta/$codigo
mv $codigo.NoPublicar "$PATH_nueva_propiedad"/$codigo.Fotos
#cp * "$PATH_nueva_propiedad"/$codigo.Fotos
#for file in *; do convert $file -resize 900 -quality 65 $codigo.900px-$file;done
num=0
for file in *; do convert $file -resize 900 -quality 65 $codigo.$num;((cont=$cont+1));done
mv * "$PATH_nueva_propiedad"/$codigo.Favoritas
# ----------------------------------------------------------------------

# PLANTILLAS
# copio las plantillas en la carpeta de la nueva propiedad y les añado su código al nombre
cd $PATH_plantillas
for plantilla in *; do cp "$PATH_nueva_propiedad"/$codigo.$plantilla;done
# ----------------------------------------------------------------------

# FICHAS

cd "$PATH_nueva_propiedad"

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
echo "Generados archivos y carpetas de la propiedad $codigo"

# -----------------------------------------------------------------
# BREAK - NO GENERADO NINGÚN ARCHIVO NI CARPETA
else
echo "No se ha creado la nueva propiedad."
fi
