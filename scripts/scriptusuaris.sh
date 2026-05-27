#!/bin/bash

# =============================================
# SCRIPT DE CREACIÓ AUTOMATITZADA D'USUARIS
# InnovateTech - MySQL 8.0
# =============================================

# Configuració de connexió
DB_USER="root"
DB_HOST="localhost"
DB_NAME="innovatetech"
SQL_FILE="usuaris_creats.sql"

# Colors per a missatges
VERD='\033[0;32m'
VERMELL='\033[0;31m'
GROC='\033[1;33m'
NC='\033[0m'

# Rols vàlids
ROLS_VALIDS=("admin" "vendes" "administracio" "treballador")

# =============================================
# FUNCIONS
# =============================================

# Comprova si el rol és vàlid
rol_valid() {
    local rol=$1
    for r in "${ROLS_VALIDS[@]}"; do
        if [ "$r" == "$rol" ]; then
            return 0
        fi
    done
    return 1
}

# Comprova si l'usuari ja existeix a MySQL
usuari_existeix() {
    local usuari=$1
    local host=$2
    resultat=$(sudo mysql -u"$DB_USER" -e \
        "SELECT COUNT(*) FROM mysql.user WHERE user='$usuari' AND host='$host';" \
        -s --skip-column-names 2>/dev/null)
    [ "$resultat" -gt 0 ]
}

# Crea un usuari i assigna el rol
crear_usuari() {
    local usuari=$1
    local contrasenya=$2
    local rol=$3
    local host=$4

    echo -e "${GROC}Processant usuari: $usuari@$host amb rol: $rol${NC}"

    # Comprova si el rol és vàlid
    if ! rol_valid "$rol"; then
        echo -e "${VERMELL}ERROR: Rol '$rol' no vàlid. Rols acceptats: ${ROLS_VALIDS[*]}${NC}"
        return 1
    fi

    # Comprova si l'usuari ja existeix
    if usuari_existeix "$usuari" "$host"; then
        echo -e "${VERMELL}ERROR: L'usuari '$usuari'@'$host' ja existeix a MySQL.${NC}"
        return 1
    fi

    # Sentències SQL
    SQL_CREATE="CREATE USER '$usuari'@'$host' IDENTIFIED BY '$contrasenya';"
    SQL_GRANT="GRANT '$rol' TO '$usuari'@'$host';"
    SQL_DEFAULT="SET DEFAULT ROLE '$rol' TO '$usuari'@'$host';"
    SQL_FILE_GRANT="GRANT FILE ON *.* TO '$usuari'@'$host';"
    SQL_FLUSH="FLUSH PRIVILEGES;"

    # Executa a MySQL
    sudo mysql -u"$DB_USER" -e "
        $SQL_CREATE
        $SQL_GRANT
        $SQL_DEFAULT
        $SQL_FILE_GRANT
        $SQL_FLUSH
    " 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${VERD}Usuari '$usuari'@'$host' creat correctament amb rol '$rol'.${NC}"

        # Afegeix al fitxer .sql
        echo "-- Usuari: $usuari@$host | Rol: $rol" >> "$SQL_FILE"
        echo "$SQL_CREATE" >> "$SQL_FILE"
        echo "$SQL_GRANT" >> "$SQL_FILE"
        echo "$SQL_DEFAULT" >> "$SQL_FILE"
        echo "$SQL_FILE_GRANT" >> "$SQL_FILE"
        echo "$SQL_FLUSH" >> "$SQL_FILE"
        echo "" >> "$SQL_FILE"

        return 0
    else
        echo -e "${VERMELL}ERROR: No s'ha pogut crear l'usuari '$usuari'@'$host'.${NC}"
        return 1
    fi
}

# =============================================
# PROGRAMA PRINCIPAL
# =============================================

echo "============================================="
echo " CREACIÓ AUTOMATITZADA D'USUARIS - InnovateTech"
echo "============================================="
echo ""

# Inicialitza el fitxer .sql
echo "-- =============================================" > "$SQL_FILE"
echo "-- USUARIS CREATS - $(date '+%Y-%m-%d %H:%M:%S')" >> "$SQL_FILE"
echo "-- =============================================" >> "$SQL_FILE"
echo "" >> "$SQL_FILE"

# Demana quants usuaris vol crear
read -p "Quants usuaris vols crear? " NUM_USUARIS

# Valida que sigui un número
if ! [[ "$NUM_USUARIS" =~ ^[0-9]+$ ]] || [ "$NUM_USUARIS" -lt 1 ]; then
    echo -e "${VERMELL}ERROR: Has d'introduir un número vàlid.${NC}"
    exit 1
fi

CREATS=0
ERRORS=0

for ((i=1; i<=NUM_USUARIS; i++)); do
    echo ""
    echo "--- Usuari $i de $NUM_USUARIS ---"
    
    read -p "Nom d'usuari: " USUARI
    read -s -p "Contrasenya: " CONTRASENYA
    echo ""
    read -p "Host (Enter per 'localhost'): " HOST
    HOST=${HOST:-localhost}
    
    echo "Rols disponibles: ${ROLS_VALIDS[*]}"
    read -p "Rol: " ROL

    if crear_usuari "$USUARI" "$CONTRASENYA" "$ROL" "$HOST"; then
        ((CREATS++))
    else
        ((ERRORS++))
    fi
done

# Resum final
echo ""
echo "============================================="
echo -e " Usuaris creats:  ${VERD}$CREATS${NC}"
echo -e " Errors:          ${VERMELL}$ERRORS${NC}"
echo " Fitxer SQL:      $SQL_FILE"
echo "============================================="
