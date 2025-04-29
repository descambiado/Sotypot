# Dockerfile para la landing de SotyPot

FROM nginx:alpine

# Copia del HTML y configuración personalizada
COPY dist/html/ /usr/share/nginx/html/
COPY dist/conf/nginx.conf /etc/nginx/nginx.conf

# Expone el puerto 80 dentro del contenedor
EXPOSE 80

# Comando para iniciar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
