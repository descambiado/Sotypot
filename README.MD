# 🛡️ SotyPot - Plataforma de Honeypots para Entornos Educativos

![SotyPot Logo](https://i.imgur.com/bLFfnu3.png)

**SotyPot** es una plataforma educativa basada en honeypots, desarrollada por [@Davidhernan3](https://github.com/Davidhernan3) como parte de su Proyecto de Fin de Grado para el ciclo de **Administración de Sistemas Informáticos en Red (ASIR)**.

Está basada en **T-Pot CE**, una distribución de honeypots todo-en-uno, y adaptada para facilitar el aprendizaje, la observación y la simulación de ciberataques reales de forma segura.

---

## 📌 Características Principales

- 🐍 Más de 20 honeypots activos (Cowrie, Dionaea, Wordpot, etc.)
- 📊 Dashboards con Kibana preconfigurados
- 🌐 Landing Page accesible por navegador
- 🐳 Despliegue automatizado con Docker Compose
- 🧪 Validado con herramientas ofensivas como Nmap, Hydra y Metasploit
- 🇪🇸 Interfaz traducida y documentada en español

---

## ⚙️ Requisitos del Sistema

| Componente     | Requisito mínimo           |
|----------------|----------------------------|
| CPU            | 4 núcleos                  |
| RAM            | 8 GB                       |
| Almacenamiento | 128 GB SSD                 |
| SO             | Ubuntu Server 24.04.1 LTS |
| Red            | Sin restricciones de puertos |

---

## 🚀 Instalación Rápida

### 1. 📦 Preparar el sistema

```bash
sudo apt update && sudo apt install -y curl
```

> 💡 Recomendado: entorno limpio de Ubuntu Server 24.04.1 64-bit

---

### 2. 🛠 Ejecutar el instalador automático

```bash
env bash -c "$(curl -sL https://github.com/Davidhernan3/sotypot/raw/main/install.sh)"
```

Esto descargará y configurará automáticamente todos los servicios y contenedores.

---

### 3. 🔄 Finalizar

- Reinicia el sistema si se solicita.
- Accede a `https://<TU_IP>:64297` con las credenciales configuradas durante la instalación.

---

### 4. 🌐 Landing Page

- Navega a `http://<TU_IP>:8887` para acceder a la landing personalizada.
- Si el puerto 8888 está en uso, edita `docker-compose.yml`.
- Para relanzar:

```bash
cd sotypot-landing
docker-compose up -d
```

---

## 🐝 Honeypots Incluidos

| Honeypot       | Protocolos       | Descripción                         |
|----------------|------------------|-------------------------------------|
| Cowrie         | SSH, Telnet      | Emula sistemas UNIX                 |
| Dionaea        | SMB, HTTP, FTP   | Captura malware                     |
| Elasticpot     | Elasticsearch    | Simula servicios ES vulnerables     |
| AdbHoney       | Android Debug    | Honeypot para dispositivos Android  |
| Wordpot        | HTTP             | Detecta escaneos de WordPress       |

> 🔎 Lista completa disponible en `/tpotce-master/docker/`

---

## 🧩 Configuración Avanzada

### Editar honeypots:

```bash
nano tpotce-master/docker/<honeypot>/docker-compose.yml
docker restart <contenedor>
```

### Variables útiles:

```bash
echo "TPOT_FLAVOR=standard" >> ~/tpotce/.env
echo "TPOT_OSTYPE=linux" >> ~/tpotce/.env
```

---

## 🐛 Solución de Problemas
|-----------------------------|------------------------------------------------|
| Problema                    | Solución                                       |
|-----------------------------|------------------------------------------------|
| Kibana no carga             | Verifica Elasticsearch y reinicia contenedor   |
| Landing en blanco (404)     | Asegura `index.html` en `dist/html/`           |
| Puerto ocupado              | Cambia en `docker-compose.yml` y reinicia      |
| IP dinámica cambia          | Asigna IP estática en `/etc/netplan`           |
|-----------------------------|------------------------------------------------|

---

## ❓ Preguntas Frecuentes (FAQ)

**¿Cómo accedo a Kibana directamente?**  
📍 `https://<tu-ip>:64297` – Credenciales establecidas durante la instalación

**¿Cómo actualizo SotyPot?**  
```bash
cd ~/tpotce && sudo ./update.sh
```

**¿Dónde se almacenan los datos?**  
📁 Logs en Elasticsearch, visibles en Kibana

**¿Cómo personalizo dashboards?**  
Exporta/Importa desde la interfaz de Kibana

---

## 🧭 Roadmap

|----------|-------------|------------------------------------------------------------|
| Versión  | Estado      | Cambios clave
|----------|-------------|------------------------------------------------------------|
| 1.0      | ✅ Final    | Instalación y entorno básico                               |
| 1.2      | ✅ Beta     | Landing personalizada                                      |
| 1.2.5    | ✅ Validada | Pruebas con Nmap, Hydra, Metasploit                        |
| 1.3      | ✅ Validada | SSL + Auth                                                 |
| 1.4      | 🚧 Futuro   | Documentacion Español + Sistema de alertas por Correo      |
| 1.5      | 🚧 Futuro   | Dashboard dinámico + integración Grafana/elastic en Lading |
|----------|-------------|------------------------------------------------------------|

---

## 🧪 Pruebas Técnicas Realizadas

✅ Escaneo Nmap detectado por Suricata  
✅ Ataques SSH detectados por Cowrie  
✅ Peticiones HTTP registradas en Wordpot  
✅ Escaneo con Nikto reflejado en Kibana  
✅ Exploit Metasploit bloqueado y registrado  

> 📄 Ver informe completo: [`SotyPot_Informe_Pruebas_Completo_18052025`](./Documentacion/SotyPot_Informe_Pruebas_Completo_18052025.pdf)

---

## 📚 Documentación y Recursos

- [Tutorial de instalación paso a paso (PDF)](./Documentacion/%20de%20Instalación%20y%20Configuración%20de%20SOTYPOT.pdf)
- [Informe técnico y memoria del proyecto](./Documentacion/[VERSION%201.25%20BETA]%20SotyPot_%20Sistema%20de%20Detección%20y%20Registro%20de%20Ataques%20en%20Redes%20Empresariales.pdf)
- [Repositorio base de T-Pot CE](https://github.com/telekom-security/tpotce)

---

## 👨‍💻 Autor

**David Hernández Jiménez**  
📧 [fp_hernandezdavid@ciudadjardin.org](mailto:fp_hernandezdavid@ciudadjardin.org)  
🔗 [@Davidhernan3](https://github.com/Davidhernan3)

---

## 📄 Licencia

```text
Este proyecto está bajo la licencia:
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International

https://creativecommons.org/licenses/by-nc-sa/4.0/
```
