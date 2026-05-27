#!/bin/bash

# =============================================
# SCRIPT DE NOTIFICACIONS DISCORD - InnovateTech
# Revisa la taula Avisos i notifica intents
# d'accés no autoritzat
# =============================================

DB_USER="root"
DB_NAME="innovatetech"
WEBHOOK_URL="https://discord.com/api/webhooks/1508723334232277093/QDevgO5dDKxQrfNdjXhz285qjYFnYzzkktvLGNp3mQba22nyNsHpBIz4wkvOgHC_ffwK"
FITXER_CONTROL="/home/admintech/last_avis_id.txt"

# Colors
VERD='\033[0;32m'
VERMELL='\033[0;31m'
NC='\033[0m'

# Obtenim l'últim id_avis processat
if [ -f "$FITXER_CONTROL" ]; then
    LAST_ID=$(cat "$FITXER_CONTROL")
else
    LAST_ID=0
fi

# Obtenim els nous avisos des de l'últim id processat
AVISOS=$(sudo mysql -u"$DB_USER" "$DB_NAME" -s --skip-column-names -e "
    SELECT id_avis, usuari_db, taula_afectada, operacio, data_hora, descripcio
    FROM Avisos
    WHERE id_avis > $LAST_ID
    ORDER BY id_avis ASC;
" 2>/dev/null)

if [ -z "$AVISOS" ]; then
    echo "No hi ha nous avisos."
    exit 0
fi

# Processem cada avís
NOU_LAST_ID=$LAST_ID

while IFS=$'\t' read -r ID USUARI TAULA OPERACIO DATA_HORA DESCRIPCIO; do
    echo "Processant avís $ID..."

    # Construïm el missatge de Discord
    MISSATGE="🚨 **ALERTA DE SEGURETAT - InnovateTech**\n\n"
    MISSATGE+="**ID Avís:** $ID\n"
    MISSATGE+="**Usuari:** $USUARI\n"
    MISSATGE+="**Taula afectada:** $TAULA\n"
    MISSATGE+="**Operació:** $OPERACIO\n"
    MISSATGE+="**Data i hora:** $DATA_HORA\n"
    MISSATGE+="**Descripció:** $DESCRIPCIO"

    # Enviem a Discord
    RESPOSTA=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"$MISSATGE\"}" \
        "$WEBHOOK_URL")

    if [ "$RESPOSTA" -eq 204 ]; then
        echo -e "${VERD}Avís $ID enviat correctament a Discord.${NC}"
    else
        echo -e "${VERMELL}ERROR: No s'ha pogut enviar l'avís $ID. Codi HTTP: $RESPOSTA${NC}"
    fi

    NOU_LAST_ID=$ID

done <<< "$AVISOS"

# Actualitzem l'últim id processat
echo "$NOU_LAST_ID" > "$FITXER_CONTROL"

echo "============================================="
echo "Últim avís processat: $NOU_LAST_ID"
echo "============================================="
