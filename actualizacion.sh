#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Sistema operativo
if command -v apt > /dev/null; then
    OS="Debian"
elif command -v dnf > /dev/null; then
    OS="Fedora"
elif command -v yum > /dev/null; then
    OS="CentOS"
else
    echo "No se pudo detectar el gestor de paquetes compatible. El script admite apt, dnf y yum."
    exit 1
fi

# Actualizar el sistema según el gestor de paquetes
if [ "$OS" == "Debian" ]; then
    echo "Actualizando sistema en Debian/Ubuntu..."
    apt update && apt upgrade -y
elif [ "$OS" == "Fedora" ]; then
    echo "Actualizando sistema en Fedora..."
    dnf upgrade --refresh -y
elif [ "$OS" == "CentOS" ]; then
    echo "Actualizando sistema en CentOS..."
    yum update -y
fi

echo "ACTUALIZACION COMPLETADA EXITOSAMENTE"
