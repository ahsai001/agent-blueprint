# PROFIL SPESIFIK: NODE.JS & TYPESCRIPT (NESTJS / EXPRESS)

Panduan arsitektur dan kualitas kode untuk project Node.js / TypeScript.

---

### 1. Struktur Clean Architecture / Layered Modular
Project wajib memisahkan kode berdasarkan dependency flow (baik secara monolithic layer maupun modular per fitur):

```
src/
├── domain/             # Core Entities, Value Objects, Domain Errors, Repository Interfaces (Port)
├── application/        # Use Cases / Application Services, DTOs (Zod schemas), Event Handlers
├── infrastructure/     # Database (Prisma/TypeORM/Kysely Impl), External APIs, Cache, Email
└── presentation/       # Controllers, Middlewares, Route Handlers, Serializers
```
*(Catatan: Untuk arsitektur modular per fitur, terapkan struktur 4-layer di atas di dalam masing-masing folder `src/modules/<feature>/`)*.

- **Aturan Aliran Dependensi (Dependency Inversion)**:
  - `domain` murni dari dependensi external library/framework apa pun (zero framework dependencies).
  - `application` hanya mengimpor `domain`.
  - `presentation` dan `infrastructure` mengimplementasikan abstraksi dan interface dari `application` / `domain`.
  - **Skinny Controller**: Controller dilarang memuat query database atau manipulasi logika bisnis langsung. Wajib mendelegasikan ke Use Case / Service.

---

### 2. TypeScript Strictness & Type Safety
- **No `any` Policy**: Dilarang menggunakan tipe `any` tanpa alasan yang terdokumentasi jelas. Gunakan `unknown` jika tipe belum pasti, lalu lakukan type narrowing.
- **Runtime Validation**: Gunakan schema validator runtime (seperti `zod`, `joi`, atau `class-validator`) untuk semua input request eksternal sebelum diproses oleh layer application.
- **DTO Isolation**: Dilarang mengekspos raw database model ke luar presentation layer. Gunakan response DTO yang telah divalidasi.

---

### 3. Database Transactions (Prisma / TypeORM / Kysely)
- Operasi multi-write wajib dibungkus dalam transaction manager ORM yang dipakai:
  ```typescript
  // Prisma example:
  await prisma.$transaction(async (tx) => {
    await tx.order.create({ ... });
    await tx.inventory.update({ ... });
  });
  ```
- Pastikan semua query async di-`await` dengan benar untuk mencegah uncaught promise rejection.
- Hindari N+1 query problem pada pemanggilan relasi dengan eager loading (`include` / `relations`) atau dataloader.

---

### 4. Verification Commands (Quality Gate)
```bash
# 1. Type check
npm run typecheck || npx tsc --noEmit

# 2. Lint check
npm run lint

# 3. Test
npm test
```
