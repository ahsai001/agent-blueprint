# ANTI-SLOP AUDIT PLAYBOOK (SOP REVIEW KODE SEBELUM MERGE / PR)

Gunakan prompt ini pada **sesi chat baru / agent terpisah** (bukan sesi yang menulis kode) untuk melakukan *independent review* terhadap `git diff` sebelum commit besar atau Pull Request di-merge.

---

### 📋 Copy-Paste Prompt Berikut ke Chat AI Agent:

```markdown
Halo! Tolong lakukan ANTI-SLOP CODE AUDIT terhadap perubahan terbaru di repository ini (`git diff` / `git diff --cached` / perbandingan branch terhadap `main`).

Fokus audit ini BUKAN sekadar mengecek apakah kode jalan, melainkan menyaring kode berkualitas rendah (*AI slop* maupun *human slop*). Periksa setiap perubahan terhadap 5 kriteria berikut:

### 1. SIMPLICITY & ANTI OVER-ENGINEERING
- Apakah ada abstract class, interface, generic factory, atau wrapper baru yang hanya memiliki **1 pemanggil** (*single-use*)?
- Apakah ada fungsi helper spekulatif (*"jaga-jaga kalau nanti butuh"*) yang tidak diminta oleh tugas?
- Apakah ada logika sederhana yang dibuat berbelit-belit padahal bisa ditulis langsung (*flat simplicity*)?

### 2. SCOPE & SURGICAL PRECISION
- Apakah setiap file dan baris di `git diff` benar-benar terkait dengan tiket/tugas yang dikerjakan?
- Apakah ada *drive-by refactoring*, perubahan format massal, atau modifikasi komentar lama di luar cakupan?
- Apakah ada import, variabel, atau fungsi *orphaned* (sisa perubahan yang lupa dibersihkan)?

### 3. ERROR HANDLING & ANTI-DUMMY INTEGRITY
- Apakah ada blok `try-catch` kosong, *silent failure*, atau fallback data dummy/mock saat API/query gagal?
- Apakah ada *defensive coding* berlebihan (null-check / try-catch berlapis pada data yang sudah pasti valid)?
- Apakah ada *echo comments* yang sekadar mengulang isi kode (`// loop users`)?

### 4. DUPLIKASI & REUSE CODEBASE
- Apakah ada utilitas, formatter, konstanta, atau query baru yang sebenarnya menduplikasi helper yang sudah ada di codebase?
- Apakah ada *magic numbers* atau string status/role yang di-hardcode alih-alih memakai enum/konstanta?

### 5. VERIFICATION EVIDENCE
- Apakah perubahan logika kritis sudah memiliki bukti verifikasi nyata (`test`, `lint`, `type-check`, atau `build`) setelah edit terakhir?
- Edge case penting apa yang belum diuji?

### DELIVERABLE: ANTI-SLOP AUDIT REPORT
Sajikan hasil temuan secara ringkas dan objektif:
1. **Verdict**: `APPROVE` | `APPROVE WITH MINOR CLEANUP` | `REJECT (NEEDS SIMPLIFICATION)`
2. **Daftar Temuan Slop** (urutkan dari yang paling berdampak):
   - **ID & Kategori** (misal: `SLOP-01 [Over-Engineering]`)
   - **Lokasi**: `path/to/file.ext:baris`
   - **Masalah**: Mengapa potongan ini termasuk slop / beban maintenance.
   - **Aksi Konkret**: Hapus / *inline*-kan / ganti dengan helper existing (sertakan contoh singkat).
3. **Statistik Ringkas**: Estimasi berapa baris kode yang bisa dipangkas tanpa mengurangi fungsionalitas.
```
