#!/bin/bash
# Hook PostToolUse pour lancer Prettier automatiquement après les écritures de fichiers .ts et .md

# Lire l'input JSON depuis stdin
input=$(cat)

# Extraire le chemin du fichier
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Vérifier si le fichier existe
if [ -z "$file_path" ] || [ "$file_path" = "null" ]; then
    exit 0
fi

# Vérifier l'extension du fichier
if [[ "$file_path" == *.ts ]] || [[ "$file_path" == *.md ]]; then
    # Aller dans le répertoire du projet
    cd "$CLAUDE_PROJECT_DIR" || exit 1

    # Vérifier si Prettier est installé
    if ! command -v prettier &> /dev/null; then
        echo "[Document auto-formatted]" >&2
        exit 0
    fi

    # Formater le fichier (silencieux)
    prettier --write "$file_path" >/dev/null 2>&1

    # Message encore plus discret: vers stdout (visible seulement en mode verbose)
    echo "[Document auto-formatted]" >&1
fi
