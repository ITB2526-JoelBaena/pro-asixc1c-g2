#!/bin/bash

# =============================================
# SCRIPT DE MESURA AUTOMÀTICA D'AMPLE DE BANDA
# InnovateTech - MySQL 8.0
# =============================================

DB_USER="root"
DB_NAME="innovatetech"
EQUIP=$(hostname)
ID_USUARI_OPERARI=9  # Ramon Mas - usuari operari per defecte

# Colors
VERD='\033[0;32m'
VERMELL='\033[0;31m'
NC='\033[0m'

echo "============================================="
echo " MESURA D'AMPLE DE BANDA - InnovateTech"
echo "============================================="
echo "Executant speedtest..."

# Executem speedtest i capturem els resultats
RESULTAT=$(speedtest-cli --simple 2>/dev/null)

if [ $? -ne 0 ]; then
    echo -e "${VERMELL}ERROR: No s'ha pogut executar speedtest-cli.${NC}"
    exit 1
fi

# Extraiem els valors
PING=$(echo "$RESULTAT" | grep "Ping" | awk '{print $2}')
DOWNLOAD=$(echo "$RESULTAT" | grep "Download" | awk '{print $2}')
UPLOAD=$(echo "$RESULTAT" | grep "Upload" | awk '{print $2}')

echo "Ping:     $PING ms"
echo "Download: $DOWNLOAD Mbit/s"
echo "Upload:   $UPLOAD Mbit/s"

# Determinem si el resultat és acceptable
# Mínim acceptable: 10 Mbps baixada, 5 Mbps pujada, latència < 100ms
RESULTAT_FINAL="acceptable"
NOTES=""

if (( $(echo "$DOWNLOAD < 10" | bc -l) )); then
    RESULTAT_FINAL="no acceptable"
    NOTES="Velocitat de baixada insuficient: ${DOWNLOAD} Mbit/s"
elif (( $(echo "$UPLOAD < 5" | bc -l) )); then
    RESULTAT_FINAL="no acceptable"
    NOTES="Velocitat de pujada insuficient: ${UPLOAD} Mbit/s"
elif (( $(echo "$PING > 100" | bc -l) )); then
    RESULTAT_FINAL="no acceptable"
    NOTES="Latència elevada: ${PING} ms"
else
    NOTES="Mesura automàtica correcta"
fi

echo "Resultat: $RESULTAT_FINAL"

# Inserim a la BD
sudo mysql -u"$DB_USER" "$DB_NAME" -e "
    INSERT INTO Mesures_Bandwidth 
        (data_hora, id_usuari_operari, equip_mesurat, 
        velocitat_baixada, velocitat_pujada, latencia, 
        resultat, notes)
    VALUES 
        (NOW(), $ID_USUARI_OPERARI, '$EQUIP',
        $DOWNLOAD, $UPLOAD, $PING,
        '$RESULTAT_FINAL', '$NOTES');
" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${VERD}Mesura inserida correctament a la BD.${NC}"
else
    echo -e "${VERMELL}ERROR: No s'ha pogut inserir la mesura a la BD.${NC}"
    exit 1
fi

echo "============================================="
