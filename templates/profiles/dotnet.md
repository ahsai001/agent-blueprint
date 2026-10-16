# PROFIL SPESIFIK: .NET & C# (API & MICROSERVICES)

Panduan arsitektur dan kualitas kode untuk project .NET (C# Web API / Clean Architecture).

---

### 1. Struktur Clean Architecture
Project wajib dipisahkan berdasarkan dependency flow:
```
src/
├── Domain/          # Entities, Enums, Value Objects, Domain Exceptions (Zero dependencies)
├── Application/     # Use Cases, CQRS (MediatR), DTOs, Interfaces, Validators (FluentValidation)
├── Infrastructure/  # EF Core DbContext, External APIs, Email/SMS, Repositories Impl
└── WebApi/          # Controllers, Middlewares, Program.cs, Configuration
```

- **Aturan Dependensi**:
  - `Domain` tidak boleh mereferensikan layer manapun.
  - `Application` hanya mereferensikan `Domain`.
  - `Infrastructure` dan `WebApi` mengimplementasikan abstraksi dari `Application`.

---

### 2. DTO & Entity Isolation
- **Dilarang Expose Entity ke Luar**: Controller dilarang me-return EF Core Entity langsung ke client. Gunakan DTO (Data Transfer Object) untuk request dan response.
- Gunakan `FluentValidation` di layer Application untuk validasi input.

---

### 3. Entity Framework Core Safety & Performance
- **Read-Only Queries**: Selalu gunakan `.AsNoTracking()` untuk query baca/laporan agar tidak membebani EF Core Change Tracker:
  ```csharp
  var users = await _context.Users.AsNoTracking().Where(u => u.IsActive).ToListAsync(cancellationToken);
  ```
- **Async & Cancellation Token**: Selalu pass `CancellationToken` ke semua operasi asynchronous I/O (`SaveChangesAsync`, `ToListAsync`, HTTP calls).
- **Transactions**: Gunakan `IDbContextTransaction` jika menjalankan beberapa mutasi yang melibatkan operasi di luar context tunggal.

---

### 4. Verification Commands (Quality Gate)
```bash
# 1. Build and verify zero warnings/errors
dotnet build --no-incremental

# 2. Run unit & integration tests
dotnet test --no-build --verbosity normal
```
