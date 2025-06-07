#!/bin/sh

# Crea la carpeta y el archivo .htpasswd con usuario: sotypot, pass: admin123

sudo mkdir -p dist/htpasswd
sudo htpasswd -bc dist/htpasswd/.htpasswd sotypot admin123
sudo chmod +x create-htpasswd.sh
