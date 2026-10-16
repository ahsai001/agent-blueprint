# PROFIL SPESIFIK: GENERAL / MULTI-STACK

Panduan umum untuk project modern dengan berbagai bahasa pemrograman (Go, Python, Rust, Ruby, dll.).

---

### 1. Prinsip Desain Universal (SOLID & Clean Code)
- **Single Responsibility Principle**: Setiap fungsi atau class hanya boleh memiliki satu alasan untuk berubah.
- **Fail Fast & Explicit**: Jangan menelan error/exception secara diam-diam. Tangani atau teruskan ke error logger terpusat.
- **Dependency Inversion**: Bergantunglah pada abstraksi/interface, bukan pada implementasi konkret.

---

### 2. Keamanan Input & Query
- Selalu sanitasi dan validasi tipe data input dari pengguna.
- Gunakan parameterized query / ORM query builder untuk mencegah SQL injection.
- Terapkan rate limiting dan CORS policy yang aman pada semua public API.

---

### 3. Verification Commands (Quality Gate)
- Jalankan linter dan test suite resmi dari runtime/bahasa yang digunakan sebelum menyatakan pekerjaan selesai.
