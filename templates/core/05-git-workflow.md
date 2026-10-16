# WORKFLOW GIT & PROTOKOL HOT-SPOT MERGE CONFLICT

Aturan ini dibuat untuk mencegah konflik git (*merge conflict*) pada file-file yang sering diedit secara bersamaan oleh banyak developer/agent.

---

### 1. Protokol File Sentral (Hot-Spot Files)
File sentral adalah file yang hampir selalu dimodifikasi setiap kali ada fitur baru (contoh: Route tables, Dependency Injection Containers, Event Registries, Translation/i18n files).

- **Aturan Append-Only**: Selalu tambahkan baris pendaftaran baru di bagian bawah section terkait. Dilarang mengurutkan ulang (*reorder/sort*) baris-baris yang sudah ada sebelumnya.
- **Jangan Ubah Urutan Injeksi**: Pada DI container (Service Provider / Service Locator), urutan inisialisasi singleton atau factory seringkali memiliki ketergantungan urutan (*order-sensitive*). Dilarang mengacak urutan registrasi yang sudah stabil.

---

### 2. Dual-Mirroring Verification (Simetri File Konfigurasi & Bahasa)
- **Konfigurasi Environment**: Setiap menambahkan environment variable baru di kode atau `.env`, WAJIB menambahkan variabel dummy yang sama di `.env.example` beserta komentar penjelasannya.
- **Translasi Bahasa (i18n)**: Jika project menggunakan sistem multi-bahasa, setiap penambahan key baru (misal di `id.json`) WAJIB ditambahkan padanan terjemahannya di file bahasa lainnya (misal `en.json`).

---

### 3. Konvensi Commit Message (Conventional Commits)
Gunakan format standar:
```
<type>(<scope>): <deskripsi singkat jelas>
```
- `feat`: Fitur baru untuk user/klien
- `fix`: Perbaikan bug
- `refactor`: Perubahan struktur kode tanpa mengubah fungsionalitas
- `perf`: Optimasi performa / query
- `docs`: Perubahan dokumentasi
- `chore`: Update build scripts, konfigurasi, dependency
- *Contoh*: `feat(auth): add google sign-in callback handler`

---

### 4. Definition of Done (Quality Gate Sebelum Selesai)
Sebelum memberitahu user bahwa tugas telah selesai, agent WAJIB memverifikasi:
1. **Linter / Syntax Check**: Kode harus lolos static analysis tanpa error baru.
2. **Import Integrity**: Tidak ada import yang melanggar arsitektur satu arah.
3. **No Unused Code**: Tidak meninggalkan baris debug (`console.log`, `var_dump`, `print`, `dd()`).
4. **Git Status Review**: Periksa `git status` dan `git diff` untuk memastikan hanya file yang relevan yang tersentuh.
