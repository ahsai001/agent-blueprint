#!/usr/bin/env bash
# ==============================================================================
# Installer Script untuk agent-blueprint
# Membuat symlink global agar perintah `agent-init` bisa dipanggil dari mana saja
# ==============================================================================

set -e

REPO_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
chmod +x "$REPO_DIR/agent-init.sh"

# Prioritas instalasi: ~/.local/bin lalu /usr/local/bin
INSTALL_DIR="$HOME/.local/bin"

if [ ! -d "$INSTALL_DIR" ]; then
  mkdir -p "$INSTALL_DIR"
fi

TARGET_BIN="$INSTALL_DIR/agent-init"

rm -f "$TARGET_BIN"
ln -s "$REPO_DIR/agent-init.sh" "$TARGET_BIN"

echo "✅ Berhasil memasang 'agent-init' ke: $TARGET_BIN"

# Periksa apakah ~/.local/bin ada di $PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo ""
  echo "⚠️  Catatan: Pastikan '$HOME/.local/bin' ada di PATH shell Anda."
  echo "Tambahkan baris berikut ke ~/.zshrc atau ~/.bashrc jika belum ada:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

echo ""
echo "Sekarang Anda dapat menjalankan perintah berikut dari folder project mana pun:"
echo "  agent-init"
