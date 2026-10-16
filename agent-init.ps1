# ==============================================================================
# agent-init.ps1: Universal AI Agent Standard Initializer (Windows PowerShell)
# Repository: agent-blueprint
# ==============================================================================

[CmdletBinding()]
param (
    [Alias("p")]
    [string]$ProfileName = "",

    [Alias("t")]
    [string]$Target = (Get-Location).Path,

    [Alias("f")]
    [switch]$Force,

    [Alias("h")]
    [switch]$Help
)

$BlueprintDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Show-Help {
    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        AGENT-BLUEPRINT INITIALIZER (WINDOWS POWERSHELL)       ║" -ForegroundColor Cyan
    Write-Host "║     Standar Baku Arsitektur & Safety Guardrails untuk AI     ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "PENGGUNAAN:" -ForegroundColor White
    Write-Host "  .\agent-init.ps1 [-Profile <nama>] [-Target <path>] [-Force]"
    Write-Host "  agent-init.cmd   [-Profile <nama>] [-Target <path>] [-Force]"
    Write-Host ""
    Write-Host "PILIHAN PROFIL:" -ForegroundColor White
    Write-Host "  flutter, codeigniter, laravel, dotnet, nodejs, general"
    Write-Host ""
    Write-Host "CONTOH:" -ForegroundColor White
    Write-Host "  agent-init"
    Write-Host "  agent-init -Profile flutter"
    Write-Host "  agent-init -Profile laravel -Target C:\Projects\MyApi"
    exit 0
}

if ($Help) {
    Show-Help
}

# Normalisasi path target
if (-not (Test-Path $Target)) {
    Write-Host "❌ Direktori target tidak ditemukan: $Target" -ForegroundColor Red
    exit 1
}

$TargetDir = (Resolve-Path $Target).Path
$ProjectName = Split-Path -Leaf $TargetDir

# Auto-detect profile jika kosong
function Detect-Stack {
    param([string]$Dir)
    if (Test-Path (Join-Path $Dir "pubspec.yaml")) { return "flutter" }
    if (Test-Path (Join-Path $Dir "artisan")) { return "laravel" }
    if ((Test-Path (Join-Path $Dir "application\config\config.php")) -or (Test-Path (Join-Path $Dir "system\core"))) { return "codeigniter" }
    if ((Get-ChildItem -Path $Dir -Filter "*.csproj" -ErrorAction SilentlyContinue).Count -gt 0 -or (Get-ChildItem -Path $Dir -Filter "*.sln" -ErrorAction SilentlyContinue).Count -gt 0) { return "dotnet" }
    if (Test-Path (Join-Path $Dir "package.json")) { return "nodejs" }
    return ""
}

if ([string]::IsNullOrWhiteSpace($ProfileName)) {
    $Detected = Detect-Stack -Dir $TargetDir
    if (-not [string]::IsNullOrWhiteSpace($Detected)) {
        Write-Host "🔍 Terdeteksi stack project: $Detected" -ForegroundColor Blue
        $ProfileName = $Detected
    } else {
        Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║                   AGENT-BLUEPRINT INITIALIZER                 ║" -ForegroundColor Cyan
        Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host "Pilih profil arsitektur untuk project '$ProjectName':" -ForegroundColor Yellow
        Write-Host "  1) Flutter & Dart (Clean Architecture, Cubit, i18n, Screen matrix)"
        Write-Host "  2) CodeIgniter (API v2, ACID Transaction, SP-Ready, RBAC)"
        Write-Host "  3) Laravel (Service/Action, FormRequest, Migration safety)"
        Write-Host "  4) .NET & C# (Clean Arch, CQRS, EF Core AsNoTracking)"
        Write-Host "  5) Node.js & TypeScript (NestJS/Express, Zod, Strict Types)"
        Write-Host "  6) General (Prinsip Universal Clean Code & SOLID)"
        Write-Host ""
        $choice = Read-Host "Masukkan pilihan [1-6]"
        switch ($choice) {
            "1" { $ProfileName = "flutter" }
            "2" { $ProfileName = "codeigniter" }
            "3" { $ProfileName = "laravel" }
            "4" { $ProfileName = "dotnet" }
            "5" { $ProfileName = "nodejs" }
            Default { $ProfileName = "general" }
        }
    }
}

$ProfileFile = Join-Path $BlueprintDir "templates\profiles\$ProfileName.md"
if (-not (Test-Path $ProfileFile)) {
    Write-Host "⚠️ Profil '$ProfileName' tidak ditemukan, menggunakan 'general'" -ForegroundColor Yellow
    $ProfileName = "general"
    $ProfileFile = Join-Path $BlueprintDir "templates\profiles\general.md"
}

$OutputFile = Join-Path $TargetDir "AGENTS.md"

if ((Test-Path $OutputFile) -and (-not $Force)) {
    Write-Host "⚠️ File AGENTS.md sudah ada di: $OutputFile" -ForegroundColor Yellow
    $confirm = Read-Host "Apakah ingin menimpa (overwrite)? [y/N]"
    if ($confirm -notmatch "^[Yy]$") {
        Write-Host "Operasi dibatalkan." -ForegroundColor Blue
        exit 0
    }
}

Write-Host "🚀 Men-generate AGENTS.md untuk project: $ProjectName (Stack: $ProfileName)..." -ForegroundColor Cyan

# 1. Header Dokumen
$Header = @"
# AGENTS.md - Standar Baku Pengembangan AI Agent

> **Project**: $ProjectName  
> **Profile**: $ProfileName  
> **Source Blueprint**: agent-blueprint  
> **Generated At**: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))

Dokumen ini memuat standar baku arsitektur, safety guardrails, dan protokol kerja untuk seluruh AI Agent (Antigravity, Cursor, Claude Code, Windsurf, OpenCode, Hermes, dll.) saat mengembangkan kode di repository ini.

---

"@

[System.IO.File]::WriteAllText($OutputFile, $Header, [System.Text.Encoding]::UTF8)

# 2. Append Core Templates (01 sampai 05)
$CoreFiles = Get-ChildItem -Path (Join-Path $BlueprintDir "templates\core") -Filter "[0-5]*.md" | Sort-Object Name
foreach ($cf in $CoreFiles) {
    $content = [System.IO.File]::ReadAllText($cf.FullName, [System.Text.Encoding]::UTF8)
    [System.IO.File]::AppendAllText($OutputFile, "`n" + $content + "`n`n---`n", [System.Text.Encoding]::UTF8)
}

# 3. Append Profile Template
$ProfileContent = [System.IO.File]::ReadAllText($ProfileFile, [System.Text.Encoding]::UTF8)
[System.IO.File]::AppendAllText($OutputFile, "`n" + $ProfileContent + "`n`n---`n", [System.Text.Encoding]::UTF8)

# 4. Append Project-Specific Knowledge Registry (06)
$ProjectKnowledgeFile = Join-Path $BlueprintDir "templates\core\06-project-knowledge.md"
if (Test-Path $ProjectKnowledgeFile) {
    $KnowledgeContent = [System.IO.File]::ReadAllText($ProjectKnowledgeFile, [System.Text.Encoding]::UTF8)
    [System.IO.File]::AppendAllText($OutputFile, "`n" + $KnowledgeContent + "`n", [System.Text.Encoding]::UTF8)
}

Write-Host "✓ File AGENTS.md berhasil dibuat di: $OutputFile" -ForegroundColor Green

# 5. Buat Symlink / Copy untuk AI Agent
function Link-Or-Copy {
    param([string]$LinkName)
    $Destination = Join-Path $TargetDir $LinkName
    if (Test-Path $Destination) {
        Remove-Item -Path $Destination -Force -ErrorAction SilentlyContinue
    }
    
    $symlinkSuccess = $false
    try {
        # Coba buat symbolic link
        New-Item -ItemType SymbolicLink -Path $Destination -Target "AGENTS.md" -Force -ErrorAction Stop | Out-Null
        $symlinkSuccess = $true
        Write-Host "✓ Symlink dibuat: $LinkName -> AGENTS.md" -ForegroundColor Green
    } catch {
        # Fallback jika akun Windows tidak memiliki hak cipta symlink (non-developer mode)
        Copy-Item -Path $OutputFile -Destination $Destination -Force
        Write-Host "✓ File disalin (fallback non-symlink): $LinkName" -ForegroundColor Yellow
    }
}

Link-Or-Copy "CLAUDE.md"
Link-Or-Copy ".cursorrules"
Link-Or-Copy ".windsurfrules"

# 6. Pasang Git Pre-commit Hook jika ada folder .git
$GitDir = Join-Path $TargetDir ".git"
if (Test-Path $GitDir) {
    $HooksDir = Join-Path $GitDir "hooks"
    if (-not (Test-Path $HooksDir)) {
        New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
    }
    $SourceHook = Join-Path $BlueprintDir "templates\hooks\pre-commit"
    $TargetHook = Join-Path $HooksDir "pre-commit"
    Copy-Item -Path $SourceHook -Destination $TargetHook -Force
    Write-Host "✓ Git pre-commit hook berhasil dipasang di: $TargetHook" -ForegroundColor Green
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🎉 Inisialisasi Berhasil!" -ForegroundColor Green
Write-Host "Project Anda sekarang terlindungi oleh guardrails standar profesional."
Write-Host ""
Write-Host "Langkah Selanjutnya bersama AI Agent Anda:" -ForegroundColor White
Write-Host "1. Buka project ini di Antigravity / Cursor / Claude / Windsurf."
Write-Host "2. Berikan instruksi onboarding awal ke Agent:"
Write-Host "   `"Tolong baca AGENTS.md dan audit struktur project ini sebelum mulai bekerja.`"" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
