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
