# PROFIL SPESIFIK: LARAVEL (API & WEB)

Panduan arsitektur dan kualitas kode untuk project Laravel.

---

### 1. Arsitektur Service / Action Layer
- **Fat Model / Skinny Controller**: Controller dilarang memuat business logic yang kompleks, query kalkulasi panjang, atau pemanggilan third-party API langsung.
- Gunakan struktur berorientasi aksi:
  ```
  app/
  ├── Http/
  │   ├── Controllers/     # Hanya menerima input, panggil Action/Service, return Resource
  │   ├── Requests/        # FormRequest untuk validasi input & otorisasi
  │   └── Resources/       # API Resources untuk serialisasi JSON (DTO)
  ├── Actions/             # Single-responsibility action classes (atau Services/)
  └── Models/              # Eloquent models, relationships, scopes, casts
  ```

---

### 2. Validasi & Serialisasi Response
- **Selalu Gunakan FormRequest**: Dilarang melakukan validasi manual `$request->validate()` yang panjang di dalam method controller. Buat dedicated FormRequest class.
- **API Resources**: Dilarang me-return raw Eloquent model secara langsung pada response API untuk mencegah kebocoran atribut sensitif (`password`, `remember_token`, dll.). Gunakan `JsonResource`.

---

### 3. Database Transactions & Bulk Operations
- Operasi multi-write wajib dibungkus dalam `DB::transaction(function () { ... });`.
- Hindari N+1 query problem: Gunakan eager loading (`with(['relation'])`) pada setiap pemanggilan relasi di list/index.
- Untuk pelaporan analitik besar, gunakan Query Builder (`DB::table(...)`) atau chunking (`chunk()`, `lazy()`) daripada memuat ribuan instance Eloquent ke memory.

---

### 4. Migration & Database Schema Safety
- **Dilarang Mengedit Migration Lama**: Jangan pernah mengubah file migration yang sudah pernah di-run di database staging/production. Buat file migration baru (`add_column_...`).
- Setiap migration wajib menyediakan method `down()` yang simetris agar bisa di-rollback dengan aman jika terjadi kegagalan deployment.

---

### 5. Verification Commands (Quality Gate)
```bash
# 1. Format code (Pint)
./vendor/bin/pint --test

# 2. Static analysis (PHPStan / Larastan jika ada)
./vendor/bin/phpstan analyse

# 3. Automated tests
php artisan test
```
