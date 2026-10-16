# SOP PENGGUNAAN HELPER & CLASS REUSABLE (INSPECT FIRST)

Aturan ini dibuat untuk mencegah kebiasaan buruk AI: berasumsi nama parameter atau return value tanpa membaca kodenya terlebih dahulu.

---

### 1. Wajib Membaca Definisi Fungsi / Helper Sebelum Digunakan
- **Larangan Berasumsi**: Dilarang keras menebak nama parameter, urutan argumen, opsi tipe data, atau format return value dari fungsi helper, library internal, atau model yang sudah ada di codebase.
- **Tindakan Wajib**: Sebelum memanggil helper/fungsi yang belum pernah dibaca dalam sesi aktif, agent **WAJIB membaca file definisinya (`view_file` / membaca isi file)** terlebih dahulu.
- *Contoh Nyata*: Memastikan opsi parameter valid (misal: parameter `$type` pada helper database hanya menerima `'single'` atau `'list'`, bukan `'row'`).

---

### 2. Gunakan Kapabilitas Built-in (Dilarang Menulis Logic Redundan)
- Jika suatu helper atau class dasar sudah menangani transaksi database, logging, retry, atau response formatting secara otomatis (contoh: transaction wrappers):
  - **DILARANG** menambahkan penanganan manual yang tumpang tindih (seperti memanggil `trans_begin()` manual di dalam fungsi yang sudah otomatis membungkus transaksi).
  - Gunakan format return yang diharapkan oleh helper (misal: `['error' => ..., 'success' => ..., 'data' => ...]`).

---

### 3. Cek Contoh Penggunaan Nyata di Codebase
- Selalu periksa implementasi pemanggilan helper/class tersebut pada modul lain yang sudah stabil di codebase yang sama.
- Ikuti konvensi penamaan, penataan error handling, dan response formatting yang seragam dengan modul yang sudah ada.
