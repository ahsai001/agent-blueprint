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

### 3. Layar & Responsivitas (Screen Matrix)
- **Viewport Terkecil (Mobile)**: Wajib memastikan UI tidak overflow pada lebar 360px - 412px (Android/iPhone standard).
- **Responsive Layout**: Gunakan `LayoutBuilder`, `MediaQuery`, atau grid adaptif untuk mendukung tablet dan desktop.
- Hindari hardcoded lebar/tinggi widget yang kaku tanpa pembungkus scrollable jika konten berpotensi dinamis.

---

### 4. Internationalization (i18n) JSON Parity
- Seluruh teks antarmuka yang tampil ke user wajib menggunakan localization key (`context.tr('key')` atau `AppLocalizations`).
- Jika menambahkan key baru di `assets/translations/id.json`, **WAJIB** menambahkan key yang sama di `assets/translations/en.json`.

---

### 5. Verification Commands (Quality Gate)
Sebelum menyatakan fitur selesai:
```bash
# 1. Format code
flutter format lib/ test/

# 2. Static analysis
flutter analyze

# 3. Unit test (jika ada)
flutter test
```
