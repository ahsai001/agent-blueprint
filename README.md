# 🛡️ Agent-Blueprint: Universal AI Coding Standards & Guardrails

Standar baku arsitektur, safety guardrails, dan quality gates universal untuk seluruh AI Coding Agent (**Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes**, dll.).

Support multi-platform: **macOS, Linux (Ubuntu/Debian/CentOS/Alpine), dan Windows (PowerShell / CMD)**.

---

## ⚡ Cara Penggunaan (Pilih Salah Satu)

Anda memiliki dua pilihan cara penggunaan: **Full Otomatis via AI (Tanpa Install)** atau **Manual via Terminal CLI**.

### 🥇 Cara 1: Full Otomatis via AI Agent (Paling Mudah - 0 Install & Tanpa Terminal!)

> 💡 **Ini cara yang paling direkomendasikan.** Anda **TIDAK PERLU** meng-clone repo ini, **TIDAK PERLU** menjalankan script install, dan **TIDAK PERLU** membuka terminal!

Cukup buka chat AI Agent favorit Anda (**Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes**) pada project yang sedang Anda buka, lalu kirimkan **1 baris prompt ini**:

```markdown
Tolong implementasikan repo blueprint ini ke project ini: https://github.com/ahsai001/agent-blueprint
```

#### Apa yang dilakukan AI Agent di balik layar?
1. **Agent otomatis membaca** repo blueprint dari link GitHub di atas.
2. **Agent mendeteksi stack teknologi** project Anda (Flutter, Laravel, CodeIgniter, .NET, Node.js, dll.).
3. **Agent men-generate file `AGENTS.md`** lengkap dengan safety guardrails + profil framework yang relevan.
4. **Agent membuat symlinks** (`.cursorrules`, `CLAUDE.md`, `.windsurfrules`) dan memasang Git pre-commit hooks.
5. **Agent langsung mengaudit codebase** dan mengisi bagian `# PROJECT-SPECIFIC KNOWLEDGE & REGISTRY` di `AGENTS.md` (mencatat file controller besar, helper, dan route).
6. **Selesai!** Anda tinggal santai dan project Anda langsung memiliki standar profesional.

---

### 🥈 Cara 2: Manual via Terminal CLI (Opsional untuk Developer)

Gunakan cara ini jika Anda lebih menyukai inisialisasi mandiri lewat terminal sebelum membuka AI IDE.

#### 1. Pasang Sekali ke Komputer Anda:

* **🍎 macOS & 🐧 Linux:**
  ```bash
  git clone https://github.com/ahsai001/agent-blueprint.git ~/agent-blueprint
  cd ~/agent-blueprint && chmod +x install.sh && ./install.sh
  ```
  *(Perintah `agent-init` sekarang aktif di `~/.local/bin/agent-init`)*

* **🪟 Windows (PowerShell):**
  ```powershell
  git clone https://github.com/ahsai001/agent-blueprint.git $HOME\agent-blueprint
  cd $HOME\agent-blueprint
  .\install.ps1
  ```
  *(Buka terminal baru, perintah `agent-init` sudah aktif di PATH Windows)*

#### 2. Jalankan di Folder Project Target:
```bash
cd /path/to/my-project
agent-init

# Atau tentukan langsung profil teknologinya:
agent-init -p flutter      # untuk Flutter
agent-init -p laravel      # untuk Laravel
agent-init -p codeigniter  # untuk CodeIgniter
agent-init -p dotnet       # untuk .NET / C#
agent-init -p nodejs       # untuk Node.js / NestJS / Express
```

#### 3. Onboarding Awal:
Setelah file `AGENTS.md` terbentuk via terminal, buka chat AI Agent dan kirimkan prompt:
```markdown
Halo! Project ini telah dipasangi standar di file `AGENTS.md`. Tolong baca aturan di AGENTS.md, audit struktur repository ini, dan update bagian `# PROJECT-SPECIFIC KNOWLEDGE & REGISTRY` di AGENTS.md dengan fakta hasil auditmu.
```

---

## 🧠 Konsep & Filosofi Hybrid

Sistem ini dirancang dengan prinsip **Hybrid (Script + AI Agent)**:

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. STRUKTUR STATIS (Deterministik & Cepat)                     │
│    - Men-generate AGENTS.md berisi aturan core safety           │
│    - Membuat symlink: CLAUDE.md, .cursorrules, .windsurfrules   │
│    - Memasang Git pre-commit hook validator                     │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. KOGNITIF & AUDIT (Cerdas & Adaptif)                         │
│    - Mengaudit struktur folder & file monolitik (> 1.000 baris) │
│    - Mengidentifikasi routing, auth, dan helper bawaan          │
│    - MENGUPDATE bagian Registry di AGENTS.md                    │
│    - Menjaga kepatuhan aturan saat menulis kode                 │
└─────────────────────────────────────────────────────────────────┘
```

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

#### 1. Apakah project yang sudah ada `AGENTS.md` lama (seperti web-syshab/syshab-api) aman?
Sangat aman! Jika `AGENTS.md` sudah ada:
- **Jika via CLI (`agent-init`)**: Script menyediakan pilihan `1) Pasang Symlinks & Hooks saja (pertahankan file lama)` atau `2) Backup otomatis & ganti`.
- **Jika via Prompt AI**: Agent diinstruksikan untuk mempertahankan aturan spesifik lama dan hanya menyisipkan guardrails universal yang belum ada.

#### 2. Di Windows muncul pesan "Symbolic link creation failed"?
Script sudah dilengkapi **auto-fallback**: jika akun Windows Anda belum mengaktifkan *Developer Mode*, script otomatis menyalin file `AGENTS.md` ke `CLAUDE.md`, `.cursorrules`, dan `.windsurfrules`.

#### 3. Bagaimana jika saya ingin menambah profil framework baru (misal: Python FastAPI / Go)?
Cukup tambahkan file markdown baru di `templates/profiles/<nama-stack>.md`. Script dan Agent otomatis bisa mengenali opsi baru tersebut.
