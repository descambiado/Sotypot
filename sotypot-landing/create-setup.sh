#!/bin/sh

# Crear carpeta htpasswd si no existe
mkdir -p dist/htpasswd
sudo chmod +x create-setup.sh

# Crear archivo .htpasswd con usuario sotypot y contraseña sotypot!
htpasswd -bc dist/htpasswd/.htpasswd sotypot sotypot!

# Crear carpeta para certificados
mkdir -p dist/certs

# Crear certificado SSL autofirmado (válido 365 días)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout dist/certs/nginx.key \
  -out dist/certs/nginx.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

echo "Setup completado: .htpasswd y certificados SSL generados."
