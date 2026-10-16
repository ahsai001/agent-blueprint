# 🛡️ Agent-Blueprint: Universal AI Coding Standards & Guardrails

Repository ini adalah standar baku arsitektur, safety guardrails, dan quality gates universal untuk seluruh AI Coding Agent (**Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes**, dll.).

Standar ini disarikan dari pengalaman nyata di codebase enterprise berskala besar (seperti `web-syshab` dan `syshab-api v2`) untuk mencegah penyakit alami AI:
1. **Halusinasi Dummy Data**: Mencegah AI membuat data palsu saat error/kosong (*Zero-Dummy Policy*).
2. **Over-Refactoring**: Menjaga integritas file lain dan melarang perombakan di luar scope (*Scope Lock*).
3. **Catastrophic Database Mutation**: Melarang eksekusi query mutasi langsung ke database (*Read-Only DB Default*).
4. **Halusinasi Parameter**: Mewajibkan AI membaca file definisi helper sebelum berasumsi signature (*SOP Inspect First*).
5. **Git Merge Conflict**: Mencegah pengacakan urutan file sentral seperti route table, DI container, dan i18n (*Hotspot Protocol*).

---

## 🚀 Cara Menggunakan (Bisa di Folder Mana Saja via Git Clone)

### 1. Clone Repository Ini
Clone repo ini ke komputer lokal, server VPS, atau environment mana pun:
```bash
cd ~/Documents/git  # atau folder mana pun di laptop/VPS Anda
git clone <URL_REPO_ANDA> agent-blueprint
cd agent-blueprint
```

### 2. Pasang Secara Global (Opsional - Cukup Sekali)
Jalankan script installer untuk membuat command global `agent-init`:
```bash
./install.sh
```
*Catatan: Pastikan `~/.local/bin` sudah ada di `$PATH` Anda.*

---

## 🛠️ Cara Menginisialisasi Project Baru / Existing

### Cara A: Menggunakan Command Global `agent-init`
Masuk ke folder project Anda, lalu jalankan:
```bash
cd /path/to/my-project
agent-init
```
Script akan:
1. **Mendeteksi otomatis** stack teknologi project Anda (Flutter, Laravel, CodeIgniter, .NET, Node.js).
2. Men-generate file `AGENTS.md` (kombinasi Core Safety + Profil Framework).
3. Membuat symlink kompatibilitas:
   - `CLAUDE.md` -> `AGENTS.md` (untuk Claude Code)
   - `.cursorrules` -> `AGENTS.md` (untuk Cursor)
   - `.windsurfrules` -> `AGENTS.md` (untuk Windsurf)
4. Memasang **Git Pre-commit Hook** untuk mencegah file credentials / secret ter-commit ke git.

### Cara B: Tanpa Install Global (Jalankan Langsung dari Repo)
Jika di server VPS atau tidak ingin install global, cukup panggil script-nya secara langsung:
```bash
cd /path/to/my-project
/path/to/agent-blueprint/agent-init.sh -p flutter
```

---

## 🤖 Langkah Onboarding Bersama AI Agent

Setelah `AGENTS.md` terbentuk di project Anda, buka IDE AI (Antigravity / Cursor / Claude) dan kirimkan prompt onboarding berikut:

```markdown
Halo! Project ini telah dipasangi standar baku di file `AGENTS.md`.

Tolong lakukan langkah onboarding berikut sebelum kita mulai menulis kode:
1. Baca dan pahami seluruh isi `AGENTS.md` (Core Safety, SOP Inspect First, Scope Lock, dan Profil Arsitektur).
2. Lakukan audit cepat terhadap struktur repository ini:
   - Identifikasi file konfigurasi utama, routing table, dan dependency injection / service container.
   - Jika ini project existing/legacy, cari tahu apakah ada file-file monolitik besar (di atas 1.000 baris) dan catat di daftar zona bahaya.
   - Identifikasi skema database utama, tabel auth/user, dan peran role akses yang berlaku.
3. Berikan ringkasan singkat hasil auditmu dan konfirmasi bahwa kamu siap mematuhi seluruh guardrails di `AGENTS.md`.
```

---

## 📁 Struktur Repository

```
agent-blueprint/
├── agent-init.sh              # CLI engine pembuat AGENTS.md & symlinks
├── install.sh                 # Installer global ke ~/.local/bin
├── prompts/
│   └── ONBOARDING_AGENT.md    # Template prompt onboarding untuk AI
├── templates/
│   ├── core/                  # Standar Universal (Berlaku untuk semua bahasa)
│   │   ├── 01-safety-first.md
│   │   ├── 02-sop-inspection.md
│   │   ├── 03-scope-lock.md
│   │   ├── 04-constants-standards.md
│   │   └── 05-git-workflow.md
│   ├── hooks/
│   │   └── pre-commit         # Git pre-commit hook validator
│   └── profiles/              # Standar Khusus per Teknologi
│       ├── flutter.md
│       ├── codeigniter.md
│       ├── laravel.md
│       ├── dotnet.md
│       ├── nodejs.md
│       └── general.md
└── README.md
```

---

## 💡 Menambah Profil Framework Baru
Jika Anda ingin menambahkan profil baru (misal: Django, Go Fiber, Spring Boot):
1. Buat file baru di `templates/profiles/<nama-stack>.md`.
2. Tulis konvensi arsitektur, layer boundaries, dan command linter/test untuk stack tersebut.
3. Profil tersebut langsung siap dipakai oleh `agent-init -p <nama-stack>`.
