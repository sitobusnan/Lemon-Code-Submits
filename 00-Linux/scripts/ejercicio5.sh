#!/bin/bash

# URL de la página a descargar (Artículo Madrid de la Wikipedia)
# Comprobación de que se haya pasado un argumento
if [ $# -lt 2 ]; then
    echo "Se necesitan únicamente dos parámetros para ejecutar este script"
    exit 1
fi

URL="$1"
searchWord="$2"

# Creamos un archivo temporal
touch temp.html
# Descargar el contenido de la página web y guardarlo en un archivo temporal
curl -s "$URL" -o temp.html

# Buscar la palabra en el archivo temporal
if grep -q -i "$palabra_a_buscar" temp.html; then

    appearCount=$(grep -o -i "$searchWord" temp.html | wc -l)
    firstLine=$(grep -in "$searchWord" temp.html | head -n 1 | cut -d ":" -f 1)
    
    if [ "$appearCount" -eq 1 ]; then
        echo "Aparece únicamente en la línea $firstLine."
    else
        echo "Aparece por primera vez en la línea $firstLine."
    fi
    echo "La palabra \"$searchWord\" aparece $appearCount veces."
else
    echo "No se ha encontrado la palabra \"$searchWord\"."
fi
rm temp.html