# PROFIL SPESIFIK: GENERAL / MULTI-STACK

Panduan arsitektur dan kualitas kode universal untuk project modern dalam berbagai bahasa pemrograman (Rust, Ruby, Elixir, Scala, dll.).

---

### 1. Prinsip Universal Clean Architecture (The Dependency Rule)
Seluruh arsitektur project wajib mengarahkan dependensi dari luar ke dalam (*inward-pointing dependency*):

```
┌────────────────────────────────────────────────────────┐
│ 1. FRAMEWORKS & DRIVERS (Lapisan Terluar)              │
│    Database Engine, Web Framework, CLI, HTTP Client    │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│ 2. INTERFACE ADAPTERS                                  │
│    Controllers, Presenters, Gateways, Repository Impl  │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│ 3. APPLICATION BUSINESS RULES                          │
│    Use Cases, Application Services, Input/Output DTOs  │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│ 4. ENTERPRISE BUSINESS RULES (Core Domain)             │
│    Entities, Value Objects, Domain Exceptions          │
└────────────────────────────────────────────────────────┘
```

- **The Golden Dependency Rule**:
  - Lapisan dalam **DILARANG TAHU** apa pun tentang lapisan luar. Core Domain dan Use Case dilarang mengimpor framework web atau library database spesifik.
  - Komunikasi antara Use Case dan Database wajib melalui Interface / Port (Dependency Inversion).
- **Skinny Controller**: Controller hanya bertugas memvalidasi format input, memanggil Use Case, dan mengembalikan HTTP status code & DTO response.
- **DTO Isolation**: Entity internal tidak boleh diekspos langsung ke client tanpa transformasi DTO yang eksplisit.

---

### 2. Prinsip Desain Universal (SOLID & Clean Code)
- **Single Responsibility Principle**: Setiap fungsi atau class hanya boleh memiliki satu alasan untuk berubah.
- **Open/Closed Principle**: Terbuka untuk ekstensi (via polymorphism/interface), tertutup untuk modifikasi kode stabil yang sudah berjalan.
- **Fail Fast & Explicit**: Jangan menelan error/exception secara diam-diam. Tangani atau teruskan ke error logger terpusat.

---

### 3. Keamanan Input & Database Transactions
- **Input Validation**: Selalu sanitasi dan validasi tipe data input dari pengguna pada pintu gerbang API.
- **Parameterized Query**: Gunakan parameterized query / ORM query builder. Dilarang string concatenation untuk query SQL.
- **ACID Transactions**: Setiap operasi mutasi data yang melibatkan lebih dari satu entitas atau tabel wajib dibungkus dalam database transaction.
- **Rate Limiting & CORS**: Terapkan rate limiting dan CORS policy yang aman pada semua public API.

---

### 4. Verification Commands (Quality Gate)
- Jalankan formatting, static analysis/linter, dan test suite resmi dari runtime/bahasa yang digunakan sebelum menyatakan pekerjaan selesai:
  ```bash
  # Format check -> Linter / Type check -> Automated tests
  ```
