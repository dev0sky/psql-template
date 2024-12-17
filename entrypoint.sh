#!/bin/sh

# Reemplazar las variables de entorno en el archivo template y guardar el resultado en init.sql
envsubst '${PSQL_NAME} ${PSQL_USER} ${PSQL_PASSWORD} ${ENCODING} ${LANGUAGE_CODE}' < /docker-entrypoint-initdb.d/init.conf.template > /docker-entrypoint-initdb.d/init.sql

# Verificar si el archivo se creó correctamente
if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    echo "Archivo init.sql creado correctamente."
else
    echo "Error al crear el archivo init.sql."
    exit 1
fi

# Ejecutar el comando original de entrada de PostgreSQL
exec docker-entrypoint.sh "$@"