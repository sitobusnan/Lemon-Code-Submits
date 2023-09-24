# Ejercicios

## Ejercicios CLI

### 1. Crea mediante comandos de bash la siguiente jerarquía de ficheros y directorios

```bash
foo/
├─ dummy/
│  ├─ file1.txt
│  ├─ file2.txt
├─ empty/
```

Donde `file1.txt` debe contener el siguiente texto:

```bash
Me encanta la bash!!
```

Y `file2.txt` debe permanecer vacío.

#### Respuesta

```bash
mkdir foo &&
mkdir foo/dummy &&
mkdir foo/empty &&
touch foo/dummy/file1.txt foo/dummy/file2.txt &&
echo "Me encanta la bash" >> foo/dummy/file1.txt
```

---

---

### 2. Mediante comandos de bash, vuelca el contenido de file1.txt a file2.txt y mueve file2.txt a la carpeta empty

El resultado de los comandos ejecutados sobre la jerarquía anterior deben dar el siguiente resultado.

```bash
foo/
├─ dummy/
│  ├─ file1.txt
├─ empty/
  ├─ file2.txt
```

Donde `file1.txt` y `file2.txt` deben contener el siguiente texto:

```bash
Me encanta la bash!!
```

#### Respuesta

```bash
cp foo/dummy/file1.txt foo/dummy/file2.txt &&
mv foo/dummy/file2.txt foo/empty/
```

---

---

### 3. Crear un script de bash que agrupe los pasos de los ejercicios anteriores y además permita establecer el texto de file1.txt alimentándose como parámetro al invocarlo

Si se le pasa un texto vacío al invocar el script, el texto de los ficheros, el texto por defecto será:

```bash
Que me gusta la bash!!!!
```

#### Respuesta

```bash
#!/bin/bash

# Verifica si se proporciona un argumento. Si no se proporciona, usa un texto predeterminado.
if [ $# -eq 0 ]; then
    argument="Que me gusta la bash!!!!"
else
    argument="$1"
fi

# Ejercicio 1
mkdir foo &&
mkdir foo/dummy &&
mkdir foo/empty &&
touch foo/dummy/file1.txt foo/dummy/file2.txt &&
echo "$argument" >> foo/dummy/file1.txt

# Ejercicio 2
cp foo/dummy/file1.txt foo/dummy/file2.txt &&
mv foo/dummy/file2.txt foo/empty/
```

- Script - [Ejercicio3.sh](./scripts/ejercicio3.sh)

- Ejecución:
  ```
  $ sh ejercicio3.sh "LemonCode"
  ```
  Este comando ejecutará el script e insertará el texto "LemonCode" en el archivo "file1.txt"

---

---

### 4. Crea un script de bash que descargue el contenido de una página web a un fichero y busque en dicho fichero una palabra dada como parámetro al invocar el script

La URL de dicha página web será una constante en el script.

Si tras buscar la palabra no aparece en el fichero, se mostrará el siguiente mensaje:

```bash
$ ejercicio4.sh patata
> No se ha encontrado la palabra "patata"
```

Si por el contrario la palabra aparece en la búsqueda, se mostrará el siguiente mensaje:

```bash
$ ejercicio4.sh patata
> La palabra "patata" aparece 3 veces
> Aparece por primera vez en la línea 27
```

#### Respuesta

```bash
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
```

- Script - [Ejercicio4.sh](./scripts/ejercicio4.sh)

- Ejecución:

  ```
  $ sh ejercicio4.sh madrid
  ```

  Este comando ejecutará el script buscará la palabra madrid dentro del fichero
  En este caso como constante tiene el artículo de Madrid de la Wikipedia

  ```
  La palabra "madrid" aparece     2973 veces.
  Aparece por primera vez en la línea 5.
  ```

---

---

### 5. OPCIONAL - Modifica el ejercicio anterior de forma que la URL de la página web se pase por parámetro y también verifique que la llamada al script sea correcta

Si al invocar el script este no recibe dos parámetros (URL y palabra a buscar), se deberá de mostrar el siguiente mensaje:

```bash
$ ejercicio5.sh https://lemoncode.net/ patata 27
> Se necesitan únicamente dos parámetros para ejecutar este script
```

Además, si la palabra sólo se encuentra una vez en el fichero, se mostrará el siguiente mensaje:

```bash
$ ejercicio5.sh https://lemoncode.net/ patata
> La palabra "patata" aparece 1 vez
> Aparece únicamente en la línea 27
```

#### Respuesta

```bash
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
        echo "La palabra \"$searchWord\" aparece $appearCount veces."
    fi
    echo "Aparece por primera vez en la línea $firstLine."
else
    echo "No se ha encontrado la palabra \"$searchWord\"."
fi
rm temp.html
```

- Script - [Ejercicio5.sh](./scripts/ejercicio5.sh)

- Ejecución:

  ```
  $ sh ejercicio5.sh https://lemoncode.net/ front
  ```

  Este comando ejecutará el script y buscará la palabra "front" dentro del fichero
  En este caso como parametro de "URL" he utilizado la página de LemonCode

  ```
  La palabra "front" aparece        8 veces.
  Aparece por primera vez en la línea 80.
  ```
