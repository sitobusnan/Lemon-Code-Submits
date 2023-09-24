#!/bin/bash

# URL de la página a descargar (Artículo Madrid de la Wikipedia)
URL="https://es.wikipedia.org/wiki/Madrid"

# Comprobación de que se haya pasado un argumento
if [ $# -eq 0 ]; then
    echo "Se debe proporcionar una palabra de busqueda"
    exit 1
fi

searchWord="$1"

# Creamos un archivo temporal
touch temp.html
# Descargar el contenido de la página web y guardarlo en un archivo temporal
curl -s "$URL" -o temp.html

# Buscar la palabra en el archivo temporal
if grep -q -i "$searchWord" temp.html; then

    appearCount=$(grep -o -i "$searchWord" temp.html | wc -l)
    firstLine=$(grep -in "$searchWord" temp.html | head -n 1 | cut -d ":" -f 1)
    
    echo "La palabra \"$searchWord\" aparece $appearCount veces."
    echo "Aparece por primera vez en la línea $firstLine."
else
    echo "No se ha encontrado la palabra \"$searchWord\"."
fi
rm temp.html