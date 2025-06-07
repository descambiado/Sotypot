# Dockerfile para la landing de SotyPot

FROM nginx:alpine

# Copia del HTML y configuración personalizada
COPY dist/html/ /usr/share/nginx/html/
COPY dist/conf/nginx.conf /etc/nginx/nginx.conf

# Copia archivo .htpasswd para autenticación básica
COPY dist/htpasswd/.htpasswd /etc/nginx/.htpasswd

# Copia certificados SSL (asegúrate que existan en dist/certs)
COPY dist/certs/ /etc/nginx/certs/

# Exponer puertos HTTP y HTTPS
EXPOSE 80 443

# Comando para iniciar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
