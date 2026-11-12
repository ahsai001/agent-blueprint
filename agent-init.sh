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
SMART_SYNC=false
SAFE_APPEND=false

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
  echo "  -p, --profile <name>   Profil stack: flutter, codeigniter, laravel, dotnet, nodejs, python, go, general"
  echo "  -t, --target <path>    Direktori project target (default: direktori saat ini)"
  echo "  -s, --sync             Smart Sync: update Core Rules & Profil (aman untuk project kustom)"
  echo "  -a, --append           Safe Append: sisipkan Guardrails baru di akhir file (100% isi lama utuh)"
  echo "  -f, --force            Overwrite total jika file AGENTS.md sudah ada"
  echo "  -h, --help             Tampilkan bantuan ini"
  echo ""
  echo -e "${BOLD}CONTOH:${NC}"
  echo "  agent-init                     # Auto-detect atau pilih via menu interaktif"
  echo "  agent-init -p flutter          # Inisialisasi dengan profil Flutter"
  echo "  agent-init -s                  # Smart Sync (otomatis Safe Append jika project kustom)"
  echo "  agent-init -a                  # Safe Append langsung tanpa ubah aturan lama"
  echo "  agent-init -p python           # Inisialisasi dengan profil Python"
  echo "  agent-init -p go               # Inisialisasi dengan profil Go"
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
    -s|--sync)
      SMART_SYNC=true
      shift
      ;;
    -a|--append)
      SAFE_APPEND=true
      shift
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
  elif [ -f "$TARGET_DIR/go.mod" ]; then
    echo "go"
  elif [ -f "$TARGET_DIR/pyproject.toml" ] || [ -f "$TARGET_DIR/requirements.txt" ] || [ -f "$TARGET_DIR/Pipfile" ] || [ -f "$TARGET_DIR/manage.py" ]; then
    echo "python"
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
    echo "  6) Python (FastAPI/Django, Type Hints, Pydantic, SQLAlchemy)"
    echo "  7) Go / Golang (Standard Layout, Context, Error Wrapping, Race Check)"
    echo "  8) General (Prinsip Universal Clean Code & SOLID)"
    echo ""
    read -rp "Masukkan pilihan [1-8]: " choice
    case $choice in
      1) PROFILE="flutter" ;;
      2) PROFILE="codeigniter" ;;
      3) PROFILE="laravel" ;;
      4) PROFILE="dotnet" ;;
      5) PROFILE="nodejs" ;;
      6) PROFILE="python" ;;
      7) PROFILE="go" ;;
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

# Fungsi ekstraksi Project-Specific Knowledge dari AGENTS.md lama
extract_knowledge() {
  local file="$1"
  local line_num=""
  if grep -q "<!-- BAGIAN INI DIISI & DIPERBARUI" "$file" 2>/dev/null; then
    local anchor_line
    anchor_line=$(grep -n "<!-- BAGIAN INI DIISI & DIPERBARUI" "$file" | head -n 1 | cut -d: -f1)
    if [ "$anchor_line" -gt 1 ]; then
      local prev_line=$((anchor_line - 1))
      if sed -n "${prev_line}p" "$file" | grep -q "^<!-- ==="; then
        line_num=$prev_line
      else
        line_num=$anchor_line
      fi
    else
      line_num=$anchor_line
    fi
  elif grep -q "# PROJECT-SPECIFIC KNOWLEDGE" "$file" 2>/dev/null; then
    line_num=$(grep -n "# PROJECT-SPECIFIC KNOWLEDGE" "$file" | head -n 1 | cut -d: -f1)
  fi

  if [ -n "$line_num" ]; then
    tail -n +"$line_num" "$file"
  fi
}

# Fungsi Safe Append: menyisipkan modul guardrails yang belum ada tanpa mengubah aturan lama
safe_append_guardrails() {
  local target_file="$1"
  local blueprint_dir="$2"

  local append_buffer=""
  local added_count=0
  for core_file in "$blueprint_dir"/templates/core/0[1-5]*.md; do
    if [ -f "$core_file" ]; then
      local header_title
      header_title=$(grep -E "^#+ " "$core_file" | head -n 1 | sed 's/^#* //')
      if [ -n "$header_title" ] && grep -F -q "$header_title" "$target_file"; then
        echo -e "${YELLOW}ℹ️  Bagian '$header_title' sudah ada di file, dilewati.${NC}"
      else
        local content
        content=$(cat "$core_file")
        append_buffer="${append_buffer}
${content}

---
"
        echo -e "${GREEN}✓ Menyisipkan modul: $header_title${NC}"
        added_count=$((added_count + 1))
      fi
    fi
  done

  if [ "$added_count" -gt 0 ]; then
    echo "" >> "$target_file"
    echo "---" >> "$target_file"
    echo "" >> "$target_file"
    echo "<!-- ===================================================================== -->" >> "$target_file"
    echo "<!-- UNIVERSAL SAFETY GUARDRAILS & AI BEHAVIORAL STANDARDS                 -->" >> "$target_file"
    echo "<!-- Disisipkan otomatis oleh agent-blueprint (Safe Append Mode)           -->" >> "$target_file"
    echo "<!-- Tanggal: $(date)                                                 -->" >> "$target_file"
    echo "<!-- ===================================================================== -->" >> "$target_file"
    echo "$append_buffer" >> "$target_file"
    echo -e "${GREEN}✓ Berhasil menyisipkan $added_count modul guardrails baru (100% aturan lama tetap utuh).${NC}"
  else
    echo -e "${BLUE}ℹ️  Seluruh modul guardrails sudah lengkap di AGENTS.md (tidak ada yang perlu diubah).${NC}"
  fi
}

PRESERVED_KNOWLEDGE=""

if [ -f "$OUTPUT_FILE" ] && [ "$FORCE" = false ]; then
  IS_BLUEPRINT=false
  if grep -q "Source Blueprint: agent-blueprint" "$OUTPUT_FILE" 2>/dev/null || \
     grep -q "PROJECT-SPECIFIC KNOWLEDGE" "$OUTPUT_FILE" 2>/dev/null; then
    IS_BLUEPRINT=true
  fi

  if [ "$SAFE_APPEND" = true ]; then
    BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$OUTPUT_FILE" "$BACKUP_FILE"
    echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
    safe_append_guardrails "$OUTPUT_FILE" "$BLUEPRINT_DIR"
    SKIP_GENERATE_AGENTS=true
  elif [ "$SMART_SYNC" = true ]; then
    BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$OUTPUT_FILE" "$BACKUP_FILE"
    echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
    if [ "$IS_BLUEPRINT" = true ]; then
      PRESERVED_KNOWLEDGE=$(extract_knowledge "$BACKUP_FILE")
      if [ -n "$PRESERVED_KNOWLEDGE" ]; then
        echo -e "${BLUE}ℹ️  Mendeteksi dan mempertahankan Project-Specific Knowledge dari file lama...${NC}"
      fi
      SKIP_GENERATE_AGENTS=false
    else
      echo -e "${BLUE}ℹ️  Mendeteksi AGENTS.md kustom. Melakukan Safe Append agar seluruh aturan lama 100% utuh...${NC}"
      safe_append_guardrails "$OUTPUT_FILE" "$BLUEPRINT_DIR"
      SKIP_GENERATE_AGENTS=true
    fi
  else
    # Menu interaktif
    if [ "$IS_BLUEPRINT" = false ]; then
      echo -e "${YELLOW}⚠️  Terdeteksi file AGENTS.md kustom (memuat aturan spesifik project ini).${NC}"
      echo ""
      echo "Pilih tindakan yang diinginkan:"
      echo "  1) Safe Append: Sisipkan Guardrails & Karpathy di akhir file (100% aturan lama AMAN & UTUH) [Rekomendasi]"
      echo "  2) Smart Wrap: Jadikan seluruh aturan lama sebagai Project Knowledge di bawah Core Blueprint"
      echo "  3) Backup AGENTS.md lama & Ganti total dengan Blueprint baru"
      echo "  4) Pasang Symlinks & Git Hooks saja (Pertahankan AGENTS.md apa adanya)"
      echo "  5) Batal"
      echo ""
      read -rp "Masukkan pilihan [1-5] (default: 1): " existing_choice
      existing_choice="${existing_choice:-1}"

      case $existing_choice in
        1)
          BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
          cp "$OUTPUT_FILE" "$BACKUP_FILE"
          echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
          safe_append_guardrails "$OUTPUT_FILE" "$BLUEPRINT_DIR"
          SKIP_GENERATE_AGENTS=true
          ;;
        2)
          BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
          cp "$OUTPUT_FILE" "$BACKUP_FILE"
          echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
          PRESERVED_KNOWLEDGE="$(cat "$BACKUP_FILE")"
          echo -e "${BLUE}ℹ️  Membungkus seluruh aturan lama ke bagian Project Knowledge...${NC}"
          SKIP_GENERATE_AGENTS=false
          ;;
        3)
          BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
          cp "$OUTPUT_FILE" "$BACKUP_FILE"
          echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
          PRESERVED_KNOWLEDGE=""
          SKIP_GENERATE_AGENTS=false
          ;;
        4)
          echo -e "${BLUE}ℹ️  Mempertahankan isi AGENTS.md yang sudah ada...${NC}"
          SKIP_GENERATE_AGENTS=true
          ;;
        *)
          echo -e "${BLUE}Operasi dibatalkan.${NC}"
          exit 0
          ;;
      esac
    else
      echo -e "${YELLOW}⚠️  Terdeteksi file AGENTS.md (format agent-blueprint).${NC}"
      echo ""
      echo "Pilih tindakan yang diinginkan:"
      echo "  1) Smart Sync: Update Core Rules & Profil, pertahankan Project Knowledge lama [Rekomendasi]"
      echo "  2) Safe Append: Hanya sisipkan modul guardrails yang belum ada (tanpa rewrite)"
      echo "  3) Backup AGENTS.md lama & Ganti total dengan Blueprint baru"
      echo "  4) Pasang Symlinks & Git Hooks saja (Pertahankan AGENTS.md apa adanya)"
      echo "  5) Batal"
      echo ""
      read -rp "Masukkan pilihan [1-5] (default: 1): " existing_choice
      existing_choice="${existing_choice:-1}"

      case $existing_choice in
        1)
          BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
          cp "$OUTPUT_FILE" "$BACKUP_FILE"
          echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
          PRESERVED_KNOWLEDGE=$(extract_knowledge "$BACKUP_FILE")
          if [ -n "$PRESERVED_KNOWLEDGE" ]; then
            echo -e "${BLUE}ℹ️  Mendeteksi dan mempertahankan Project-Specific Knowledge dari file lama...${NC}"
          fi
          SKIP_GENERATE_AGENTS=false
          ;;
        2)
          BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
          cp "$OUTPUT_FILE" "$BACKUP_FILE"
          echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
          safe_append_guardrails "$OUTPUT_FILE" "$BLUEPRINT_DIR"
          SKIP_GENERATE_AGENTS=true
          ;;
        3)
          BACKUP_FILE="${OUTPUT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
          cp "$OUTPUT_FILE" "$BACKUP_FILE"
          echo -e "${GREEN}✓ File lama telah di-backup ke: ${BACKUP_FILE}${NC}"
          PRESERVED_KNOWLEDGE=""
          SKIP_GENERATE_AGENTS=false
          ;;
        4)
          echo -e "${BLUE}ℹ️  Mempertahankan isi AGENTS.md yang sudah ada...${NC}"
          SKIP_GENERATE_AGENTS=true
          ;;
        *)
          echo -e "${BLUE}Operasi dibatalkan.${NC}"
          exit 0
          ;;
      esac
    fi
  fi
else
  SKIP_GENERATE_AGENTS=false
fi

if [ "$SKIP_GENERATE_AGENTS" = false ]; then
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
  for core_file in "$BLUEPRINT_DIR"/templates/core/0[1-5]*.md; do
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

  # 4. Append Project-Specific Knowledge Registry
  if [ -n "$PRESERVED_KNOWLEDGE" ]; then
    echo "" >> "$OUTPUT_FILE"
    echo "$PRESERVED_KNOWLEDGE" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo -e "${GREEN}✓ Project-Specific Knowledge lama berhasil di-merge ke AGENTS.md baru!${NC}"
  elif [ -f "$BLUEPRINT_DIR/templates/core/06-project-knowledge.md" ]; then
    echo "" >> "$OUTPUT_FILE"
    cat "$BLUEPRINT_DIR/templates/core/06-project-knowledge.md" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  fi

  echo -e "${GREEN}✓ File AGENTS.md berhasil dibuat di: ${OUTPUT_FILE}${NC}"
fi

# 4. Buat Symlink untuk Berbagai AI Agent
create_symlink() {
  local link_name="$1"
  local target="AGENTS.md"
  rm -f "$TARGET_DIR/$link_name"
  if ln -s "$target" "$TARGET_DIR/$link_name" 2>/dev/null; then
    echo -e "${GREEN}✓ Symlink dibuat: ${link_name} -> AGENTS.md${NC}"
  else
    # Fallback jika berjalan di Windows Git Bash tanpa hak symlink / CIFS mount
    cp "$TARGET_DIR/$target" "$TARGET_DIR/$link_name"
    echo -e "${YELLOW}✓ File disalin (fallback non-symlink): ${link_name}${NC}"
  fi
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
