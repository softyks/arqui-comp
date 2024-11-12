#!/bin/bash

# NMAP
echo "Detectando la distribución de Linux..."

if [ -f /etc/debian_version ]; then
    # Para Debian, Ubuntu y derivados
    echo "Sistema basado en Debian detectado. Instalando nmap..."
    sudo apt update
    sudo apt install -y nmap

elif [ -f /etc/redhat-release ]; then
    # Para Red Hat, CentOS, Fedora
    echo "Sistema basado en Red Hat detectado. Instalando nmap..."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y nmap
    else
        sudo yum install -y nmap
    fi

elif [ -f /etc/arch-release ]; then
    # Para Arch Linux y derivados
    echo "Sistema basado en Arch Linux detectado. Instalando nmap..."
    sudo pacman -Sy nmap --noconfirm

else
    echo "Distribución no reconocida. Por favor, instala nmap manualmente."
    exit 1
fi

# Comprobar si la instalación fue exitosa
if command -v nmap &> /dev/null; then
    echo "nmap se ha instalado correctamente."
    nmap --version
else
    echo "Hubo un problema al instalar nmap."
fi


# net-tools
install_net_tools() {
    if [ -x "$(command -v apt)" ]; then
        echo "Instalando net-tools en Ubuntu/Debian..."
        sudo apt update
        sudo apt install -y net-tools
    elif [ -x "$(command -v yum)" ]; then
        echo "Instalando net-tools en CentOS/RHEL..."
        sudo yum install -y net-tools
    elif [ -x "$(command -v dnf)" ]; then
        echo "Instalando net-tools en Fedora..."
        sudo dnf install -y net-tools
    else
        echo "Gestor de paquetes no compatible. Instala net-tools manualmente."
        exit 1
    fi
}

# Verificar si net-tools esta instalado
if command -v netstat &> /dev/null; then
    echo "net-tools ya está instalado en el sistema."
else
    echo "net-tools no está instalado. Procediendo a instalarlo..."
    install_net_tools
fi

# Verificar si netstat está disponible después de la instalación
if command -v netstat &> /dev/null; then
    echo "La instalación de net-tools fue exitosa. Puedes usar netstat."
else
    echo "La instalación falló o netstat no está disponible."
fi

# Puertos abiertos en el sistema
echo "--> Puertos abiertos en el sistema <--"
sudo netstat -tuln | grep LISTEN

# Escaneo de puertos con nmap en la red local
echo "--> Escaneo de puertos comunes en el sistema <--"
sudo nmap -sS -Pn localhost

# Configuraciones críticas del firewall
echo "--> Comprobando configuración de firewall (iptables) <--"
sudo iptables -L -n -v

# Servicios de red comunes
services=("ssh" "ftp" "http" "https" "smb" "telnet" "mysql")
for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "Servicio activo: $service"
    else
        echo "Servicio inactivo: $service"
    fi
done

# Comprobacion de SELinux
if command -v sestatus &>/dev/null; then
    echo "--> Estado de SELinux <--"
    sudo sestatus
else
    echo "SELinux no está instalado."
fi

# Comprobacion de AppArmor
if command -v apparmor_status &>/dev/null; then
    echo "--> Estado de AppArmor <--"
    sudo apparmor_status
else
    echo "AppArmor no está instalado."
fi

echo " VERIFICACION DE SEGURIDAD FINALIZADA EXITOSAMENTE "
