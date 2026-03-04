#!/bin/bash
# @desc: Clears the contents of a directory with confirmation and safety pause
# @usage: clean-dir.sh <path>
# @args: path=Path of the directory to clean
# @tags: filesystem, cleanup

TARGET_DIR=$1

if command -v eza &> /dev/null; then
    LIST_CMD="eza -a --group-directories-first --color=always"
elif command -v exa &> /dev/null; then
    LIST_CMD="exa -a --group-directories-first --color=always"
else
    LIST_CMD="ls -A"
fi

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

ABS_PATH=$(realpath "$TARGET_DIR")

if [[ "$ABS_PATH" == "/" || "$ABS_PATH" == "$HOME" ]]; then
    echo "Security Critical: Deletion of Root or Home directory is prohibited."
    exit 1
fi

shopt -s dotglob
files=("$ABS_PATH"/*)
shopt -u dotglob

if [ "${#files[@]}" -eq 1 ] && [ ! -e "${files[0]}" ]; then
    echo "Information: Directory $ABS_PATH is already empty. Nothing to clean."
    exit 0
fi

echo -e "\nPENDING DELETION: $ABS_PATH"
echo "----------------------------------------------------"
$LIST_CMD "$ABS_PATH"
echo "----------------------------------------------------"

echo "SYSTEM PAUSE: 8 seconds to abort (Ctrl+C)..."
for i in {8..1}; do
    echo -n "$i... "
    sleep 1
done
echo -e "\n"

echo -n "ACTION REQUIRED: Press [ENTER] to confirm deletion or [Ctrl+C] to abort: "
read -r < /dev/tty

rm -rf "${ABS_PATH:?}"/* "${ABS_PATH:?}"/.[!.]* 2>/dev/null

echo "Success: Contents of $ABS_PATH have been cleared."
