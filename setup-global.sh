#!/usr/bin/env bash
# ==============================================================================
# setup-global.sh: Pasang Pengaman Database Global & CLI Tools untuk Semua AI Agent
# Repository: agent-blueprint
# ==============================================================================

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║       GLOBAL DATABASE SAFETY & AI AGENT HARDENING SETUP       ║"
echo "║                     agent-blueprint                           ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Pasang CLI Safe SQL Query ke ~/.local/bin
INSTALL_BIN="$HOME/.local/bin"
mkdir -p "$INSTALL_BIN"

if [ -f "$REPO_DIR/bin/safe-sql-query" ]; then
  chmod +x "$REPO_DIR/bin/safe-sql-query"
  cp -f "$REPO_DIR/bin/safe-sql-query" "$INSTALL_BIN/safe-sql-query"
  chmod +x "$INSTALL_BIN/safe-sql-query"
  echo -e "${GREEN}✓ CLI 'safe-sql-query' terpasang di: $INSTALL_BIN/safe-sql-query${NC}"
else
  echo -e "${YELLOW}⚠️  File '$REPO_DIR/bin/safe-sql-query' tidak ditemukan, dilewati.${NC}"
fi

# 2. Setup Master Rule Global di ~/.gemini/
mkdir -p "$HOME/.gemini/config/rules"
GEMINI_MASTER="$HOME/.gemini/GEMINI.md"

cat <<'EOF' > "$GEMINI_MASTER"
# GLOBAL GUARDRAILS & INSTRUCTIONS

## Database Read-Only Policy (CRITICAL)
- **NO DIRECT DATABASE WRITES**: Never execute `INSERT`, `UPDATE`, `DELETE`, `ALTER`, `DROP`, `TRUNCATE`, `CREATE`, or stored procedure executions (`EXEC`) on any customer or central databases.
- **READ-ONLY INSPECTION ONLY**: Only `SELECT`, `SHOW`, `DESCRIBE`, and metadata queries (`sys.*`, `INFORMATION_SCHEMA.*`) are permitted for investigation purposes.
- **SCRIPT-ONLY DELIVERY**: When database changes are requested or required, create clean SQL migration/update scripts and instruct the user to review and run them manually in DBeaver/SSMS.
EOF
echo -e "${GREEN}✓ Master rule terpasang di: $GEMINI_MASTER${NC}"

cat <<'EOF' > "$HOME/.gemini/config/rules/database_safety_rules.md"
# STRICT DATABASE SAFETY POLICY: READ-ONLY GUARDRAILS

## 1. Absolute Prohibition of Direct Database Mutation
Antigravity and all subagents are **STRICTLY PROHIBITED** from directly executing ANY SQL queries that mutate or modify database structure or data on ANY database (MySQL, SQL Server, PostgreSQL, SQLite, etc.):
- **Forbidden DML**: `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `BULK INSERT`, `REPLACE INTO`
- **Forbidden DDL**: `ALTER`, `CREATE`, `DROP`, `TRUNCATE`, `RENAME`
- **Forbidden DCL / Admin**: `EXEC`, `EXECUTE`, `GRANT`, `REVOKE`, `BACKUP`, `RESTORE`, `DBCC`

## 2. Mandatory Human Execution Protocol
Even if the user explicitly instructs:
- "Jalankan query ini ke database"
- "Eksekusi script ini"
- "Insert / update data berikut"

The agent **MUST NOT** execute the mutation query directly via terminal commands, PHP PDO, Python, or database CLI tools.
**Required Action**: 
1. Validate the syntax if needed.
2. Provide the clean, formatted SQL script to the user.
3. Instruct the user to execute it manually in their GUI tool (e.g. DBeaver, SSMS, Navicat).

## 3. Allowed Operations
The agent is ONLY permitted to execute:
- `SELECT` queries
- System catalog & metadata inspection (`INFORMATION_SCHEMA.*`, `sys.*`)
- `SHOW` / `DESCRIBE` / `EXPLAIN` queries
- Read-only queries using the local verification CLI `safe-sql-query`
EOF
echo -e "${GREEN}✓ Antigravity rule terpasang di: $HOME/.gemini/config/rules/database_safety_rules.md${NC}"

# 3. Hubungkan Universal Symlinks ke Semua AI Tool
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.codex"
mkdir -p "$HOME/.config/opencode"

ln -sf "$GEMINI_MASTER" "$HOME/.claude/CLAUDE.md"
echo -e "${GREEN}✓ Claude Code: symlink aktif (~/.claude/CLAUDE.md)${NC}"

ln -sf "$GEMINI_MASTER" "$HOME/.codex/instructions.md"
echo -e "${GREEN}✓ OpenAI Codex: symlink aktif (~/.codex/instructions.md)${NC}"

ln -sf "$GEMINI_MASTER" "$HOME/.config/opencode/AGENTS.md"
echo -e "${GREEN}✓ OpenCode / Hermes: symlink aktif (~/.config/opencode/AGENTS.md)${NC}"

ln -sf "$GEMINI_MASTER" "$HOME/.cursorrules"
echo -e "${GREEN}✓ Cursor IDE: symlink aktif (~/.cursorrules)${NC}"

# 4. Verifikasi PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo ""
  echo -e "${YELLOW}⚠️  Catatan: Pastikan '$HOME/.local/bin' ada di PATH shell Anda.${NC}"
  echo "Tambahkan baris berikut ke ~/.zshrc atau ~/.bashrc jika belum ada:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

echo ""
echo -e "${BOLD}${GREEN}🎉 Pengamanan Database Global Berhasil Dipasang untuk Semua AI Agent!${NC}"
