create_db() {
    if [ "$#" -lt 1 ]; then
        echo "Usage: create_db <nom_de_la_base> [utilisateur] [mot_de_passe]"
        return 1
    fi

    local DB_NAME="$1"
    local DB_USER="${2:-root}"  # Par défaut, utilisateur root
    local DB_PASS="${3:-}"      # Mot de passe optionnel

    echo "Création de la base de données '$DB_NAME'..."

    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" -e "CREATE DATABASE \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    else
        mysql -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Base de données '$DB_NAME' créée avec succès !"
    else
        echo "❌ Erreur lors de la création de la base de données."
    fi
}

import_db() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: import_db <nom_de_la_base> <fichier.sql> [utilisateur] [mot_de_passe]"
        return 1
    fi

    local DB_NAME="$1"
    local SQL_FILE="$2"
    local DB_USER="${3:-root}"  # Par défaut, utilisateur root
    local DB_PASS="${4:-}"      # Mot de passe optionnel

    if [ ! -f "$SQL_FILE" ]; then
        echo "❌ Le fichier '$SQL_FILE' n'existe pas."
        return 1
    fi

    echo "🚀 Importation de '$SQL_FILE' dans la base de données '$DB_NAME'..."

    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" "$DB_NAME" < "$SQL_FILE"
    else
        mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Importation réussie dans '$DB_NAME' !"
    else
        echo "❌ Erreur lors de l'importation."
    fi
}

list_db() {
    local DB_USER="${1:-root}"  # Par défaut, utilisateur root
    local DB_PASS="${2:-}"      # Mot de passe optionnel

    echo "📜 Liste des bases de données :"

    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" -e "SHOW DATABASES;"
    else
        mysql -u "$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;"
    fi
}


drop_db() {
    if [ "$#" -lt 1 ]; then
        echo "Usage: drop_db <nom_de_la_base> [utilisateur] [mot_de_passe]"
        return 1
    fi

    local DB_NAME="$1"
    local DB_USER="${2:-root}"  # Par défaut, utilisateur root
    local DB_PASS="${3:-}"      # Mot de passe optionnel

    echo "⚠️  Attention : Cette action supprimera définitivement la base de données '$DB_NAME'."
    read -p "Voulez-vous continuer ? (oui/non) : " confirm

    if [[ "$confirm" != "oui" ]]; then
        echo "❌ Suppression annulée."
        return 1
    fi

    echo "🗑 Suppression de la base de données '$DB_NAME'..."

    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" -e "DROP DATABASE \`$DB_NAME\`;"
    else
        mysql -u "$DB_USER" -p"$DB_PASS" -e "DROP DATABASE \`$DB_NAME\`;"
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Base de données '$DB_NAME' supprimée avec succès !"
    else
        echo "❌ Erreur lors de la suppression de la base de données."
    fi
}

open() {
    local file="${1:-.}"  # Par défaut, ouvre le dossier courant

    if [ ! -e "$file" ]; then
        echo "❌ Le fichier ou dossier '$file' n'existe pas."
        return 1
    fi

    # Si c'est un fichier, ouvrir son dossier parent
    if [ -f "$file" ]; then
        file=$(dirname "$file")
    fi

    echo "📂 Ouverture du dossier : $file"
    nautilus "$file" >/dev/null 2>&1 &
}

