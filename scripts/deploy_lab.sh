#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}=== Démarrage du Purple Team Lab ===${NC}"

# 1. Démarrer les VMs
echo -e "${GREEN}[1/5] Lancement de l'infrastructure Vagrant...${NC}"
vagrant up

# 2. Attendre un peu que le SSH soit prêt
echo -e "${GREEN}[2/5] Attente de la stabilisation réseau (10s)...${NC}"
sleep 10

# 3. Lancer Ansible
echo -e "${GREEN}[3/5] Configuration des serveurs via Ansible...${NC}"
cd ansible

echo " > Installation de Docker..."
ansible-playbook install_docker.yml

echo " > Installation du SIEM (ELK)..."
ansible-playbook install_siem.yml

echo " > Configuration de la Victime..."
ansible-playbook install_victim.yml

echo " > Installation du Phishing..."
ansible-playbook install_phishing.yml

cd ..

echo -e "${GREEN}=== DÉPLOIEMENT TERMINÉ AVEC SUCCÈS ===${NC}"
echo "Accès :"
echo "- Kibana : http://localhost:5601"
echo "- GoPhish : https://10.10.10.10:3333"