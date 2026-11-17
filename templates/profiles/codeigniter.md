# PROFIL SPESIFIK: CODEIGNITER (API & WEB)

Panduan arsitektur dan kualitas kode untuk project CodeIgniter (CI3 / CI4).

---

### 1. Arsitektur Layered (Thin Controller & Service/Model Separation)
Meskipun CodeIgniter secara default adalah MVC sederhana, seluruh kode baru atau refactoring **WAJIB** menerapkan pemisahan 3 layer untuk mencegah controller monolitik:

```
application/ (CI3) atau app/ (CI4)
├── controllers/   # Thin Controller: routing, parse HTTP input, panggil Service, return JSON
├── services/      # Service Layer: business logic, orkestrasi transaksi, kalkulasi
├── models/        # Data Access: query SQL murni, prepared statements, SP-calls
└── libraries/     # Reusable adapters, third-party clients, helper wrappers
```

- **Aturan Batasan Layer**:
  - **Controller**: Bertugas murni sebagai interface HTTP. **DILARANG** menulis raw SQL query, kalkulasi matematika kompleks, atau manipulasi data multi-tabel langsung di Controller.
  - **Service**: Tempat seluruh business logic berada. Service menerima data murni (array/object), memvalidasi aturan bisnis, dan memanggil satu atau lebih Model di dalam transaksi.
  - **Model**: Hanya bertugas mengeksekusi query database dan mengembalikan data mentah. **DILARANG** mengakses variabel global HTTP seperti `$_POST`, `$_GET`, atau `$this->input` langsung di dalam Model.

---

### 2. Standarisasi Response Data API (Raw Data Tanpa Formatting)
Backend API **WAJIB** mengirimkan data angka dan tanggal/waktu dalam bentuk nilai mentah (*raw data*) dengan tipe data aslinya. **DILARANG** melakukan pemformatan visual tampilan di sisi backend:
- **Data Angka (Number / Float / Currency / Percentage)**:
  - Kirimkan sebagai tipe numerik asli (`int`, `float`, atau `numeric` string murni):
    - Contoh **BENAR**: `"total_cost": 1500000.50`, `"qty": 12.0`, `"percentage": 45.2`
    - Contoh **SALAH**: `"total_cost": "Rp 1.500.000"`, `"total_cost": "1.5 M"`, `"qty": "12 unit"`, `"percentage": "45.2%"`
  - Dilarang menambahkan separator ribuan (titik/koma), simbol mata uang, satuan, atau singkatan di dalam response JSON.
- **Data Tanggal dan Waktu (Date, DateTime, Period)**:
  - Tanggal (*Date*): `"YYYY-MM-DD"` (contoh: `"2026-10-24"`)
  - Tanggal & Waktu (*DateTime*): `"YYYY-MM-DD HH:mm:ss"` atau ISO-8601
  - Periode Bulan (*Month*): `"YYYY-MM"`
  - Dilarang memformat tanggal ke dalam string bahasa/lokal tertentu (seperti `"24 Oktober 2026"`). Seluruh lokalisasi tampilan tanggal adalah tanggung jawab Front End.

---

### 3. Pola Operasi Write (ACID Transactions)
- Setiap operasi yang melibatkan beberapa query mutasi (multi-write `INSERT`/`UPDATE`/`DELETE`) **WAJIB** dibungkus dalam database transaction di Service layer.
- Gunakan transaction wrapper yang disediakan framework atau helper (contoh: `process_data_with_transaction` / `process_json_with_transaction` jika ada).
- **Hindari Pitfall Commit**: Pada MySQL/CI, statement `COMMIT;` mereset counter affected rows menjadi `0`. Jangan mengecek status eksekusi menggunakan affected rows setelah commit dijalankan.

---

### 4. Standarisasi Layout & View CMS/Admin Panel (Jika Menggunakan Blade/HTML View)
- **Aturan Tag `<div>` Layout & Posisi Footer**:
  - Selalu pastikan tag `<div>` penutup wrapper konten seimbang. Kekurangan satu tag `</div>` penutup pada konten view dapat menyebabkan footer/teks copyright terdorong dan bergeser ke sebelah kanan konten, merusak layout halaman.
- **Tabel Responsif & Mouse Scroll (`table-responsive`)**:
  - Gunakan wrapper scrollable yang memiliki overflow style yang tepat agar scrolling mouse tidak macet atau keras saat kursor hover di atas tabel data yang lebar.

---

### 5. Standarisasi Query & Prepared Statements
- Dilarang keras menggabungkan variabel input user langsung ke dalam string SQL (*string concatenation*). Wajib menggunakan query binding / prepared statement:
  ```php
  $this->db->query("SELECT * FROM users WHERE status = ? AND region_id = ?", [$status, $regionId]);
  ```
- **SP-Ready Query Rules (Untuk Laporan / Analitik)**:
  - Tulis query dengan standar ANSI/T-SQL yang bersih.
  - Berikan header komentar deskriptif jika query direncanakan untuk dipindah ke Stored Procedure (parameter target, daftar tabel).
  - Gunakan `COALESCE` / `ISNULL` untuk null safety dan `OUTER APPLY` / subquery bersih untuk data baris terakhir.

---

### 6. Multi-Tenancy & Row-Level Security (Filter 'ALL')
- **Arti Filter 'ALL'**: Di sisi user/klien, pilihan "All" atau parameter kosong **BUKAN** berarti mengambil seluruh data database tanpa filter.
- Backend wajib membatasi query berdasarkan identitas user (`kduser`, company ID, atau site yang terdaftar di database user).
- **Multi-Code Parsing**: Dukung filter dengan nilai koma (contoh: `"site": "SITE_A,SITE_B"`) dan sanitasi menggunakan klausa `IN (?, ?, ...)`.
- *Cascading Filter*: Filter turunan (unit/equipment) wajib mewarisi batasan filter induknya (site milik user).

---

### 7. Checklist Pendaftaran Endpoint Baru (RBAC Lifecycle)
Setelah membuat fungsi API baru, pastikan alur akses terdaftar lengkap:
```
Buat endpoint API di Controller
    ↓
1. Register endpoint di tabel `api` (path, method, butuh auth/tidak)
    ↓
2. Daftarkan menu baru di tabel master menu (jika fitur baru)
    ↓
3. Mapping API ↔ Menu beserta permission ('open', 'create', 'edit', 'delete')
    ↓
4. Mapping Menu ↔ Database Klien (Multi-tenant)
    ↓
5. Atur hak akses permission per role di RBAC
```

---

### 8. Verification Commands (Quality Gate)
```bash
# Validasi syntax PHP untuk semua file yang diubah
php -l path/to/changed_file.php
```
