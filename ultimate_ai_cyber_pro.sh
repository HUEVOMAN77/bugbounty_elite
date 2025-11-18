#!/bin/bash

##############################################
#   ULTIMATE AI CYBER SUITE PRO 2025
#   Menú visual + IA total
#   Creado por: HUEVOMAN77 🕷️🔥
##############################################

# Colores
GREEN="\e[32m"
CYAN="\e[36m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# API IA gratuita
AI_API="https://api.gpteverywhere.org/v1/free"

ai() {
    curl -s -X POST "$AI_API" \
    -H "Content-Type: application/json" \
    -d "{\"prompt\":\"$1\"}" | jq -r '.response'
}

# Banner inicial
banner() {
    clear
    echo -e "${CYAN}"
    echo "██████╗ ██╗   ██╗███████╗██████╗  ██████╗ ███╗   ███╗ █████╗ ███╗  ██╗"
    echo "██╔══██╗██║   ██║██╔════╝██╔══██╗██╔═══██╗████╗ ████║██╔══██╗████╗ ██║"
    echo "██████╔╝██║   ██║█████╗  ██████╦╝██║   ██║██╔████╔██║███████║██╔██╗██║"
    echo "██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗██║   ██║██║╚██╔╝██║██╔══██║██║╚████║"
    echo "██║  ██║ ╚████╔╝ ███████╗██████╦╝╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚███║"
    echo "╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝"
    echo "                 Creado por: HUEVOMAN77 🕷️🔥"
    echo -e "${RESET}\n"
}

# Menú principal
menu() {
    banner
    echo -e "${GREEN}[1] Subdomain Scanner Normal${RESET}"
    echo -e "${GREEN}[2] Subdomain Scanner IA (solo funcionales)${RESET}"
    echo -e "${GREEN}[3] Auto-Pentest IA${RESET}"
    echo -e "${GREEN}[4] Escaneo de Puertos (Nmap)${RESET}"
    echo -e "${GREEN}[5] Payloads HTTP Injector / HA Tunnel IA${RESET}"
    echo -e "${GREEN}[6] BugHost / SNI IA${RESET}"
    echo -e "${GREEN}[7] Generar Reporte Profesional${RESET}"
    echo -e "${RED}[0] Salir${RESET}"
    echo ""
    read -p "Selecciona opción: " option

    case $option in
        1) subdomains_normal ;;
        2) subdomains_ia ;;
        3) autopentest_ia ;;
        4) scan_ports ;;
        5) payloads_ia ;;
        6) bughost_ia ;;
        7) report_ia ;;
        0) echo "Saliendo..."; exit ;;
        *) echo -e "${RED}Opción inválida${RESET}"; sleep 1; menu ;;
    esac
}

# Funciones
subdomains_normal() {
    read -p "Dominio objetivo: " dom
    echo -e "${CYAN}Buscando subdominios...${RESET}"
    curl -s "https://api.hackertarget.com/hostsearch/?q=$dom" | cut -d',' -f1
    read -p "Presiona Enter para volver al menú..."
    menu
}

subdomains_ia() {
    read -p "Dominio principal: " dom
    echo -e "${CYAN}Generando subdominios con IA y verificando funcionalidad...${RESET}"
    ai "Genera 50 subdominios probables del dominio $dom, uno por línea" > ai_raw.txt
    > valid_subs.txt
    while read s; do
        if ping -c 1 -W 1 "$s" &> /dev/null || curl -s -I "$s" | grep "200\|302" &> /dev/null; then
            echo -e "${GREEN}[OK] $s${RESET}" | tee -a valid_subs.txt
        else
            echo -e "${RED}[X] $s${RESET}"
        fi
    done < ai_raw.txt
    echo -e "${YELLOW}Subdominios funcionales guardados en valid_subs.txt${RESET}"
    read -p "Presiona Enter para volver al menú..."
    menu
}

autopentest_ia() {
    read -p "Dominio/IP objetivo: " target
    echo -e "${CYAN}Ejecutando Auto-Pentest IA...${RESET}"
    ports=$(nmap -Pn --top-ports 100 "$target")
    subs=$(cat valid_subs.txt 2>/dev/null || echo "No hay subdominios")
    report=$(ai "Analiza este dominio: $target, puertos: $ports y subdominios: $subs. Genera un informe de pentest PRO con vulnerabilidades y recomendaciones.")
    echo "$report" | tee pentest_report.txt
    echo -e "${YELLOW}Reporte guardado: pentest_report.txt${RESET}"
    read -p "Presiona Enter para volver al menú..."
    menu
}

scan_ports() {
    read -p "IP/Dominio: " t
    echo -e "${CYAN}Escaneando puertos abiertos...${RESET}"
    nmap -Pn -sV "$t"
    read -p "Presiona Enter para volver al menú..."
    menu
}

payloads_ia() {
    read -p "Dominio para payloads: " d
    echo -e "${CYAN}Generando payloads IA...${RESET}"
    ai "Crea payloads profesionales para HTTP Injector, HTTP Custom, HA Tunnel, usando el host $d. Incluye GET, CONNECT, SSL, PROXY, headers válidos." | tee payloads_$d.txt
    echo -e "${YELLOW}Guardado en payloads_$d.txt${RESET}"
    read -p "Presiona Enter para volver al menú..."
    menu
}

bughost_ia() {
    read -p "Operador (ej: claro, tigo): " op
    read -p "Dominio base/IP: " base
    ai "Genera 40 bughosts/SNI válidos para tunel VPN del operador $op basados en $base, línea por línea." | tee bughost_$op.txt
    echo -e "${YELLOW}Guardado en bughost_$op.txt${RESET}"
    read -p "Presiona Enter para volver al menú..."
    menu
}

report_ia() {
    echo -e "${CYAN}Generando reporte general IA...${RESET}"
    ai "Genera un reporte profesional completo en texto sobre subdominios funcionales, payloads, bughosts y pentesting." | tee reporte_general.txt
    echo -e "${YELLOW}Guardado en reporte_general.txt${RESET}"
    read -p "Presiona Enter para volver al menú..."
    menu
}

# Ejecuta menú
menu
