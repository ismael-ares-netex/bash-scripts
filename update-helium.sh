#!/bin/bash

STORAGE_DIR="$HOME/Documentos/AppImages"
BIN_DIR="$HOME/.bin"
REPO="imputnet/helium-linux"
EXE_NAME="helium"

mkdir -p "$STORAGE_DIR"
mkdir -p "$BIN_DIR"

echo "🔍 Buscando la última versión de Helium..."

ARCH=$(uname -m)
[[ "$ARCH" == "x86_64" ]] && GITHUB_ARCH="x86_64" || GITHUB_ARCH="arm64"

RELEASE_DATA=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_DATA" | jq -r .tag_name)

if [ -z "$VERSION" ] || [ "$VERSION" == "null" ]; then
    echo "❌ Error de conexión o límite de API alcanzado."
    exit 1
fi

DOWNLOAD_URL=$(echo "$RELEASE_DATA" | jq -r --arg arch "$GITHUB_ARCH" '.assets[] | select(.name | endswith(".AppImage")) | select(.name | contains($arch)) | .browser_download_url' | head -n 1)

FILENAME=$(basename "$DOWNLOAD_URL")
FULL_PATH="$STORAGE_DIR/$FILENAME"

if [ -f "$FULL_PATH" ]; then
    echo "✅ Ya tienes la última versión ($VERSION) en Documentos."
    exit 0
fi

echo "⬇️ Descargando versión $VERSION..."

wget -q --show-progress -O "$FULL_PATH" "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    chmod +x "$FULL_PATH"

    ln -sf "$FULL_PATH" "$BIN_DIR/$EXE_NAME"
    
    find "$STORAGE_DIR" -maxdepth 1 -type f -name "*Helium*.AppImage" ! -name "$FILENAME" -delete
    
    echo "✅ Proceso finalizado."
    echo "📦 Archivo guardado en: $FULL_PATH"
    echo "🔗 Enlace creado en: $BIN_DIR/$EXE_NAME"
else
    echo "❌ Error en la descarga."
    exit 1
fi