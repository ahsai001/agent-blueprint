# 🛡️ Agent-Blueprint: Universal AI Coding Standards & Guardrails

Repository ini adalah standar baku arsitektur, safety guardrails, dan quality gates universal untuk seluruh AI Coding Agent (**Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes**, dll.).

Support multi-platform: **macOS, Linux (Ubuntu/Debian/CentOS/Alpine), dan Windows (PowerShell / CMD / Git Bash)**.

Standar ini disarikan dari pengalaman nyata di codebase enterprise berskala besar (seperti `web-syshab` dan `syshab-api v2`) untuk mencegah penyakit alami AI:
1. **Halusinasi Dummy Data**: Mencegah AI membuat data palsu saat error/kosong (*Zero-Dummy Policy*).
2. **Over-Refactoring**: Menjaga integritas file lain dan melarang perombakan di luar scope (*Scope Lock*).
3. **Catastrophic Database Mutation**: Melarang eksekusi query mutasi langsung ke database (*Read-Only DB Default*).
4. **Halusinasi Parameter**: Mewajibkan AI membaca file definisi helper sebelum berasumsi signature (*SOP Inspect First*).
5. **Git Merge Conflict**: Mencegah pengacakan urutan file sentral seperti route table, DI container, dan i18n (*Hotspot Protocol*).

---

## 🚀 Instalasi & Setup per Sistem Operasi

### 🍎 macOS & 🐧 Linux

```bash
# 1. Clone repository ini ke mana saja
git clone <URL_REPO_ANDA> agent-blueprint
cd agent-blueprint

# 2. Pasang secara global ke ~/.local/bin/agent-init
chmod +x install.sh
./install.sh
```

Setelah instalasi, perintah `agent-init` bisa langsung dipanggil dari direktori mana pun di terminal Anda.

---

### 🪟 Windows (PowerShell / CMD)

```powershell
# 1. Clone repository ini
git clone <URL_REPO_ANDA> agent-blueprint
cd agent-blueprint

# 2. Daftarkan ke User PATH Windows
.\install.ps1
```
*Catatan: Buka jendela PowerShell atau Terminal baru setelah menjalankan `install.ps1` agar PATH aktif.*

Sekarang perintah `agent-init` (atau `agent-init.cmd`) bisa langsung dipanggil dari folder mana pun di Windows!

---

## 🛠️ Cara Menginisialisasi Project Baru / Existing

Masuk ke folder project Anda di terminal, lalu jalankan:

### Di macOS / Linux:
```bash
cd /path/to/my-project
agent-init

# Atau tentukan langsung profilnya:
agent-init -p flutter
agent-init -p laravel
agent-init -p codeigniter
agent-init -p dotnet
agent-init -p nodejs
```

### Di Windows (PowerShell / CMD):
```powershell
cd C:\path\to\my-project
agent-init

# Atau tentukan langsung profilnya:
agent-init -Profile flutter
agent-init -Profile dotnet
agent-init -Profile laravel
```

Script akan otomatis:
1. **Auto-Detect Stack**: Mendeteksi otomatis teknologi project Anda.
2. **Generate `AGENTS.md`**: Menggabungkan Core Safety + Profil Arsitektur + Registry Onboarding.
3. **Symlink / Cross-platform Copy**:
   - `CLAUDE.md` -> `AGENTS.md`
   - `.cursorrules` -> `AGENTS.md`
   - `.windsurfrules` -> `AGENTS.md`
4. **Pasang Git Pre-commit Hook**: Mencegah credential/secret ter-commit ke git.

---

## 🤖 Langkah Onboarding Bersama AI Agent

Setelah `AGENTS.md` terbentuk di project Anda, buka IDE AI (Antigravity / Cursor / Claude) dan kirimkan prompt onboarding dari [`prompts/ONBOARDING_AGENT.md`](file:///Users/shabudin/Documents/git/agent-blueprint/prompts/ONBOARDING_AGENT.md):

```markdown
Halo! Project ini telah dipasangi standar di file `AGENTS.md`.

Tolong lakukan audit struktur codebase repository ini:
1. Identifikasi file routing utama, dependency injection/service provider, dan file konfigurasi.
2. Scan codebase untuk menemukan file monolitik besar (> 1.000 baris) atau modul warisan yang rentan rusak.
3. Identifikasi helper, library, dan base model/service reusable yang sudah tersedia di codebase.
4. Cek skema database utama, tabel otentikasi/user, serta sistem role/permission yang dipakai.
5. UPDATE BAGIAN `# PROJECT-SPECIFIC KNOWLEDGE & REGISTRY` di file `AGENTS.md` dengan fakta hasil auditmu di atas.
```

---

## 📁 Struktur Repository

```
agent-blueprint/
├── 🚀 agent-init.sh              # CLI engine untuk macOS & Linux
├── 🚀 agent-init.ps1             # CLI engine untuk Windows PowerShell
├── 🚀 agent-init.cmd             # CLI wrapper untuk Windows CMD
├── 🔧 install.sh                 # Installer global untuk macOS & Linux
├── 🔧 install.ps1                # Installer global untuk Windows
├── 📄 .gitattributes             # Normalisasi baris akhir LF/CRLF
├── 📁 prompts/
│   └── 📄 ONBOARDING_AGENT.md    # Template prompt onboarding untuk AI
├── 📁 templates/
│   ├── 📁 core/                  # Standar Universal (Berlaku untuk semua bahasa)
│   │   ├── 01-safety-first.md
│   │   ├── 02-sop-inspection.md
│   │   ├── 03-scope-lock.md
│   │   ├── 04-constants-standards.md
│   │   ├── 05-git-workflow.md
│   │   └── 06-project-knowledge.md
│   ├── 📁 hooks/
│   │   └── pre-commit            # Git pre-commit hook validator
│   └── 📁 profiles/              # Standar Khusus per Teknologi
│       ├── flutter.md
│       ├── codeigniter.md
│       ├── laravel.md
│       ├── dotnet.md
│       ├── nodejs.md
│       └── general.md
└── 📄 README.md
```
