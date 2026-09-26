## 🌐 Landing Page Personalizada (Nginx)

SotyPot incluye una página de bienvenida web personalizada que sirve como punto de entrada visual al proyecto. Esta landing se ejecuta en un contenedor Nginx separado, diseñado para mantener una identidad visual propia y accesible de forma independiente al entorno principal de T-Pot.

### Características

- Servida por Nginx en un contenedor Docker ligero
- Desplegable fácilmente mediante `docker-compose`
- 100% personalizable (HTML/CSS)
- Ideal para presentar el sistema en entorno educativo, demostrativo o empresarial

### Acceso

Una vez desplegado, la página está disponible en:

### Importante

Seguro: https://localhost:8887
Inseguro: http://localhost:8888

> Puedes exponer otro puerto si lo deseas, modificando el `docker-compose.yml`.

### Instrucciones de uso

1. Clona este repositorio y navega a la carpeta `sotypot-landing`
2. Ejecuta `sotypot-landing/create-setup.sh` (Puedes editarlo, son archivos de configuración)
3. Lanza el contenedor con: `docker-compose up -d` dentro de sotypot-landing.
4. Abre el navegador y accede a http://localhost:8887

> **Importante:** `create-setup.sh` genera `dist/htpasswd/.htpasswd` y `dist/certs/` con una
> contraseña y un certificado autofirmado de ejemplo (usuario `sotypot`, contraseña `sotypot!`).
> Ninguno de los dos se distribuye ya en el repositorio: cambia la contraseña en el script antes de
> exponer la landing más allá de `localhost`.



## Estructura

```
sotypot-landing/
├── dist/
│   ├── html/
│   │   └── index.html      # Página personalizada
│   └── conf/
│       └── nginx.conf      # Configuración del servidor
├── Dockerfile
└── docker-compose.yml
└── create-setup.sh
```

## Personalización
Puedes editar libremente dist/html/index.html para adaptar la landing a tu gusto, incluyendo:

Información general del proyecto

Enlaces a dashboards (Grafana, Kibana)

Accesos a documentación, API, o informes

Licencia
Este módulo de la landing puede distribuirse bajo licencia Creative Commons Attribution-NonCommercial-ShareAlike 4.0.
Más información en creativecommons.org/licenses/by-nc-sa/4.0
