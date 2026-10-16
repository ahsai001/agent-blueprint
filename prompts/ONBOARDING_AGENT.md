# ONBOARDING AGENT PROMPT (PANDUAN MEMULAI PROJECT)

Kirimkan prompt di bawah ini ke AI Agent (Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes, dll.) saat pertama kali membuka project yang baru dipasangi `agent-init`.

---

### 📋 Copy-Paste Prompt Berikut ke Chat AI Agent:

```markdown
Halo! Project ini telah dipasangi standar arsitektur dan safety guardrails di file `AGENTS.md`.

Tolong lakukan proses ONBOARDING awal sekarang:
1. Baca dan pahami seluruh isi `AGENTS.md` (termasuk Core Safety, Zero-Dummy Policy, Scope Lock, SOP Inspect First, dan Profil Arsitektur).
2. Lakukan audit struktur codebase pada repository ini:
   - Identifikasi file routing utama, dependency injection/service provider, dan file konfigurasi.
   - Scan codebase untuk menemukan file monolitik besar (> 1.000 baris) atau modul warisan yang rentan rusak.
   - Identifikasi helper, library, dan base model/service reusable yang sudah tersedia di codebase.
   - Cek skema database utama, tabel otentikasi/user, serta sistem role/permission yang dipakai.
3. **UPDATE FILE `AGENTS.md`**:
   - Buka file `AGENTS.md` dan isi bagian `# PROJECT-SPECIFIC KNOWLEDGE & REGISTRY` dengan data nyata hasil auditmu di atas.
4. Laporkan ringkasan hasil auditmu kepadaku dan konfirmasikan kesiapanmu mematuhi seluruh aturan kerja ini.
```
