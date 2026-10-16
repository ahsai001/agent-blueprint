# PROFIL SPESIFIK: NODE.JS & TYPESCRIPT (NESTJS / EXPRESS)

Panduan arsitektur dan kualitas kode untuk project Node.js / TypeScript.

---

### 1. TypeScript Strictness & Type Safety
- Dilarang menggunakan tipe `any` tanpa alasan yang terdokumentasi jelas. Gunakan `unknown` jika tipe belum pasti, lalu lakukan type narrowing.
- Gunakan schema validator runtime (seperti `zod`, `joi`, atau `class-validator`) untuk semua input request eksternal sebelum diproses oleh business logic.

---

### 2. Struktur Layer & Dependency Injection
- Pisahkan logic ke dalam Controller / Route Handler, Service, dan Data Access (Repository/ORM).
- Controller hanya bertugas mem-parse input, memanggil service, dan memformat HTTP status code & payload.
- Dilarang menaruh logic query database langsung di dalam Express route callback.

---

### 3. Database Transactions (Prisma / TypeORM / Kysely)
- Operasi multi-write wajib dibungkus dalam transaction manager ORM yang dipakai:
  ```typescript
  // Prisma example:
  await prisma.$transaction(async (tx) => { ... });
  ```
- Pastikan semua query async di-`await` dengan benar untuk mencegah uncaught promise rejection.

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
