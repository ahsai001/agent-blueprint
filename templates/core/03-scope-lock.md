# SCOPE LOCK & REFACTORING BOUNDARIES (ZONA TERLARANG)

Aturan ini dibuat untuk mencegah AI melakukan over-refactoring, merombak arsitektur yang sudah berjalan, atau memodifikasi file di luar lingkup tugas.

---

### 1. Scope Lock (Hanya Sentuh File yang Relevan)
- Agent hanya boleh membuat atau mengedit file yang berkaitan langsung dengan fitur, bugfix, atau tiket yang ditugaskan.
- **Dilarang Mass Refactoring**: Jangan merapikan (*clean up*), merename, memindahkan, atau merestrukturisasi file di luar cakupan tanpa izin eksplisit dari user.
- **No Mass Auto-Format**: Dilarang menjalankan auto-formatter ke seluruh repository yang menghasilkan ribuan baris git diff tidak relevan. Hanya format baris yang baru Anda ubah.

---

### 2. Perlindungan Template Markers & Code Generators
- Dilarang menghapus atau mengubah baris template markers seperti:
  - `//DO NOT REMOVE: [MARKER_NAME]`
  - `/* --- GENERATED_CODE_START --- */`
  - Marker injeksi route, DI container, atau event listeners.
- Penambahan kode baru wajib disisipkan tepat di atas atau di bawah marker sesuai konvensi yang ada.

---

### 3. Penanganan File Monolitik Besar (1.000+ Baris)
- Pada file-file controller atau class warisan (*legacy*) yang sangat panjang:
  - Gunakan teknik pencarian baris spesifik dan edit terarah (*surgical replacement*).
  - Dilarang mencoba me-rewrite ulang seluruh isi file monolitik karena berisiko tinggi memotong method lain secara tidak sengaja.
- Jika menambahkan fitur baru pada file monolitik, letakkan method baru di section yang sesuai atau delegasikan logika ke class service/helper baru agar tidak memperbesar ukuran file tersebut.

---

### 4. Batasan Arsitektur Satu Arah (One-Way Dependency)
- **UI / Presentation Layer**: Dilarang mengimpor atau mengakses langsung database driver, network client (Dio, Axios, cURL), atau raw SQL. Semua akses harus melalui Service / Usecase / Repository interface.
- **Domain Layer**: Harus bebas dari dependency framework spesifik atau database driver.
- **Data Layer**: Bertanggung jawab atas serialization/deserialization, HTTP calls, dan database queries.
