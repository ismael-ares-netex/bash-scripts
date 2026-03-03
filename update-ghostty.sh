#!/bin/bash

STORAGE_DIR="$HOME/Documentos/AppImages"
BIN_DIR="$HOME/.bin"
REPO="pkgforge-dev/ghostty-appimage"
EXE_NAME="ghostty"

mkdir -p "$STORAGE_DIR"
mkdir -p "$BIN_DIR"

echo "🔍 Buscando la última versión estable de Ghostty..."

ARCH=$(uname -m)
[[ "$ARCH" == "x86_64" ]] && GITHUB_ARCH="x86_64" || GITHUB_ARCH="aarch64"

RELEASE_DATA=$(curl -s "https://api.github.com/repos/$REPO/releases")

if [ -z "$RELEASE_DATA" ] || [ "$RELEASE_DATA" == "null" ]; then
    echo "❌ Error de conexión o límite de API alcanzado."
    exit 1
fi

VERSION=$(echo "$RELEASE_DATA" | jq -r '
    .[].tag_name
    | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$"))
' | head -n 1)

if [ -z "$VERSION" ] || [ "$VERSION" == "null" ]; then
    echo "❌ No se encontró ninguna versión estable."
    exit 1
fi

echo "📌 Última versión estable encontrada: $VERSION"

DOWNLOAD_URL=$(echo "$RELEASE_DATA" | jq -r --arg ver "$VERSION" --arg arch "$GITHUB_ARCH" '
    .[] | select(.tag_name == $ver)
    | .assets[]
    | select(.name | endswith(".AppImage"))
    | select(.name | contains($arch))
    | .browser_download_url
' | head -n 1)

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" == "null" ]; then
    echo "❌ No se encontró AppImage para la arquitectura '$GITHUB_ARCH'."
    exit 1
fi

FILENAME=$(basename "$DOWNLOAD_URL")
FULL_PATH="$STORAGE_DIR/$FILENAME"

if [ -f "$FULL_PATH" ]; then
    echo "✅ Ya tienes la última versión estable ($VERSION) en Documentos."
    exit 0
fi

echo "⬇️  Descargando versión $VERSION..."
wget -q --show-progress -O "$FULL_PATH" "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    chmod +x "$FULL_PATH"
    ln -sf "$FULL_PATH" "$BIN_DIR/$EXE_NAME"

    find "$STORAGE_DIR" -maxdepth 1 -type f -name "*ghostty*.AppImage" ! -name "$FILENAME" -delete
    find "$STORAGE_DIR" -maxdepth 1 -type f -name "*Ghostty*.AppImage" ! -name "$FILENAME" -delete

    echo "✅ Proceso finalizado."
    echo "📦 Archivo guardado en: $FULL_PATH"
    echo "🔗 Enlace creado en:    $BIN_DIR/$EXE_NAME"
else
    rm -f "$FULL_PATH"
    echo "❌ Error en la descarga."
    exit 1
fi