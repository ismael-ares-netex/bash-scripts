# 🐚 Bash Scripts
Personal bash script collection to make my life easier.

## 🛠 Available scripts

### 1. Update Docker Compose
Installs or updates Docker Compose to version **v2.38.2** into `~/.bin/`.

**Command:**
```bash
curl -s https://raw.githubusercontent.com/ismael-ares-netex/scripts/main/update-docker-compose.sh | bash
```
### 2. Update Helium Browser
Installs or updates the **Helium** browser by downloading the latest AppImage into `~/Documentos/` and creating a symlink in `~/.bin/`.

**Command:**
```bash
curl -s https://raw.githubusercontent.com/ismael-ares-netex/scripts/main/update-helium.sh | bash
```
### 3. Update Ghostty Terminal
Installs or updates the **Ghostty** terminal by downloading the latest stable AppImage into `~/Documentos/` and creating a symlink in `~/.bin/`.

**Command:**
```bash
curl -s https://raw.githubusercontent.com/ismael-ares-netex/scripts/main/update-ghostty.sh | bash
```
### 4. Clean directory
Cleans any path safely, showing what will be deleted and with a countdown before deletion. Compatible with ls, eza and exa.

**Command:**
```bash
curl -s https://raw.githubusercontent.com/ismael-ares-netex/scripts/main/clean-path.sh | bash -s -- /path/to/clean
```