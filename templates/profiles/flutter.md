# PROFIL SPESIFIK: FLUTTER & DART

Panduan arsitektur dan kualitas kode untuk project Flutter (Mobile, Web, Desktop).

---

### 1. Arsitektur 3-Layer (Clean Architecture)
Struktur fitur wajib mengikuti pembagian 3 layer yang ketat:
```
feature_name/
├── presentation/   # UI: Page/Screen, Widget komponen, Cubit/Bloc/State
├── domain/         # Business Logic murni: Entity, UseCase, IRepository (Interface)
└── data/           # External: Model (fromJson/toJson), Datasource (API/Local DB), RepositoryImpl
```

- **Aturan Aliran Data (Satu Arah)**:
  - `Presentation` -> memanggil `Domain (UseCase)` -> memanggil `Domain (IRepository)`.
  - `Data (RepositoryImpl)` -> mengimplementasikan `IRepository` dan memanggil `Datasource`.
  - **Dilarang**: Widget atau Cubit mengimpor langsung file dari folder `data/` (`Model`, `Datasource`, `Dio/Http`). Semua data yang diterima UI harus berupa `Entity` domain.

---

### 2. State Management (Bloc / Cubit)
- Pisahkan state menjadi class-class yang jelas (`Initial`, `Loading`, `Loaded`, `Error`).
- Dilarang menyimpan business logic kompleks di dalam callback widget (`onTap`, `onPressed`). Delegasikan event ke Cubit/Bloc.
- Gunakan `BlocBuilder` untuk render UI reaktif, dan `BlocListener` / `BlocConsumer` untuk side-effects (navigasi, dialog, SnackBar).

---

### 3. Standardisasi Formatting Data di Front End (Date Time & Number)
Front End bertanggung jawab penuh atas seluruh formatting tampilan data angka dan tanggal/waktu yang diterima mentah (*raw data*) dari backend:
- **Angka, Desimal & Mata Uang**:
  - Seluruh field angka dari API wajib dipetakan ke tipe numerik (`double`, `int`, atau `num`) di Model dan Entity.
  - Formatting tampilan (pemisah ribuan, simbol mata uang `"Rp"`, singkatan `"Jt"`/`"M"`, persentase `"%"`): **WAJIB** dilakukan di layer Presentation (Widget/UI) menggunakan `NumberFormat` dari package `intl` atau helper formatter standar.
  - **Dilarang** menyimpan string yang sudah terformat di dalam State atau Entity. Simpan nilai numerik aslinya agar tetap valid untuk kalkulasi, chart, dan sorting tabel.
- **Tanggal & Waktu**:
  - Tanggal/waktu diterima dari API dalam format standar (`YYYY-MM-DD`, `YYYY-MM-DD HH:mm:ss`, atau ISO-8601).
  - Format tampilan UI (seperti `"24 Okt 2026"`, `"24/10/2026 14:30"`) wajib dibentuk di layer Presentation menggunakan `DateFormat` dari package `intl` dan mendukung locale aktif (`context.locale`).
  - Untuk controller input/filter tanggal, pisahkan antara fungsi pengambil nilai payload API (ISO/raw) dan fungsi pengambil nilai teks tampilan UI. Hindari menduplikasi variabel tanggal di Cubit jika controller sudah mengelolanya.

---

### 4. Layar & Responsivitas (Screen Matrix & Theming)
- **Adaptabilitas Layar & Rasio**: Desain dan widget **WAJIB adaptif terhadap berbagai ukuran layar** (Mobile 360px-412px, Tablet, Desktop, Ultra-wide) serta **rasio layar** (Portrait, Landscape, Split-screen).
- **Zero Layout Overflow**: Dilarang menggunakan ukuran width/height statis yang kaku tanpa pembungkus responsif (`Expanded`, `Flexible`, `SingleChildScrollView`, atau `LayoutBuilder`) untuk mencegah error `RenderFlex overflowed`.
- **Dukungan Dark Mode & Light Mode**:
  - Seluruh halaman, dialog, modal, tabel, dan kartu wajib mendukung Dark Mode dan Light Mode menggunakan Global Theme (`Theme.of(context).colorScheme`, `context.textTheme`).
  - Pastikan kontras teks, label, dan ikon cukup tinggi dan terbaca jelas di kedua mode. Hindari pemakaian warna primer gelap langsung pada teks di background gelap tanpa aksen adaptif.

---

### 5. Error Handling Datasource & Zero-Dummy di Filter
- **Datasource Wajib Return `Future.error(e)`**: Pada seluruh Datasource (remote maupun local), jika terjadi exception/kegagalan pada blok `try-catch`, **WAJIB** me-rethrow atau me-return `Future.error(e)`. Dilarang menelan error atau mengembalikan data dummy/mock fallback secara diam-diam.
- **Zero-Dummy pada Filter / Dropdown**: Opsi dropdown filter wajib murni berasal dari API/DataSource atau parameter yang diberikan. Dilarang memasang list tiruan / hardcoded fallback jika API belum siap/kosong; tampilkan empty state yang bersih (`No data available` via `tr()`).

---

### 6. Internationalization (i18n) JSON Parity
- Seluruh teks antarmuka yang tampil ke user wajib menggunakan localization key (`context.tr('key')` atau `AppLocalizations`).
- Jika menambahkan key baru di `assets/translations/id.json`, **WAJIB** menambahkan key yang sama di `assets/translations/en.json`.
- **Pemisahan Ketat**: `id.json` khusus Bahasa Indonesia, `en.json` khusus Bahasa Inggris.
- **Modular & Bebas Duplikasi**: Gunakan key yang reusable untuk makna yang sama (misal `"date"` untuk seluruh label tanggal).

---

### 7. Verification Commands (Quality Gate)
Sebelum menyatakan fitur selesai:
```bash
# 1. Format code
flutter format lib/ test/

# 2. Static analysis
flutter analyze

# 3. Unit test (jika ada)
flutter test
```
