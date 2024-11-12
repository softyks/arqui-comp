#!/bin/bash

# Rendimiento de la CPU
verificar_cpu() {
    echo "==============================="
    echo "          USO DE CPU           "
    echo "==============================="
    uptime
    echo ""
}

# Uso de memoria
verificar_memoria() {
    echo "==============================="
    echo "        USO DE MEMORIA         "
    echo "==============================="
    free -h
    echo ""
}

# Uso de disco
verificar_disco() {
    echo "==============================="
    echo "         USO DE DISCO          "
    echo "==============================="
    df -h
    echo ""
}

# Procesos que más consumen CPU y memoria
procesos_altos() {
    echo "==============================="
    echo "     PROCESOS CONSUMIDORES     "
    echo "==============================="
    echo "Top 5 procesos por uso de CPU:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
    echo ""
    echo "Top 5 procesos por uso de Memoria:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
    echo ""
}

# Funciones
verificar_cpu
verificar_memoria
verificar_disco
procesos_altos
