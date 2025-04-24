#!/usr/bin/env bash

myINSTALL_NOTIFICATION="### Instalando paquetes requeridos ..."
myUSER=$(whoami)
myTPOT_CONF_FILE="/home/${myUSER}/tpotce/.env"
myPACKAGES_DEBIAN="ansible apache2-utils cracklib-runtime wget"
myPACKAGES_FEDORA="ansible cracklib httpd-tools wget"
myPACKAGES_ROCKY="ansible-core ansible-collection-redhat-rhel_mgmt epel-release cracklib httpd-tools wget"
myPACKAGES_OPENSUSE="ansible apache2-utils cracklib wget"


myINSTALLER=$(cat << "EOF"
 .--.       .-.                   .-. 
: .--'     .' `.                 .' `.
`. `.  .--.`. .'.-..-..---.  .--.`. .'
 _`, :' .; :: : : :; :: .; `' .; :: : 
`.__.'`.__.':_; `._. ;: ._.'`.__.':_; 
                 .-. :: :             
                 `._.':_; 
  Gracias a @Tpot-CE
  Versión 24.04.x
  Modificado por @Davidhernan3
EOF
)

# Check if running with root privileges
if [ ${EUID} -eq 0 ];
  then
    echo "This script should not be run as root. Please run it as a regular user."
    echo
    exit 1
fi

# Check if running on a supported distribution
mySUPPORTED_DISTRIBUTIONS=("AlmaLinux" "Debian GNU/Linux" "Fedora Linux" "openSUSE Tumbleweed" "Raspbian GNU/Linux" "Rocky Linux" "Ubuntu")
myCURRENT_DISTRIBUTION=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

if [[ ! " ${mySUPPORTED_DISTRIBUTIONS[@]} " =~ " ${myCURRENT_DISTRIBUTION} " ]];
  then
    echo "### Only the following distributions are supported: AlmaLinux, Fedora, Debian, openSUSE Tumbleweed, Rocky Linux and Ubuntu."
    echo "### Please follow the T-Pot documentation on how to run T-Pot on macOS, Windows and other currently unsupported platforms."
    echo
    exit 1
fi

# Begin of Installer
echo "$myINSTALLER"
echo
echo
echo "### Este script instalará SotyPot x T-Pot y todas sus dependencias."
while [ "${myQST}" != "y" ] && [ "${myQST}" != "n" ];
  do
    echo
    read -p "### ¿Instalar? (y/n) " myQST
    echo
  done
if [ "${myQST}" = "n" ];
  then
    echo
    echo "### ¡Instalación cancelada!"
    echo
    exit 0
fi

# Install packages based on the distribution
case ${myCURRENT_DISTRIBUTION} in
  "Fedora Linux")
    echo
    echo ${myINSTALL_NOTIFICATION}
    echo
    sudo dnf -y --refresh install ${myPACKAGES_FEDORA}
    ;;
  "Debian GNU/Linux"|"Raspbian GNU/Linux"|"Ubuntu")
    echo
    echo ${myINSTALL_NOTIFICATION}
    echo
    if ! command -v sudo >/dev/null;
      then
        echo "### ‘sudo‘ no está instalado. Para continuar necesitas proporcionar la contraseña de ‘root‘"
        echo "### o presiona CTRL-C para instalar ‘sudo‘ manualmente y agregar tu usuario a los sudoers."
        echo
        su -c "apt -y update && \
               NEEDRESTART_SUSPEND=1 apt -y install sudo ${myPACKAGES_DEBIAN} && \
               /usr/sbin/usermod -aG sudo ${myUSER} && \
               echo '${myUSER} ALL=(ALL:ALL) ALL' | tee /etc/sudoers.d/${myUSER} >/dev/null && \
               chmod 440 /etc/sudoers.d/${myUSER}"
        echo "### Necesitamos sudo para Ansible, ingresa la contraseña de sudo ..."
        sudo echo "### ... privilegios de sudo obtenidos para Ansible."
        echo
      else
        sudo apt update
        sudo NEEDRESTART_SUSPEND=1 apt install -y ${myPACKAGES_DEBIAN}
    fi
    ;;
  "openSUSE Tumbleweed")
    echo
    echo ${myINSTALL_NOTIFICATION}
    echo
    sudo zypper refresh
    sudo zypper install -y ${myPACKAGES_OPENSUSE}
    echo "export ANSIBLE_PYTHON_INTERPRETER=/bin/python3" | sudo tee /etc/profile.d/ansible.sh >/dev/null
    source /etc/profile.d/ansible.sh
    ;;
  "AlmaLinux"|"Rocky Linux")
    echo
    echo ${myINSTALL_NOTIFICATION}
    echo
    sudo dnf -y --refresh install ${myPACKAGES_ROCKY}
    ansible-galaxy collection install ansible.posix
    ;;
esac
echo

# Define tag for Ansible
myANSIBLE_DISTRIBUTIONS=("Fedora Linux" "Debian GNU/Linux" "Raspbian GNU/Linux" "Rocky Linux")
if [[ "${myANSIBLE_DISTRIBUTIONS[@]}" =~ "${myCURRENT_DISTRIBUTION}" ]];
  then
    myANSIBLE_TAG=$(echo ${myCURRENT_DISTRIBUTION} | cut -d " " -f 1)
  else
    myANSIBLE_TAG=${myCURRENT_DISTRIBUTION}
fi

# Download tpot.yml if not found locally
if [ ! -f installer/install/tpot.yml ] && [ ! -f tpot.yml ];
  then
    echo "### Now downloading T-Pot Ansible Installation Playbook ... "
    wget -qO tpot.yml https://raw.githubusercontent.com/telekom-security/tpotce/master/installer/install/tpot.yml
    myANSIBLE_TPOT_PLAYBOOK="tpot.yml"
    echo
  else
    echo "### Using local T-Pot Ansible Installation Playbook ... "
    if [ -f "installer/install/tpot.yml" ];
      then
        myANSIBLE_TPOT_PLAYBOOK="installer/install/tpot.yml"
      else
        myANSIBLE_TPOT_PLAYBOOK="tpot.yml"
    fi
fi

# Check type of sudo access
sudo -n true > /dev/null 2>&1
if [ $? -eq 1 ];
  then
    myANSIBLE_BECOME_OPTION="--ask-become-pass"
    echo "### No se obtuvieron privilegios de sudo, configurando opción de Ansible a ${myANSIBLE_BECOME_OPTION}."
    echo "### Ansible pedirá la ‘BECOME password‘ que normalmente es tu contraseña de sudo."
    echo
  else
    myANSIBLE_BECOME_OPTION="--become"
    echo "### Privilegios de sudo obtenidos, configurando opción de Ansible a ${myANSIBLE_BECOME_OPTION}."
    echo
fi

# Run Ansible Playbook
echo "### Now running T-Pot Ansible Installation Playbook ..."
echo
rm ${HOME}/install_tpot.log > /dev/null 2>&1
ANSIBLE_LOG_PATH=${HOME}/install_tpot.log ansible-playbook ${myANSIBLE_TPOT_PLAYBOOK} -i 127.0.0.1, -c local --tags "${myANSIBLE_TAG}" ${myANSIBLE_BECOME_OPTION}

# Something went wrong
if [ ! $? -eq 0 ];
  then
    echo "### Ocurrió un error con el Playbook, revisa la salida y/o el archivo install_tpot.log para más detalles."
    echo "### Abortando."
    echo
    exit 1
  else
    echo "### Playbook ejecutado exitosamente."
    echo
fi

# Ask for T-Pot Installation Type
echo
echo "### Elija su tipo de instalación T-Pot:"
echo "### (C)olmena - Instalación estándar HIVE."
echo "###             Incluye todo para una configuración distribuida con sensores."
echo "### (S)ensor  - Instalación de sensor T-Pot."
echo "###             Optimizado para instalación distribuida, sin WebUI, Elasticsearch ni Kibana."
echo "### (L)LM     - Instalación LLM."
echo "###             Usa honeypots basados en LLM: Beelzebub y Galah."
echo "###             Requiere Ollama (recomendado) o suscripción a ChatGPT."
echo "### M(i)ni    - Instalación Mini."
echo "###             Ejecuta 30+ honeypots con pocos demonios."
echo "### (M)óvil   - Instalación Mobile."
echo "###             Incluye todo para T-Pot Mobile (disponible por separado)."
echo "### (T)arpit  - Instalación Tarpit."
echo "###             Alimenta datos continuamente a atacantes, bots y escáneres."
echo "###             También ejecuta un honeypot de Denegación de Servicio (ddospot)."
echo
while true; do
  read -p "### Tipo de instalación? (c/s/l/i/m/t) " myTPOT_TYPE
  case "${myTPOT_TYPE}" in
    c|C)
      echo
      echo "### Instalando T-Pot estándar / HIVE."
      myTPOT_TYPE="HIVE"
      cp ${HOME}/tpotce/compose/standard.yml ${HOME}/tpotce/docker-compose.yml
      myINFO=""
      break ;;
    s|S)
      echo
      echo "### Instalando Sensor T-Pot."
      myTPOT_TYPE="SENSOR"
      cp ${HOME}/tpotce/compose/sensor.yml ${HOME}/tpotce/docker-compose.yml
      myINFO="### Asegúrate de implementar llaves SSH en este SENSOR y deshabilitar la autenticación por contraseña SSH.
### En el HIVE ejecuta el script tpotce/deploy.sh para unir este SENSOR al HIVE."
      break ;;
    l|L)
      echo
      echo "### Instalando T-Pot LLM."
      myTPOT_TYPE="HIVE"
      cp ${HOME}/tpotce/compose/llm.yml ${HOME}/tpotce/docker-compose.yml
      myINFO="Asegúrate de configurar el archivo .env con los ajustes de Ollama/ChatGPT."
      break ;;
    i|I)
      echo
      echo "### Instalando T-Pot Mini."
      myTPOT_TYPE="HIVE"
      cp ${HOME}/tpotce/compose/mini.yml ${HOME}/tpotce/docker-compose.yml
      myINFO=""
      break ;;
    m|M)
      echo
      echo "### Instalando T-Pot Móvil."
      myTPOT_TYPE="MOBILE"
      cp ${HOME}/tpotce/compose/mobile.yml ${HOME}/tpotce/docker-compose.yml
      myINFO=""
      break ;;
    t|T)
      echo
      echo "### Instalando T-Pot Tarpit."
      myTPOT_TYPE="HIVE"
      cp ${HOME}/tpotce/compose/tarpit.yml ${HOME}/tpotce/docker-compose.yml
      myINFO=""
      break ;;
  esac
done

if [ "${myTPOT_TYPE}" == "HIVE" ];
  # If T-Pot Type is HIVE ask for WebUI username and password
  then
	# Preparing web user for T-Pot
	echo
	echo "### T-Pot User Configuration ..."
	echo
	# Asking for web user name
	myWEB_USER=""
	while [ 1 != 2 ];
	  do
	    myOK=""
	    read -rp "### Ingrese su nombre de usuario web: " myWEB_USER
	    myWEB_USER=$(echo $myWEB_USER | tr -cd "[:alnum:]_.-")
	    echo "### Nombre de usuario: ${myWEB_USER}"
	    while [[ ! "${myOK}" =~ [YyNn] ]];
	      do
	        read -rp "### ¿Es correcto? (y/n) " myOK
	      done
	    if [[ "${myOK}" =~ [Yy] ]] && [ "$myWEB_USER" != "" ];
	      then
	        break
	      else
	        echo
	    fi
	  done

	# Asking for web user password
	myWEB_PW="pass1"
	myWEB_PW2="pass2"
	mySECURE=0
	myOK=""
	while [ "${myWEB_PW}" != "${myWEB_PW2}"  ] && [ "${mySECURE}" == "0" ]
	  do
	    echo
	    while [ "${myWEB_PW}" == "pass1"  ] || [ "${myWEB_PW}" == "" ]
	      do
	        read -rsp "### Ingrese contraseña para el usuario web: " myWEB_PW
	        echo
	      done
	    read -rsp "### Repita la contraseña del usuario web: " myWEB_PW2
	    echo
	    if [ "${myWEB_PW}" != "${myWEB_PW2}" ];
	      then
	        echo "### Las contraseñas no coinciden."
	        myWEB_PW="pass1"
	        myWEB_PW2="pass2"
	    fi
	    mySECURE=$(printf "%s" "$myWEB_PW" | /usr/sbin/cracklib-check | grep -c "OK")
	    if [ "$mySECURE" == "0" ] && [ "$myWEB_PW" == "$myWEB_PW2" ];
	      then
	        while [[ ! "${myOK}" =~ [YyNn] ]];
	          do
	            read -rp "### ¿Mantener contraseña insegura? (y/n) " myOK
	          done
	        if [[ "${myOK}" =~ [Nn] ]] || [ "$myWEB_PW" == "" ];
	          then
	            myWEB_PW="pass1"
	            myWEB_PW2="pass2"
	            mySECURE=0
	            myOK=""
	        fi
	    fi
	done

	# Write username and password to T-Pot config file
	echo "### Creando usuario y contraseña codificados en base64 para el archivo de configuración: ${myTPOT_CONF_FILE}"
	myWEB_USER_ENC=$(htpasswd -b -n "${myWEB_USER}" "${myWEB_PW}")
    myWEB_USER_ENC_B64=$(echo -n "${myWEB_USER_ENC}" | base64 -w0)
    
	echo
	sed -i "s|^WEB_USER=.*|WEB_USER=${myWEB_USER_ENC_B64}|" ${myTPOT_CONF_FILE}
fi

# Pull docker images
echo "### Descargando imágenes de Docker ..."
sudo docker compose -f /home/${myUSER}/tpotce/docker-compose.yml pull
echo

# Show running services
echo "### Verifique posibles conflictos de puertos con honeypots."
echo "### Aunque SSH está configurado, otros servicios como"
echo "### SMTP, HTTP, etc. podrían impedir el inicio de Sotypot y T-Pot."
echo
sudo grc netstat -tulpen
echo

# Done
echo "### Instalación completada. Reinicie el sistema y reconéctese via SSH al puerto tcp/64295."
echo "${myINFO}"
echo
