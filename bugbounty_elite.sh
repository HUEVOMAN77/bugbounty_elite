#!/data/data/com.termux/files/usr/bin/bash
# =========================================================
# BUG BOUNTY ELITE FRAMEWORK
# Creator: HUEVOMAN77
# Recon • Fuerza Bruta • Subdominios Vivos
# =========================================================

# ===== PATH BLINDADO (NUNCA FALLA) =====
export PATH=$PATH:$HOME/go/bin

# ===== COLORES =====
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

START_TIME=$(date +%s)

# ===== BANNER =====
banner() {
clear
echo -e "${CYAN}"
cat << "EOF"
██████╗ ██╗   ██╗ ██████╗ ███████╗██████╗ ██╗   ██╗
██╔══██╗██║   ██║██╔════╝ ██╔════╝██╔══██╗██║   ██║
██████╔╝██║   ██║██║  ███╗█████╗  ██████╔╝██║   ██║
██╔══██╗██║   ██║██║   ██║██╔══╝  ██╔══██╗██║   ██║
██████╔╝╚██████╔╝╚██████╔╝███████╗██║  ██║╚██████╔╝
╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝
EOF
echo -e "${RESET}"
echo -e "${MAGENTA}⚡ BUG BOUNTY ELITE FRAMEWORK ⚡${RESET}"
echo -e "${GREEN}Creator: HUEVOMAN77${RESET}"
echo -e "${CYAN}Recon Profesional • Fuerza Bruta • Subdominios Vivos${RESET}"
echo "----------------------------------------------------"
}

# ===== TIEMPO =====
show_time() {
NOW=$(date +%s)
ELAPSED=$((NOW - START_TIME))
echo -e "${YELLOW}Tiempo activo: ${ELAPSED}s${RESET}"
}

# ===== DEPENDENCIAS =====
need_cmd() {
command -v "$1" >/dev/null 2>&1
}

install_go() {
if ! need_cmd go; then
  echo -e "${YELLOW}[+] Instalando Go...${RESET}"
  pkg install golang -y
fi
}

install_shuffledns() {
if ! need_cmd shuffledns; then
  echo -e "${YELLOW}[+] shuffledns no encontrado. Instalando automáticamente...${RESET}"
  install_go
  go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
  hash -r
fi

if ! need_cmd shuffledns; then
  echo -e "${RED}[!] Error instalando shuffledns${RESET}"
  support
  exit 1
fi
}

check_tools() {
TOOLS=(amass httpx nmap nuclei ffuf)
for t in "${TOOLS[@]}"; do
  if ! need_cmd "$t"; then
    echo -e "${RED}[!] Falta $t${RESET}"
  fi
done
}

# ===== SOPORTE =====
support() {
echo
echo -e "${RED}[!] Si algo falla, soporte oficial:${RESET}"
echo -e "${CYAN}👉 https://www.facebook.com/profile.php?id=100092597257349${RESET}"
echo
}

# ===== SCORING BUG BOUNTY =====
score() {
SUBS=$(wc -l < subs_all.txt 2>/dev/null || echo 0)
LIVE=$(wc -l < live.txt 2>/dev/null || echo 0)
VULNS=$(wc -l < nuclei.txt 2>/dev/null || echo 0)

SCORE=$((LIVE*2 + VULNS*10))

echo -e "${GREEN}"
echo "====== BUG BOUNTY SCORE ======"
echo "Subdominios totales : $SUBS"
echo "Subdominios vivos   : $LIVE"
echo "Vulnerabilidades   : $VULNS"
echo "------------------------------"
echo "SCORE FINAL        : $SCORE"
echo "=============================="
echo -e "${RESET}"
}

# ===== FUNCIONES =====
run_amass() {
read -p "Dominio: " DOMAIN
amass enum -passive -d "$DOMAIN" -o amass.txt
}

dns_bruteforce() {
read -p "Dominio: " DOMAIN
read -p "Wordlist: " WORDLIST
shuffledns -d "$DOMAIN" -w "$WORDLIST" -r resolvers.txt -o brute.txt
}

merge_subs() {
cat amass.txt brute.txt 2>/dev/null | sort -u > subs_all.txt
}

live_subs() {
httpx -l subs_all.txt -silent -o live.txt
}

run_ffuf() {
read -p "URL (https://site/FUZZ): " URL
read -p "Wordlist: " WORDLIST
ffuf -u "$URL" -w "$WORDLIST"
}

run_nmap() {
read -p "Host/IP: " HOST
nmap -sV -Pn "$HOST"
}

run_nuclei() {
nuclei -l live.txt -o nuclei.txt
}

screenshots() {
echo -e "${YELLOW}[+] Usa gowitness manualmente si deseas screenshots${RESET}"
}

auto_all() {
run_amass
dns_bruteforce
merge_subs
live_subs
run_nuclei
score
}

# ===== MENÚ =====
menu() {
banner
show_time
echo
echo "1) Amass (subdominios)"
echo "2) DNS Brute Force (shuffledns)"
echo "3) Unir subdominios"
echo "4) Detectar vivos (httpx)"
echo "5) FFUF"
echo "6) Nmap"
echo "7) Nuclei"
echo "8) Screenshots"
echo "9) TODO AUTOMÁTICO"
echo "10) Bug Bounty Score"
echo "0) Salir"
echo
read -p ">> " OPT

case $OPT in
1) run_amass ;;
2) dns_bruteforce ;;
3) merge_subs ;;
4) live_subs ;;
5) run_ffuf ;;
6) run_nmap ;;
7) run_nuclei ;;
8) screenshots ;;
9) auto_all ;;
10) score ;;
0) exit 0 ;;
*) echo "Opción inválida" ;;
esac
read -p "Enter para continuar..."
}

# ===== MAIN =====
install_shuffledns
check_tools

while true; do
menu
done
