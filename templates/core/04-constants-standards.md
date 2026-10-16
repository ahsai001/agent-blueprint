# STANDARISASI KONSTANTA & NO MAGIC NUMBERS

Aturan ini mencegah kode rapuh (*brittle code*) akibat angka atau string literal yang tersebar tanpa konteks.

---

### 1. No Magic Numbers
- Dilarang menggunakan angka mentah tanpa nama pada logika perhitungan, threshold, skala, interval waktu, limit pagination, atau timer.
  - *Buruk*: `if ($days > 30)` atau `Future.delayed(Duration(milliseconds: 300))`
  - *Baik*: `const int _maxTrialPeriodDays = 30;` atau `const Duration _debounceDuration = Duration(milliseconds: 300);`
- Semua multiplier, satuan konversi (misal: byte ke megabyte, persen ke desimal), dan limit harus diberi nama konstanta yang bermakna.

---

### 2. Status & Role Wajib Enum / Class Constants
- **Backend & Frontend**:
  - Dilarang hardcode string status atau angka ID level akses:
    - *Buruk*: `if ($order->status == 'paid')` atau `if (user.role == 1)`
    - *Baik*: `if ($order->status == OrderStatus::PAID)` atau `if (user.role == UserRole.admin)`
- Jika sistem belum memiliki enum, buatkan class konstan terpusat untuk domain tersebut.

---

### 3. Single Source of Truth untuk Desain (UI/Styling)
- Dilarang menulis nilai hex color atau pixel padding secara acak di dalam komponen/widget.
  - Gunakan Design Tokens, Global Theme (`Theme.of(context).colorScheme`, CSS Variables, Tailwind classes terdaftar).
- Jika ada warna baru yang belum terdaftar di tema, diskusikan atau daftarkan ke file palet warna sentral terlebih dahulu.
