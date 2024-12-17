# Utilizar la imagen oficial de PostgreSQL
FROM postgres:17

# Copiar el archivo de inicialización al contenedor
COPY init.sql /docker-entrypoint-initdb.d/  