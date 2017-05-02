#!/bin/bash

export LANG=es_ES

pendientes="01.Nueva"
propiedades="/mnt/Datos/Compartir/Servidor/Propiedades"
carpeta="$propiedades/$pendientes"

moneda="Gs"
precio=$(printf "Precio: $moneda %'d" 1120000000)
echo -e "\nesto es una prueba
$precio
y un poco más de texto
">> test.resultado
#chmod -R 777 $carpeta/$1
#cd $carpeta/$1
for file in *; do convert $file -resize 900 -quality 65 R_900px_$file;done

