# Utilizar la imagen oficial de PostgreSQL
FROM postgres:17 

# Instalar gettext para usar envsubst
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Verificar la instalación de gettext
RUN which envsubst && envsubst --version

# Copiar el archivo de inicialización y el script de entrada al contenedor
COPY init.d/init.conf.template /config/init.conf.template
COPY entrypoint.sh /

# Verificar que los archivos se hayan copiado correctamente
RUN ls -l /config/init.conf.template && ls -l /entrypoint.sh

# Hacer ejecutable el script de entrada
RUN chmod +x /entrypoint.sh

# Verificar que el script de entrada sea ejecutable
RUN ls -l /entrypoint.sh

# Usar el entrypoint personalizado
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto para iniciar PostgreSQL
CMD ["postgres"]