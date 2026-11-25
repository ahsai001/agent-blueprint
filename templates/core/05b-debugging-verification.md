# SYSTEMATIC DEBUGGING & VERIFICATION BEFORE COMPLETION

Aturan ringkas untuk mencegah kebiasaan *trial-and-error* acak saat memperbaiki bug serta mencegah klaim "selesai" tanpa bukti nyata.

---

### 1. Systematic Debugging (Root Cause First)
- **Reproduksi & Baca Error Utuh**: Sebelum mengedit kode, baca pesan error, stack trace, dan log terkait secara lengkap, lalu reproduksi masalahnya bila memungkinkan.
- **Cari Akar Masalah, Bukan Tambal Gejala**: Pastikan Anda memahami *mengapa* bug terjadi sebelum menulis perbaikan. Dilarang memasang *workaround* spekulatif tanpa memahami penyebabnya.
- **Satu Hipotesis per Perubahan**: Uji satu perbaikan terfokus dalam satu waktu agar jelas perubahan mana yang benar-benar menyelesaikan masalah.
- **Aturan Berhenti (Max 2–3 Percobaan)**: Jika 2–3 percobaan perbaikan berturut-turut tetap gagal, **berhenti menebak**. Evaluasi ulang asumsi dasar, periksa kembali alur data/arsitektur, dan diskusikan temuan serta opsi dengan user sebelum mencoba lagi.

---

### 2. Verification Before Completion (Evidence Over Claims)
- **Wajib Bukti Nyata**: Dilarang menyatakan *"sudah selesai"*, *"bug teratasi"*, atau *"semua aman"* hanya berdasarkan pembacaan kode atau asumsi.
- **Verifikasi Setelah Edit Terakhir**: Jalankan perintah verifikasi yang relevan dengan stack proyek (`test`, `build`, `lint`, `analyze`, type-check, atau skrip reproduksi) **setelah perubahan kode terakhir**, lalu baca output serta exit code-nya secara utuh.
- **Jujur atas Batasan Verifikasi**: Jika verifikasi tidak dapat dijalankan di lingkungan lokal (misal butuh kredensial produksi, perangkat fisik, atau layanan eksternal), sampaikan secara eksplisit apa saja yang **sudah** diverifikasi dan apa yang **belum** bisa diverifikasi.
