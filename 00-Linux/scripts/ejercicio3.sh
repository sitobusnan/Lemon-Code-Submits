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
