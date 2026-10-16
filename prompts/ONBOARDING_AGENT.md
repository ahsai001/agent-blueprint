# ONBOARDING AGENT PROMPT (PANDUAN MEMULAI PROJECT)

Gunakan prompt ini saat pertama kali membuka project baru atau project legacy bersama AI Agent (Antigravity, Cursor, Claude Code, Windsurf, Hermes, OpenCode, dll.).

---

### Teks Prompt untuk Dikirim ke AI Agent:

```markdown
Halo! Project ini telah dipasangi standar baku di file `AGENTS.md`.

Tolong lakukan langkah onboarding berikut sebelum kita mulai menulis kode:
1. Baca dan pahami seluruh isi `AGENTS.md` (termasuk Core Safety, SOP Inspect First, Scope Lock, dan Profil Arsitektur).
2. Lakukan audit cepat terhadap struktur repository ini:
   - Identifikasi file konfigurasi utama, routing table, dan dependency injection / service container.
   - Jika ini project existing/legacy, cari tahu apakah ada file-file monolitik besar (di atas 1.000 baris) dan catat di daftar zona bahaya.
   - Identifikasi skema database utama, tabel auth/user, dan peran role akses yang berlaku.
3. Berikan ringkasan singkat hasil auditmu dan konfirmasi bahwa kamu siap mematuhi seluruh guardrails di `AGENTS.md` (termasuk Zero-Dummy Policy, larangan mutasi DB langsung, dan SOP inspect definition first).
```
