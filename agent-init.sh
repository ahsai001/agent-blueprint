#!/usr/bin/env bash
# ==============================================================================
# agent-init: Universal AI Agent Standard Initializer
# Repository: agent-blueprint
# ==============================================================================

set -e

# Warna UI
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Dapatkan lokasi absolut direktori script ini
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
BLUEPRINT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

TARGET_DIR="$(pwd)"
PROFILE=""
FORCE=false

print_banner() {
  echo -e "${CYAN}${BOLD}"
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║                   AGENT-BLUEPRINT INITIALIZER                 ║"
  echo "║     Standar Baku Arsitektur & Safety Guardrails untuk AI     ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

show_help() {
  print_banner
  echo -e "${BOLD}PENGGUNAAN:${NC}"
  echo "  agent-init [OPTIONS]"
  echo ""
  echo -e "${BOLD}OPSI:${NC}"
  echo "  -p, --profile <name>   Profil stack: flutter, codeigniter, laravel, dotnet, nodejs, general"
  echo "  -t, --target <path>    Direktori project target (default: direktori saat ini)"
  echo "  -f, --force            Overwrite jika file AGENTS.md sudah ada"
  echo "  -h, --help             Tampilkan bantuan ini"
  echo ""
  echo -e "${BOLD}CONTOH:${NC}"
  echo "  agent-init                     # Auto-detect atau pilih via menu interaktif"
  echo "  agent-init -p flutter          # Inisialisasi dengan profil Flutter"
  echo "  agent-init -p laravel -t /var/www/my-api"
  exit 0
}

# Parse flags
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--profile)
      PROFILE="$2"
      shift 2
      ;;
    -t|--target)
      TARGET_DIR="$2"
      shift 2
      ;;
    -f|--force)
      FORCE=true
      shift
      ;;
    -h|--help)
      show_help
      ;;
    *)
      echo -e "${RED}Opsi tidak dikenal: $1${NC}"
      show_help
      ;;
  esac
done

# Pastikan target directory ada
if [ ! -d "$TARGET_DIR" ]; then
  echo -e "${RED}Direktori target tidak ditemukan: $TARGET_DIR${NC}"
  exit 1
fi

cd "$TARGET_DIR"
TARGET_DIR="$(pwd)"
PROJECT_NAME="$(basename "$TARGET_DIR")"

# Auto-detect profile jika tidak ditentukan
auto_detect_profile() {
  if [ -f "$TARGET_DIR/pubspec.yaml" ]; then
    echo "flutter"
  elif [ -f "$TARGET_DIR/artisan" ]; then
    echo "laravel"
  elif [ -f "$TARGET_DIR/application/config/config.php" ] || [ -d "$TARGET_DIR/system/core" ]; then
    echo "codeigniter"
  elif compgen -G "$TARGET_DIR/*.csproj" > /dev/null || compgen -G "$TARGET_DIR/*.sln" > /dev/null; then
    echo "dotnet"
  elif [ -f "$TARGET_DIR/package.json" ]; then
    echo "nodejs"
  else
    echo ""
  fi
}

if [ -z "$PROFILE" ]; then
  DETECTED=$(auto_detect_profile)
  if [ -n "$DETECTED" ]; then
    echo -e "${BLUE}🔍 Terdeteksi stack project: ${BOLD}${DETECTED}${NC}"
    PROFILE="$DETECTED"
  else
    print_banner
    echo -e "${YELLOW}Pilih profil arsitektur untuk project '${PROJECT_NAME}':${NC}"
    echo "  1) Flutter & Dart (Clean Architecture, Cubit, i18n, Screen matrix)"
    echo "  2) CodeIgniter (API v2, ACID Transaction, SP-Ready, RBAC)"
    echo "  3) Laravel (Service/Action, FormRequest, Migration safety)"
    echo "  4) .NET & C# (Clean Arch, CQRS, EF Core AsNoTracking)"
    echo "  5) Node.js & TypeScript (NestJS/Express, Zod, Strict Types)"
    echo "  6) General (Prinsip Universal Clean Code & SOLID)"
    echo ""
    read -rp "Masukkan pilihan [1-6]: " choice
    case $choice in
      1) PROFILE="flutter" ;;
      2) PROFILE="codeigniter" ;;
      3) PROFILE="laravel" ;;
      4) PROFILE="dotnet" ;;
      5) PROFILE="nodejs" ;;
      *) PROFILE="general" ;;
    esac
  fi
fi

# Validasi file profil ada di templates
PROFILE_FILE="$BLUEPRINT_DIR/templates/profiles/${PROFILE}.md"
if [ ! -f "$PROFILE_FILE" ]; then
  echo -e "${YELLOW}Profil '$PROFILE' tidak ditemukan, menggunakan 'general'${NC}"
  PROFILE="general"
  PROFILE_FILE="$BLUEPRINT_DIR/templates/profiles/general.md"
fi

OUTPUT_FILE="$TARGET_DIR/AGENTS.md"

if [ -f "$OUTPUT_FILE" ] && [ "$FORCE" = false ]; then
  echo -e "${YELLOW}⚠️  File AGENTS.md sudah ada di: $OUTPUT_FILE${NC}"
  read -rp "Apakah ingin menimpa (overwrite)? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Operasi dibatalkan.${NC}"
    exit 0
  fi
fi

echo -e "${BLUE}🚀 Men-generate AGENTS.md untuk project: ${BOLD}${PROJECT_NAME}${NC} (Stack: ${PROFILE})..."

# 1. Tulis Header Dokumen
cat <<EOF > "$OUTPUT_FILE"
# AGENTS.md - Standar Baku Pengembangan AI Agent

> **Project**: ${PROJECT_NAME}  
> **Profile**: ${PROFILE}  
> **Source Blueprint**: agent-blueprint  
> **Generated At**: $(date)

Dokumen ini memuat standar baku arsitektur, safety guardrails, dan protokol kerja untuk seluruh AI Agent (Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes, dll.) saat mengembangkan kode di repository ini.

---
EOF

# 2. Append Core Templates (01 to 05)
for core_file in "$BLUEPRINT_DIR"/templates/core/[0-5]*.md; do
  if [ -f "$core_file" ]; then
    echo "" >> "$OUTPUT_FILE"
    cat "$core_file" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "---" >> "$OUTPUT_FILE"
  fi
done

# 3. Append Profile Template
echo "" >> "$OUTPUT_FILE"
cat "$PROFILE_FILE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"

# 4. Append Project-Specific Knowledge Registry (untuk diisi Agent saat onboarding)
if [ -f "$BLUEPRINT_DIR/templates/core/06-project-knowledge.md" ]; then
  echo "" >> "$OUTPUT_FILE"
  cat "$BLUEPRINT_DIR/templates/core/06-project-knowledge.md" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

echo -e "${GREEN}✓ File AGENTS.md berhasil dibuat di: ${OUTPUT_FILE}${NC}"

# 4. Buat Symlink untuk Berbagai AI Agent
create_symlink() {
  local link_name="$1"
  local target="AGENTS.md"
  rm -f "$TARGET_DIR/$link_name"
  ln -s "$target" "$TARGET_DIR/$link_name"
  echo -e "${GREEN}✓ Symlink dibuat: ${link_name} -> AGENTS.md${NC}"
}

create_symlink "CLAUDE.md"
create_symlink ".cursorrules"
create_symlink ".windsurfrules"

# 5. Pasang Git Pre-commit Hook jika ada folder .git
if [ -d "$TARGET_DIR/.git" ]; then
  HOOK_TARGET="$TARGET_DIR/.git/hooks/pre-commit"
  mkdir -p "$TARGET_DIR/.git/hooks"
  cp "$BLUEPRINT_DIR/templates/hooks/pre-commit" "$HOOK_TARGET"
  chmod +x "$HOOK_TARGET"
  echo -e "${GREEN}✓ Git pre-commit hook berhasil dipasang di: ${HOOK_TARGET}${NC}"
fi

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}🎉 Inisialisasi Berhasil!${NC}"
echo -e "Project Anda sekarang terlindungi oleh guardrails standar profesional."
echo ""
echo -e "${BOLD}Langkah Selanjutnya bersama AI Agent Anda:${NC}"
echo "1. Buka project ini di Antigravity / Cursor / Claude / Windsurf."
echo "2. Berikan instruksi onboarding awal ke Agent:"
echo -e "   ${YELLOW}\"Tolong baca AGENTS.md dan audit struktur project ini sebelum mulai bekerja.\"${NC}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
