# PROFIL SPESIFIK: GO / GOLANG

Panduan arsitektur dan kualitas kode untuk project Go (Golang API & Microservices).

---

### 1. Struktur Standar Standard Go Project Layout
Gunakan struktur modular berbasis dependency flow:
```
cmd/
└── server/             # Main entry point (main.go, config parsing, dependency wiring)
internal/               # Kode privat project (tidak boleh diimpor repo luar)
├── domain/             # Entities, custom domain errors, interfaces (Port)
├── handler/ / api/     # HTTP/gRPC handlers, routing, request decoding & validation
├── service/ / usecase/ # Business logic core
└── repository/         # Database access (SQL, GORM, sqlx, pgx, Redis)
pkg/                    # Paket utility reusable yang aman dibagikan ke luar (opsional)
```

- **Aturan Dependensi**:
  - `domain` tidak boleh memiliki dependensi ke external libraries (ORM/framework).
  - Handler memanggil Service via interface.
  - Service memanggil Repository via interface (Dependency Inversion).

---

### 2. Error Handling & Context Propagation
- **Never Ignore Errors**: Dilarang mengabaikan error dengan `_ = func()`. Selalu tangani error secara eksplisit:
  ```go
  if err != nil {
      return fmt.Errorf("failed to process order %s: %w", orderID, err)
  }
  ```
- **Error Wrapping**: Gunakan `%w` dengan `fmt.Errorf` untuk error wrapping agar dapat diinspeksi dengan `errors.Is()` atau `errors.As()`.
- **Context Wajib Dioper**: Parameter pertama pada semua fungsi I/O, database, HTTP client, dan business service wajib `ctx context.Context`.
- Jangan menyimpan `context.Context` di dalam struct.

---

### 3. Database Safety & Transactions
- **Explicit Transactions**: Operasi multi-write wajib menggunakan database transaction dengan pola `defer rollback`:
  ```go
  tx, err := db.BeginTx(ctx, nil)
  if err != nil {
      return err
  }
  defer tx.Rollback() // Otomatis no-op jika Commit() berhasil

  // Eksekusi mutasi...

  if err := tx.Commit(); err != nil {
      return fmt.Errorf("commit failed: %w", err)
  }
  ```
- Gunakan parameterized query (`$1`, `$2` atau `?`). Dilarang string concatenation ke dalam query SQL.

---

### 4. Concurrency & Goroutine Safety
- Jangan pernah menjalankan goroutine liar (*untracked goroutines*) tanpa lifecycle management:
  - Gunakan `sync.WaitGroup` atau `golang.org/x/sync/errgroup` untuk mengontrol siklus hidup goroutine.
  - Cegah data race pada shared memory dengan `sync.Mutex` atau channel komunikasi.
  - Tangani panic di dalam goroutine latar belakang (`defer func() { if r := recover(); r != nil { ... } }`).

---

### 5. Verification Commands (Quality Gate)
```bash
# 1. Vet & Static Analysis
go vet ./...

# 2. Linter (jika golangci-lint terpasang)
golangci-lint run || true

# 3. Race condition detection & unit tests
go test -v -race ./...
```
