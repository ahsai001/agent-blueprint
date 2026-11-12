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

> 🤖 **PROTOKOL EKSEKUSI WAJIB UNTUK AI AGENT YANG MEMBACA REPO INI:**
>
> * **KASUS A — Project BARU (Belum ada `AGENTS.md`)**:
>   1. Deteksi stack teknologi project ini (Flutter, Laravel, CodeIgniter, Node.js, Python, Go, .NET, dll.).
>   2. Gabungkan Core Guardrails (`templates/core/0[1-5]*.md`) + Profil Stack yang cocok ke dalam file baru `AGENTS.md`.
>   3. Buat 5 symlinks: `.cursorrules`, `CLAUDE.md`, `.windsurfrules`, `.clinerules`, dan `.github/copilot-instructions.md`.
>   4. Pasang Git pre-commit hook dari `templates/hooks/pre-commit`.
>   5. Audit codebase dan isi section `# PROJECT-SPECIFIC KNOWLEDGE & REGISTRY` dengan fakta hasil audit nyata.
>
> * **KASUS B — Project EXISTING (Sudah ada `AGENTS.md` kustom)**:
>   1. **Buat file backup pengaman**: Salin file lama menjadi `AGENTS.md.bak.<timestamp>` sebelum menyentuh file.
>   2. **DILARANG KERAS MENGHAPUS / ME-REWRITE** aturan kustom yang sudah ada sebelumnya!
>   3. Lakukan **Safe Append**: Pertahankan 100% teks aturan lama di bagian atas, dan hanya sisipkan modul guardrails (seperti Karpathy Guidelines atau Core Safety) yang belum ada di bagian akhir file.
>   4. Pastikan kelima symlink di atas dan Git pre-commit hook sudah terpasang.

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
agent-init -p python       # untuk Python (FastAPI / Django / Flask)
agent-init -p go           # untuk Go / Golang

# Update / Sinkronisasi project existing (100% aman, 0 aturan terhapus):
agent-init -s              # Smart Sync: sisipkan Guardrails & Karpathy baru tanpa ubah aturan lama
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
│    - Membuat symlink: CLAUDE.md, .cursorrules, .windsurfrules, .clinerules, copilot-instructions │
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
| **CodeIgniter** | `-p codeigniter` | Layered Architecture (Thin Controller, Service, Model), Safe Query (Prepared statements), ACID transaction wrapper, SP-Ready query, RBAC lifecycle checklist, Filter user-scope ('ALL'). |
| **Laravel** | `-p laravel` | Service/Action separation, FormRequest validation wajib, JsonResource DTO, Migration safety (`down()` method), No N+1 query. |
| **.NET & C#** | `-p dotnet` | Clean Architecture (Domain, App, Infra, WebApi), DTO isolation, EF Core `.AsNoTracking()`, Async CancellationToken. |
| **Node.js & TS** | `-p nodejs` | Clean Architecture 4-Layer (Domain, Application, Infrastructure, Presentation), TypeScript strict (No `any`), Zod schema validation, Prisma/TypeORM transaction. |
| **Python** | `-p python` | Clean Architecture (Routers, Schemas/DTO, Services, Repositories, Models), Type hints strict, Pydantic validation, ACID transactions, Ruff/Mypy gates. |
| **Go / Golang** | `-p go` | Standard Go layout (`cmd/`, `internal/`), Explicit error handling (`%w`), `ctx context.Context` propagation, `defer tx.Rollback()`, Goroutine lifecycle & Race detector. |
| **General** | `-p general` | Universal Clean Architecture (Dependency Rule, Entities, Use Cases, Adapters), SOLID, Parameterized queries, Fail Fast. |

---

## 🛡️ Fitur Keselamatan & Kualitas yang Otomatis Aktif

1. **Read-Only Database by Default**: Agent dilarang mengeksekusi query `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP` langsung ke database. Agent wajib membuatkan script SQL agar dieksekusi atau diverifikasi oleh user.
2. **Strict Zero-Dummy Policy**: Agent dilarang keras membuat array data palsu saat pemanggilan API kosong atau gagal. Wajib menampilkan Empty State atau melempar Exception.
3. **Anti-Slop Code Hygiene**: Melarang AI menulis komentar redundan (`// loop through users`), over-engineering (membuat generic factory/interface untuk 1 pemanggil saja), dan wrapping error berlebihan.
4. **Security & Injection Guardrail**: Wajib prepared statements / parameterized queries, strict boundary validation di controller/DTO, dan dilarang mengekspos raw database error/stack trace ke client.
5. **SOP Inspect Definition First**: Agent dilarang berasumsi nama parameter helper; wajib membaca file definisi helper (`view_file`) sebelum menulis kode pemanggilannya.
6. **Scope Lock**: Dilarang me-reformat seluruh repo atau mengubah file di luar tiket yang ditugaskan.
7. **Git Pre-commit Hook**: Otomatis menggagalkan commit jika ada file `.env`, private key SSH, atau fungsi debug tertinggal (`dd()`, `debugger;`).
8. **On-Demand Security Audit Playbook**: Tersedia SOP audit keamanan lengkap di `prompts/SECURITY_AUDIT.md` untuk pentest mandiri sebelum rilis.

---

## ❓ FAQ & Troubleshooting

#### 1. Apakah project yang sudah ada `AGENTS.md` lama (seperti web-syshab/syshab-api) aman?
Sangat aman! Jika `AGENTS.md` sudah ada:
- **Jika via CLI (`agent-init`)**: Gunakan opsi `1) Smart Sync` atau perintah `agent-init -s`. Skrip akan melakukan Safe Append (100% aturan lama utuh, hanya menyisipkan modul baru).
- **Jika via Prompt AI**: AI diwajibkan oleh protokol di atas untuk tidak menghapus aturan lama dan hanya melakukan Safe Append.

#### 2. Di Windows muncul pesan "Symbolic link creation failed"?
Script sudah dilengkapi **auto-fallback**: jika akun Windows Anda belum mengaktifkan *Developer Mode*, script otomatis menyalin file `AGENTS.md` ke `CLAUDE.md`, `.cursorrules`, `.windsurfrules`, `.clinerules`, dan `.github/copilot-instructions.md`.

#### 3. Bagaimana jika saya ingin menambah profil framework baru (misal: Python FastAPI / Go)?
Cukup tambahkan file markdown baru di `templates/profiles/<nama-stack>.md`. Script dan Agent otomatis bisa mengenali opsi baru tersebut.
