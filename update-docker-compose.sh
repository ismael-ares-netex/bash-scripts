#!/bin/bash
# @desc: Installs a specific version of Docker Compose into ~/.bin
# @usage: install-docker-compose.sh
# @tags: docker, install

VERSION="v2.38.2"
BIN_DIR="$HOME/.bin"
echo "Starting Docker Compose installation, version: $VERSION"
mkdir -p "$BIN_DIR" || { echo "ERROR: Could not create $BIN_DIR"; exit 1; }
if ! grep -q "$BIN_DIR" ~/.bashrc; then
    echo "Adding $BIN_DIR to PATH in .bashrc..."
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.bashrc || { echo "ERROR: Could not write to .bashrc"; exit 1; }
fi

curl -fSL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o "$BIN_DIR/docker-compose" || { 
    echo "ERROR: Download failed. Check your connection or version '$VERSION'."
    exit 1 
}
chmod a+x "$BIN_DIR/docker-compose" || { echo "ERROR: Could not set execute permissions"; exit 1; }
export PATH="$BIN_DIR:$PATH"

INSTALLED_VERSION=$(docker-compose --version 2>/dev/null)
if [[ "$INSTALLED_VERSION" == *"$VERSION"* ]]; then
    echo "✅ Verification successful: Docker Compose $VERSION installed correctly."
else
    echo "❌ ERROR: Detected version ($INSTALLED_VERSION) does not match expected ($VERSION)."
    exit 1
fi