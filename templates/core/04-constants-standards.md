# STANDARISASI KODE, KONSTANTA & ANTI-SLOP (CLEAN CODE)

Aturan ini mencegah kode rapuh (*brittle code*), *over-engineering*, dan boilerplate redundan (*AI Slop*).

---

### 1. Anti-Slop Code Hygiene (Cegah AI Slop)
- **No Redundant / Echo Comments**:
  - Dilarang menulis komentar yang sekadar mengulang kode yang sudah jelas terbaca (misal: `// increment counter \n count++`, `// return user by id \n return getUserById(id)`).
  - Komentar hanya diizinkan untuk menjelaskan konteks kompleks atau alasan di balik keputusan bisnis ("mengapa" / *why*), bukan deskripsi teknis ("apa" / *what*).
- **No 1-Caller Over-Engineering**:
  - Dilarang membuat generic factory, wrapper berlebihan, abstract class spekulatif, atau interface untuk fungsi/komponen yang hanya memiliki **satu pemanggil**.
  - Terapkan prinsip **KISS (Keep It Simple, Stupid)** dan **YAGNI (You Aren't Gonna Need It)**. Tulis implementasi langsung dan lugas (*flat simplicity*).
- **Minimalist Defensive Coding**:
  - Jangan membungkus kode dengan `try-catch` bertingkat atau null-check berulang pada variabel yang tipenya sudah pasti valid (*strict typing*). Tangani error hanya pada boundary nyata (network call, parsing external data, I/O disk).
- **No Speculative Utilities**:
  - Dilarang membuat fungsi helper atau utilitas "jaga-jaga jika nanti diperlukan". Hanya buat kode yang berkaitan langsung dengan tugas yang diminta.

---

### 2. No Magic Numbers
- Dilarang menggunakan angka mentah tanpa nama pada logika perhitungan, threshold, skala, interval waktu, limit pagination, atau timer.
  - *Buruk*: `if ($days > 30)` atau `Future.delayed(Duration(milliseconds: 300))`
  - *Baik*: `const int _maxTrialPeriodDays = 30;` atau `const Duration _debounceDuration = Duration(milliseconds: 300);`
- Semua multiplier, satuan konversi (misal: byte ke megabyte, persen ke desimal), dan limit harus diberi nama konstanta yang bermakna.

---

### 3. Status & Role Wajib Enum / Class Constants
- **Backend & Frontend**:
  - Dilarang hardcode string status atau angka ID level akses:
    - *Buruk*: `if ($order->status == 'paid')` atau `if (user.role == 1)`
    - *Baik*: `if ($order->status == OrderStatus::PAID)` atau `if (user.role == UserRole.admin)`
- Jika sistem belum memiliki enum, buatkan class konstan terpusat untuk domain tersebut.

---

### 4. Single Source of Truth untuk Desain (UI/Styling & Anti-Aesthetic Slop)
- Dilarang menulis nilai hex color atau pixel padding secara acak di dalam komponen/widget.
  - Gunakan Design Tokens, Global Theme (`Theme.of(context).colorScheme`, CSS Variables, Tailwind classes terdaftar).
- Jika ada warna baru yang belum terdaftar di tema, diskusikan atau daftarkan ke file palet warna sentral terlebih dahulu.

---

### 5. Kontrak Data & Serialisasi (Raw Data Standard)
- **Backend API WAJIB Mengirim Nilai Mentah (*Raw Data*)**:
  - Dilarang keras melakukan pemformatan tampilan visual di sisi backend (seperti menambahkan simbol `"Rp"`, singkatan `"1.5 M"`, unit `"12 unit"`, atau tanggal terformat `"24 Oktober 2026"`).
  - **Data Angka (Number / Currency / Percentage)**: Wajib dikirimkan sebagai tipe data numerik asli (`int`, `float`, `double`, atau string numerik presisi tinggi murni). Dilarang menambahkan separator ribuan (titik/koma), simbol mata uang, atau karakter `%` di dalam JSON payload.
  - **Data Tanggal & Waktu (Date, DateTime, Period)**: Wajib dikirimkan dalam format standar internasional ISO / SQL standar:
    - Tanggal (*Date*): `"YYYY-MM-DD"` (contoh: `"2026-10-24"`)
    - Tanggal & Waktu (*DateTime*): `"YYYY-MM-DD HH:mm:ss"` atau ISO-8601 `"YYYY-MM-DDTHH:mm:ss"` (contoh: `"2026-10-24 14:30:00"`)
    - Periode Bulan (*Month*): `"YYYY-MM"` (contoh: `"2026-10"`)
    - Jam (*Time*): `"HH:mm:ss"` atau `"HH:mm"` (contoh: `"14:30"`)
    - Dilarang memformat tanggal ke string lokal bahasa tertentu di backend.
- **Tanggung Jawab Formatting Ada di Front End (Presentation Layer)**:
  - Seluruh formatting tampilan (pemisah ribuan, format mata uang lokal, format tanggal terjemahan lokal `intl`) WAJIB dilakukan di layer Presentation Front End.
- **Front End State & Entity Immutability**:
  - Front End DILARANG menyimpan string yang sudah terformat di dalam State atau Entity. Simpan selalu nilai numerik/raw aslinya agar data tetap fleksibel untuk kalkulasi, formula chart, agregasi, dan sorting tabel.
