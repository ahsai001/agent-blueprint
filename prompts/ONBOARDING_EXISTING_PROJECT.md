# ONBOARDING UNTUK PROJECT EXISTING (YANG SUDAH ADA AGENTS.MD)

Gunakan prompt ini saat membuka project yang **sudah memiliki file `AGENTS.md` sebelumnya** (misalnya `web-syshab` atau `syshab-api v2`), agar AI Agent melakukan sinkronisasi dan audit tanpa menghapus aturan-aturan spesifik yang sudah ada.

---

### 📋 Copy-Paste Prompt Berikut ke Chat AI Agent:

```markdown
Halo! Project ini sudah memiliki file `AGENTS.md` yang memuat aturan arsitektur spesifik.

Tolong lakukan audit sinkronisasi berikut:
1. **Baca Teliti `AGENTS.md` yang Sudah Ada**:
   - Pahami aturan arsitektur, konvensi, dan batasan yang sudah tertulis di dalamnya.
   - **DILARANG MENGHAPUS** aturan, endpoint checklist, atau dokumentasi modul spesifik yang sudah ada!

2. **Cek Kelengkapan Universal Safety Guardrails**:
   Pastikan prinsip-prinsip keselamatan berikut sudah tercakup dalam file tersebut:
   - *Database Safety*: Dilarang eksekusi langsung query selain SELECT tanpa instruksi eksplisit user.
   - *Strict Zero-Dummy Policy*: Dilarang membuat array/mock fallback saat data API kosong atau error.
   - *SOP Inspect Definition First*: Wajib membaca definisi fungsi/helper sebelum memanggilnya.
   - *Scope Lock*: Dilarang mass reformatting atau mengubah file di luar tiket.
   - *Hot-Spot Append-Only*: Router, DI container, dan i18n hanya boleh di-append, jangan diacak urutannya.
   - *Jika ada prinsip di atas yang belum tercantum, tambahkan ke dalam `AGENTS.md` secara rapi.*

3. **Perbarui / Validasi Peta Registry Project**:
   - Pastikan daftar controller besar / file monolitik (> 1.000 baris) sudah tercatat lengkap.
   - Pastikan daftar helper utama dan base model sudah terdata agar tidak dibuat ganda.

4. Laporkan ringkasan hasil auditmu dan konfirmasikan kesiapanmu bekerja di repository ini.
```
