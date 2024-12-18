#!/bin/sh

# Función para manejar errores
handle_error() {
    echo "Error: $1"
    exit 1
}

# Verificar que las variables de entorno necesarias estén definidas
[ -z "$PSQL_NAME" ] && handle_error "La variable de entorno PSQL_NAME no está definida."
[ -z "$PSQL_USER" ] && handle_error "La variable de entorno PSQL_USER no está definida."
[ -z "$PSQL_PASSWORD" ] && handle_error "La variable de entorno PSQL_PASSWORD no está definida."
[ -z "$ENCODING" ] && handle_error "La variable de entorno ENCODING no está definida."

# Crear el directorio si no existe
mkdir -p /docker-entrypoint-initdb.d || handle_error "No se pudo crear el directorio /docker-entrypoint-initdb.d."

# Verificar si el archivo init.sql existe y eliminarlo si es necesario
if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    rm -f /docker-entrypoint-initdb.d/init.sql || handle_error "No se pudo eliminar el archivo init.sql."
    echo "Archivo init.sql eliminado correctamente de /docker-entrypoint-initdb.d."
else
    echo "No se encontró el archivo init.sql en /docker-entrypoint-initdb.d."
fi

# Verificar si el archivo init.conf.template existe en la nueva ruta
if [ ! -f /config/init.conf.template ]; then
    handle_error "El archivo init.conf.template no se encuentra en /config."
fi

# Reemplazar las variables de entorno en el archivo template y guardar el resultado en init.sql
envsubst '${PSQL_NAME} ${PSQL_USER} ${PSQL_PASSWORD} ${ENCODING}' < /config/init.conf.template > /docker-entrypoint-initdb.d/init.sql || handle_error "No se pudo crear el archivo init.sql."

# Verificar si el archivo init.sql se creó correctamente
if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    echo "Archivo init.sql creado correctamente en /docker-entrypoint-initdb.d."
else
    handle_error "Error al crear el archivo init.sql en /docker-entrypoint-initdb.d."
fi

# Ejecutar el comando original de entrada de PostgreSQL
exec docker-entrypoint.sh "$@" || handle_error "No se pudo ejecutar docker-entrypoint.sh."