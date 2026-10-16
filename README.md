# 🛡️ Panduan Penggunaan: Agent-Blueprint

Standar baku arsitektur, safety guardrails, dan quality gates universal untuk seluruh AI Coding Agent (**Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes**, dll.).

Support multi-platform: **macOS, Linux (Ubuntu/Debian/CentOS/Alpine), dan Windows (PowerShell / CMD)**.

---

## 📌 Daftar Isi
1. [Konsep & Filosofi](#-konsep--filosofi)
2. [Instalasi Awal (Cukup Sekali)](#-instalasi-awal-cukup-sekali)
3. [Alur Penggunaan Praktis](#-alur-penggunaan-praktis)
   - [Skenario A: Project Baru (Fresh Project)](#skenario-a-project-baru-fresh-project)
   - [Skenario B: Project Lama / Existing](#skenario-b-project-lama--existing)
   - [Skenario C: Di Server VPS Linux via SSH](#skenario-c-di-server-vps-linux-via-ssh)
4. [Langkah Onboarding AI Agent (Krusial)](#-langkah-onboarding-ai-agent-krusial)
5. [Daftar Profil Teknologi yang Didukung](#-daftar-profil-teknologi-yang-didukung)
6. [Fitur Keselamatan yang Otomatis Aktif](#-fitur-keselamatan-yang-otomatis-aktif)
7. [FAQ & Troubleshooting](#-faq--troubleshooting)

---

## 🧠 Konsep & Filosofi

Sistem ini bekerja dengan prinsip **Hybrid (Script + AI Agent)**:

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. SCRIPT CLI (`agent-init`) - Cepat & Deterministik            │
│    - Men-generate AGENTS.md berisi aturan core safety           │
│    - Membuat symlink: CLAUDE.md, .cursorrules, .windsurfrules   │
│    - Memasang Git pre-commit hook validator                     │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. AI AGENT (Antigravity / Cursor / Claude) - Cerdas & Adaptif  │
│    - Mengaudit struktur folder & file monolitik (> 1.000 baris) │
│    - Mengidentifikasi routing, auth, dan helper bawaan          │
│    - MENGUPDATE bagian Registry di AGENTS.md                    │
│    - Menjaga kepatuhan aturan saat menulis kode                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Instalasi Awal (Cukup Sekali)

### 🍎 macOS & 🐧 Linux

```bash
# 1. Masuk ke folder git Anda
cd ~/Documents/git  # atau folder kerja Anda

# 2. Clone repository ini
git clone https://github.com/ahsai001/agent-blueprint.git agent-blueprint
cd agent-blueprint

# 3. Jalankan script installer global
chmod +x install.sh
./install.sh
```
> Perintah `agent-init` sekarang langsung aktif secara global di terminal Anda (`~/.local/bin/agent-init`).

---

### 🪟 Windows (PowerShell / Command Prompt)

```powershell
# 1. Buka PowerShell dan clone repository
cd C:\Users\<Username>\Documents\git
git clone https://github.com/ahsai001/agent-blueprint.git agent-blueprint
cd agent-blueprint

# 2. Daftarkan ke PATH Windows
.\install.ps1
```
> Tutup dan buka kembali jendela PowerShell / Terminal baru. Perintah `agent-init` sudah aktif secara global.

---

## 🛠️ Alur Penggunaan Praktis

### Skenario A: Project Baru (Fresh Project)

Jika Anda baru saja membuat project baru:

```bash
# 1. Buat folder dan inisialisasi git
mkdir my-new-app && cd my-new-app
git init

# 2. Jalankan agent-init
agent-init

# Script otomatis mendeteksi stack, atau Anda bisa tentukan langsung:
agent-init -p flutter      # untuk Flutter
agent-init -p laravel      # untuk Laravel
agent-init -p codeigniter  # untuk CodeIgniter
agent-init -p dotnet       # untuk .NET / C#
agent-init -p nodejs       # untuk Node.js / NestJS / Express
```

Hasil yang otomatis terbentuk di project Anda:
* `AGENTS.md` (Pondasi aturan arsitektur & safety)
* `CLAUDE.md` -> link ke `AGENTS.md`
* `.cursorrules` -> link ke `AGENTS.md`
* `.windsurfrules` -> link ke `AGENTS.md`
* `.git/hooks/pre-commit` (Mencegah `.env`, key rahasia, atau debug `dd()` ter-commit)

---

### Skenario B: Project Lama / Existing

Jika Anda ingin menerapkan standar ini ke project yang kodenya sudah berjalan lama:

```bash
# 1. Masuk ke folder project lama
cd /path/to/project-lama

# 2. Jalankan agent-init
agent-init
```
Lalu lanjutkan ke tahap [Onboarding AI Agent](#-langkah-onboarding-ai-agent-krusial) di bawah agar Agent memetakan controller besar dan helper lama yang ada di project tersebut.

---

### Skenario C: Di Server VPS Linux via SSH

Jika Anda sedang bekerja di VPS dan ingin memasang standar ke project web di server:

```bash
# 1. Clone di VPS (misal di folder home)
git clone https://github.com/ahsai001/agent-blueprint.git ~/agent-blueprint

# 2. Jalankan langsung script-nya ke target folder project
~/agent-blueprint/agent-init.sh -p codeigniter -t /var/www/html/syshab-api
```

---

## 🤖 Langkah Onboarding AI Agent (Krusial)

Ada 2 cara praktis untuk menghubungkan standar ini dengan AI Agent Anda:

### ⚡ Opsi 1: Cukup 1 Baris Prompt (Paling Praktis & Otomatis)
Buka chat AI Agent Anda di project target, lalu cukup kirimkan:

```markdown
Tolong implementasikan repo blueprint ini ke project ini: https://github.com/ahsai001/agent-blueprint
```

> **Apa yang dilakukan Agent?**  
> Agent akan langsung membaca dokumentasi repo `agent-blueprint`, mendeteksi framework project Anda, mengeksekusi inisialisasi (`AGENTS.md` + symlinks), lalu otomatis mengaudit struktur codebase dan mengisi registry. Anda tidak perlu repot membuka terminal!

---

### 📋 Opsi 2: Jika Anda Sudah Menjalankan `agent-init` di Terminal
Jika sebelumnya Anda sudah menjalankan perintah `agent-init` sendiri di terminal, kirimkan prompt onboarding berikut pada chat pertama:

```markdown
Halo! Project ini telah dipasangi standar arsitektur dan safety guardrails di file `AGENTS.md`.

Tolong lakukan proses ONBOARDING awal sekarang:
1. Baca dan pahami seluruh isi `AGENTS.md` (Core Safety, Zero-Dummy Policy, Scope Lock, SOP Inspect First, dan Profil Arsitektur).
2. Lakukan audit struktur codebase pada repository ini:
   - Identifikasi file routing utama, dependency injection/service provider, dan file konfigurasi.
   - Scan codebase untuk menemukan file monolitik besar (> 1.000 baris) atau modul warisan yang rentan rusak.
   - Identifikasi helper, library, dan base model/service reusable yang sudah tersedia di codebase.
   - Cek skema database utama, tabel otentikasi/user, serta sistem role/permission yang dipakai.
3. UPDATE BAGIAN `# PROJECT-SPECIFIC KNOWLEDGE & REGISTRY` di file `AGENTS.md` dengan fakta hasil auditmu di atas.
4. Laporkan ringkasan hasil auditmu kepadaku dan konfirmasikan kesiapanmu mematuhi seluruh aturan kerja ini.
```

### Mengapa Langkah Ini Sangat Penting?
Agent akan mengisi bagian paling bawah file `AGENTS.md` dengan fakta riil project Anda. Setelah Anda melakukan `git commit`:
```bash
git add AGENTS.md
git commit -m "chore: complete agent onboarding and register project knowledge"
```
**Seluruh agent di masa depan** (baik Anda membuka Cursor, Claude, Antigravity, atau rekan tim Anda) akan langsung mewarisi pemahaman mendalam tentang seluk-beluk project Anda tanpa perlu re-indexing berulang-ulang!

---

## 📦 Daftar Profil Teknologi yang Didukung

| Profil | Flag | Cakupan Standar |
|---|---|---|
| **Flutter & Dart** | `-p flutter` | Clean Architecture (Presentation, Domain, Data), Cubit/Bloc, Screen matrix responsive (360px), i18n JSON parity. |
| **CodeIgniter** | `-p codeigniter` | REST API vs CMS, Safe Query (Prepared statements), ACID transaction wrapper, SP-Ready query, RBAC lifecycle checklist, Filter user-scope ('ALL'). |
| **Laravel** | `-p laravel` | Service/Action separation, FormRequest validation wajib, JsonResource DTO, Migration safety (`down()` method), No N+1 query. |
| **.NET & C#** | `-p dotnet` | Clean Architecture (Domain, App, Infra, WebApi), DTO isolation, EF Core `.AsNoTracking()`, Async CancellationToken. |
| **Node.js & TS** | `-p nodejs` | TypeScript strict (No `any`), Zod schema validation, Prisma/TypeORM transaction, Controller-Service separation. |
| **General** | `-p general` | Prinsip universal SOLID, Clean Code, Parameterized queries, Fail Fast. |

---

## 🛡️ Fitur Keselamatan yang Otomatis Aktif

1. **Read-Only Database by Default**: Agent dilarang mengeksekusi query `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP` langsung ke database. Agent wajib membuatkan script SQL agar dieksekusi atau diverifikasi oleh user.
2. **Strict Zero-Dummy Policy**: Agent dilarang keras membuat array data palsu saat pemanggilan API kosong atau gagal. Wajib menampilkan Empty State atau melempar Exception.
3. **SOP Inspect Definition First**: Agent dilarang berasumsi nama parameter helper; wajib membaca file definisi helper (`view_file`) sebelum menulis kode pemanggilannya.
4. **Scope Lock**: Dilarang me-reformat seluruh repo atau mengubah file di luar tiket yang ditugaskan.
5. **Git Pre-commit Hook**: Otomatis menggagalkan commit jika ada file `.env`, private key SSH, atau fungsi debug tertinggal (`dd()`, `debugger;`).

---

## ❓ FAQ & Troubleshooting

#### 1. Bagaimana jika saya ingin menambah profil framework baru (misal: Python FastAPI / Go)?
Cukup tambahkan file markdown baru di `templates/profiles/<nama-stack>.md` pada repo `agent-blueprint`. Script otomatis bisa mengenali opsi baru tersebut.

#### 2. Di Windows muncul pesan "Symbolic link creation failed"?
Tidak masalah! Script sudah dilengkapi fitur **auto-fallback**: jika akun Windows Anda belum mengaktifkan *Developer Mode*, script otomatis menyalin file `AGENTS.md` ke `CLAUDE.md`, `.cursorrules`, dan `.windsurfrules`.

#### 3. Perintah `agent-init` tidak ditemukan setelah instalasi?
* **Di macOS/Linux**: Pastikan baris ini ada di file `~/.zshrc` atau `~/.bashrc`:
  ```bash
  export PATH="$HOME/.local/bin:$PATH"
  ```
* **Di Windows**: Tutup dan buka kembali jendela PowerShell atau Command Prompt baru agar environment variable PATH di-refresh.
