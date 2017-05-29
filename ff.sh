#!/bin/bash
# ./ff.sh

# CRE:	03/05/2017
# MOD:	17/05/2017

###################################################################################################	#
# Tratamiento de las imágenes de propiedades nuevas.							#
# Llamo al script pasando el código de la propiedad como argumento					#
# El nombre de la carpeta que contiene las fotos tiene que coincidir con el código de la propiedad	#
###################################################################################################	#

## ARGUMENTOS

# Nombre de la carpeta con las fotos, que debería coincidir con el código de la propiedad cuando se llama a este script desde NuevaPropiedad
RR_fotos="$1"


## CONFIGURACIÓN

# Creo que no es necesario ya que el equipo está configurado con estos parámetros ya.
export LANG=es_ES
# Numeración de las imágenes. Si no se usara así comenzarían por 00
num=1
# Parámetros de compresión de las fotos
pixels=900
calidad=65


## RUTAS

# Nombre de la carpeta que contiene las nuevas propiedades
RR_nuevas="01.Nueva"

# Nombre de la carpeta que contiene las plantillas en blanco
RR_plantillas="00.Plantillas"

# Ruta de la carpeta de propiedades en el servidor
RA_propiedades="/mnt/Datos/Compartir/Servidor/Propiedades"

# Ruta de la carpeta donde se guardan las fotos originales de las propiedades
# Queda excluída de las copias de seguridad que se hacen en el servidor.
# Debería hacer copia en otro lado
RA_fotos_originales="/mnt/Datos/Compartir/Recursos/FotosOriginales"

# Determina la carpeta de la propiedad en el servidor
# Es la ruta de las imágenes a editar si se elige la opción [1] 01.Nueva
RA_carpeta="$RA_propiedades/$RR_nuevas"

# Carpeta en servidor donde guardo las plantillas para propiedades
RA_plantillas="$RA_propiedades/$RR_plantillas"

# Ruta de la carpeta que tiene las fotos en caso de seleccionar la opción [2] Imágenes
RA_fotos2="/mnt/Datos/home/GrupoEuroga/Imágenes"


## INPUTS
# ---------------------------------------------------------------------

clear

printf "Ubicación de las fotos:
[1] 01.Nueva (Servidor)
[2] Imágenes
[3] Otra Ubicación
\n\n"
read fotos_u

if [ "$fotos_u" = '1' ]
 then
 RA_fotos="$RA_carpeta"
elif [ "$fotos_u" = '2' ]
 then
 RA_fotos="$RA_fotos2"
elif [ "$fotos_u" = '3' ]
then
 printf "Escribir ubicación de la carpeta con las fotos de la propiedad [Ruta Absoluta]\n "
 read RA_fotos
fi


## EDICIÓN DE FOTOS
# -------------------------------------------------------------------------------

# Accedo a la carpeta con las fotos para poder trabajar con los nombres
cd "$RA_fotos/$RR_fotos"

# Muestro las fotos a editar y pido autorización para continuar
printf "\nListado de fotografías de la propiedad\n"
ls -ahl
printf "\nEstas son las fotos que se van a editar. Continuar [si/no]\n"
read continuar_sn

# Formateo y renombrado de imágenes
if [ "$continuar_sn" = 'si' ]
 then

 for file in *
 do

# Solo proceso archivos modificables (writeable)
 if [ -fw "$file" ]; then

   # Creo el nombre de las nuevas fotos, original y modificada
   nombre_foto="$RR_fotos"["$pixels"px]$(printf "%03d" $num).${file##*.}
   # nombre_foto="$RR_fotos"["$pixels"px]$(printf "%03d" $num).${file: -3}
   nombre_foto_original=$RR_fotos-$(printf "%03d" $num).${file##*.}
   # nombre_foto_original=$RR_fotos-$(printf "%03d" $num).${file: -3}


   # Copio la foto original a su nueva ubicación con el nombre nuevo
   cp "$file" "$RA_fotos_originales/$nombre_foto_original"
   # Modifico la foto de la carpeta dándele las dimensiones y calidad seleccionadas.
   convert $file -resize $pixels -quality $calidad $file
   # Renombro la foto modificada
   mv "$file" "$nombre_foto"
   ((num=$num+1))
 fi
 
 done

# Cambio el nombre de la carpeta para diferenciarla de las que no están todavía formateadas.
 mv "$RA_fotos/$RR_fotos" "$RA_fotos/$RR_fotos.Fotos"

else
 printf "\nSe ha cancelado el formateo de las fotos\n"
fi

# Si vengo del script de NuevaPropiedad salgo de la carpeta de las fotos y continúo con el código
