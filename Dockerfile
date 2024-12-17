# Utilizar la imagen oficial de PostgreSQL
FROM postgres:17

# Instalar gettext para usar envsubst
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios
RUN mkdir -p /docker-entrypoint-initdb.d/init.d /docker-entrypoint-initdb.d/sql

# Ajustar permisos del directorio
RUN chown -R postgres:postgres /docker-entrypoint-initdb.d

# Copiar el archivo de inicialización y el script de entrada al contenedor
COPY ./init.d/init.conf.template /docker-entrypoint-initdb.d/init.conf.template
COPY ./entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh

# Hacer ejecutable el script de entrada
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh

# Usar el entrypoint personalizado
ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]

# Comando por defecto para iniciar PostgreSQL
CMD ["postgres"]