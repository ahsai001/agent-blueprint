# SECURITY AUDIT PLAYBOOK (SOP AUDIT KEAMANAN REPOSITORY)

Gunakan prompt ini saat meminta AI Agent (Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes, dll.) untuk melakukan **Security Audit & Vulnerability Assessment** mendalam pada codebase repository ini.

---

### 📋 Copy-Paste Prompt Berikut ke Chat AI Agent:

```markdown
Halo! Tolong lakukan COMPREHENSIVE SECURITY AUDIT pada repository ini.

Ikuti metodologi audit multi-fase berikut secara berurutan:

### 1. RECONNAISSANCE & ATTACK SURFACE MAPPING
- Petakan seluruh entry-point publik (API routes, Web controller endpoints, WebSocket channels, CLI commands).
- Identifikasi sistem otentikasi (JWT, Session, OAuth, API Key) dan mekanisme authorization/RBAC.
- Identifikasi integrasi pihak ketiga, payment gateway, file upload handler, dan background jobs.

### 2. VULNERABILITY & INJECTION ANALYSIS
Periksa secara teliti apakah ada celah berikut pada codebase:
- **Injection Risks**: Raw SQL queries tanpa prepared statements / ORM parameter bindings, NoSQL injection, Command injection (`exec`/`system`/`shell_exec`/child_process), Template injection (SSTI).
- **Authentication & Authorization**: Broken access control, IDOR (Insecure Direct Object Reference) pada query mutasi/update/delete, missing auth middleware pada private routes, token expiry & refresh flow.
- **Data Protection & Leaks**: Hardcoded secrets, credential logging, password plaintext, missing hashing (Argon2/Bcrypt wajib), verbose error responses yang membocorkan internal database/stack trace.
- **Client & Web Vulnerabilities**: CSRF protection, Cross-Site Scripting (XSS), missing CORS restrictions, open redirect, insecure cookie flags (`HttpOnly`, `Secure`, `SameSite`).
- **File Handling**: Unrestricted file upload (ekstensi, mime type, directory traversal via filename), SSRF (Server-Side Request Forgery) pada URL fetchers/cURL calls.

### 3. DEPENDENCY & CONFIGURATION AUDIT
- Periksa manifest dependency (`package.json`, `composer.json`, `pubspec.yaml`, `requirements.txt`, `go.mod`, `.csproj`) untuk mendeteksi package yang usang (*deprecated*) atau memiliki riwayat CVE kritis.
- Periksa konfigurasi keamanan environment (`.env.example`, security headers, SSL/TLS enforcement, database connection flags).

### 4. DELIVERABLE: SECURITY AUDIT REPORT
Sajikan hasil temuan dalam format laporan markdown terstruktur:
1. **Executive Summary**: Skor risiko keseluruhan (Critical / High / Medium / Low) dan ringkasan status kesehatan keamanan codebase.
2. **Detailed Findings Matrix**:
   - **ID / Judul Temuan** (misal: `SEC-01: Potensi IDOR pada Endpoint Update Profile`)
   - **Severity**: [CRITICAL | HIGH | MEDIUM | LOW | INFO]
   - **Lokasi File**: `path/to/file.ext:baris`
   - **Deskripsi Kerentanan & Vektor Serangan**: Bagaimana celah ini bisa dieksploitasi.
   - **Rekomendasi Perbaikan (Remediation)**: Berikan kode solusi konkret (*before vs after*).
3. **Immediate Action Checklist**: Daftar 3-5 tindakan prioritas utama yang harus diperbaiki segera.
```
