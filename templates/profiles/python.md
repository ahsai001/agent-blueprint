# PROFIL SPESIFIK: PYTHON (FASTAPI / DJANGO / FLASK)

Panduan arsitektur dan kualitas kode untuk project Python modern.

---

### 1. Type Hints & Schema Validation
- **Strict Typing**: Seluruh fungsi publik, method service, dan repository wajib memiliki type hints lengkap untuk parameter dan return value:
  ```python
  def calculate_discount(price: Decimal, voucher: Optional[Voucher]) -> Decimal:
  ```
- **DTO & Runtime Validation**:
  - Gunakan **Pydantic** (`BaseModel`) atau **Django REST Framework Serializers** untuk semua input request dan output response.
  - Dilarang melewatkan raw dictionary (`dict[str, Any]`) antar layer tanpa kontrak schema yang jelas.

---

### 2. Struktur Layer & Pemisahan Tanggung Jawab
Gunakan struktur Clean Architecture / Modular Monolith:
```
app/
├── routers/ / views/     # Handler HTTP, request parsing, HTTP status code
├── schemas/             # Pydantic models / Request-Response DTOs
├── services/            # Business logic murni, orchestration
├── repositories/        # Database query (SQLAlchemy / Tortoise / Django ORM)
└── models/              # Entity / ORM Database Models
```
- **Controller/Router**: Dilarang menulis raw SQL query atau business calculations panjang di dalam router/view function.
- **Service Layer**: Menangani business logic dan transaksi.

---

### 3. Database Transactions & Async Safety
- **ACID Transactions**:
  - **SQLAlchemy**: Gunakan context manager `async with session.begin():` atau `with session.begin():`.
  - **Django**: Gunakan `with transaction.atomic():` untuk operasi multi-write.
- **Async Safety**: Pada framework async (FastAPI, Starlette, Litestar):
  - Dilarang memanggil synchronous blocking I/O (seperti `time.sleep()`, synchronous `requests.get()`, atau synchronous DB driver) di dalam fungsi `async def`. Gunakan library async (`asyncio.sleep()`, `httpx.AsyncClient()`, `asyncpg`).
  - Jika wajib memanggil kode sync blocking, delegasikan ke thread pool: `await asyncio.to_thread(...)`.

---

### 4. Zero-Dummy Policy & Error Handling
- Dilarang mengembalikan array mock atau data palsu saat query database/API eksternal kosong.
- Lempar domain exception spesifik atau kembalikan HTTP exception standar (`raise HTTPException(status_code=404, detail="Data not found")`).

---

### 5. Verification Commands (Quality Gate)
```bash
# 1. Lint & Format check (Ruff / Flake8)
ruff check . || flake8 .

# 2. Type checking (Mypy / Pyright)
mypy app/

# 3. Unit & Integration Tests (Pytest)
pytest --maxfail=1 -v
```
