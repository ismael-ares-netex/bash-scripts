#!/bin/bash
# @desc: Downloads and installs the latest Helium AppImage, removing old versions
# @usage: install-helium.sh
# @tags: appimage, install, helium

STORAGE_DIR="$HOME/Documentos/AppImages"
BIN_DIR="$HOME/.bin"
REPO="imputnet/helium-linux"
EXE_NAME="helium"

mkdir -p "$STORAGE_DIR"
mkdir -p "$BIN_DIR"

echo "🔍 Looking for the latest Helium release..."

ARCH=$(uname -m)
[[ "$ARCH" == "x86_64" ]] && GITHUB_ARCH="x86_64" || GITHUB_ARCH="arm64"

RELEASE_DATA=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_DATA" | jq -r .tag_name)

if [ -z "$VERSION" ] || [ "$VERSION" == "null" ]; then
    echo "❌ Connection error or API rate limit reached."
    exit 1
fi

DOWNLOAD_URL=$(echo "$RELEASE_DATA" | jq -r --arg arch "$GITHUB_ARCH" '.assets[] | select(.name | endswith(".AppImage")) | select(.name | contains($arch)) | .browser_download_url' | head -n 1)

FILENAME=$(basename "$DOWNLOAD_URL")
FULL_PATH="$STORAGE_DIR/$FILENAME"

if [ -f "$FULL_PATH" ]; then
    echo "✅ You already have the latest version ($VERSION) in Documentos."
    exit 0
fi

echo "⬇️ Downloading version $VERSION..."
wget -q --show-progress -O "$FULL_PATH" "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    chmod +x "$FULL_PATH"

    ln -sf "$FULL_PATH" "$BIN_DIR/$EXE_NAME"

    find "$STORAGE_DIR" -maxdepth 1 -type f -name "*Helium*.AppImage" ! -name "$FILENAME" -delete
    find "$STORAGE_DIR" -maxdepth 1 -type f -name "*helium*.AppImage" ! -name "$FILENAME" -delete

    echo "✅ Process completed."
    echo "📦 File saved at: $FULL_PATH"
    echo "🔗 Symlink created at: $BIN_DIR/$EXE_NAME"
else
    echo "❌ Download failed."
    exit 1
fi