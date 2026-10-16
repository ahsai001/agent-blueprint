# CORE SAFETY & INTEGRITY RULES (WAJIB DIPATUHI)

Aturan ini berlaku mutlak untuk semua AI Agent di seluruh framework dan lingkungan kerja (Local/VPS/Production).

---

### 1. Database Safety & Destructive Action Safeguard
- **Read-Only By Default**: Untuk operasi selain `SELECT` (`INSERT`, `UPDATE`, `DELETE`, `ALTER`, `DROP`, `TRUNCATE`, migrasi skema, dll.) pada database manapun, **DILARANG mengeksekusi langsung**.
- **Mode Eksekusi**: Cukup buatkan script SQL terisolasi dan instruksikan kepada user, **KECUALI** jika user memberikan instruksi eksplisit dalam percakapan: *"Jalankan query ini ke database"* atau sejenisnya.
- **Safety Review**: Selalu verifikasi klausa `WHERE` pada query mutasi. Dilarang menjalankan query `UPDATE` atau `DELETE` massal tanpa batasan kunci primer / foreign key spesifik.

---

### 2. Strict Zero-Dummy Policy (Kebijakan Anti-Dummy)
- **Larangan Fallback Data Palsu**: Jika pemanggilan API/Query database mengembalikan data kosong, null, atau error, **DILARANG KERAS** membuat data dummy/mock fallback di dalam kode logika atau state management (misal: `items = [DummyItem(1, "Sample")]`).
- **Standard Handling**:
  - Tampilkan *Empty State* yang jelas bagi user (`"Belum ada data tersedia"`).
  - Lempar *Domain Exception* / kirim error response yang terstandarisasi.
  - Jangan menyembunyikan error jaringan/query dengan mengembalikan array palsu.

---

### 3. No Hardcoded Secrets & Credentials
- Dilarang keras menaruh password, secret key, connection string, API keys, atau token otentikasi langsung di dalam source code.
- Gunakan environment variables (`.env`, config provider, secret manager).
- Pastikan setiap ada konfigurasi baru, perbarui file template aman seperti `.env.example`.
- Jangan commit atau push file credentials (`.env`, `credentials.json`, `id_rsa`, dll.).

---

### 4. Git Commit & Push Safeguard
- Dilarang melakukan `git commit` atau `git push` otomatis tanpa persetujuan atau instruksi eksplisit dari user.
- Tampilkan ringkasan perubahan file (`git status`) dan minta konfirmasi user sebelum melakukan commit.
