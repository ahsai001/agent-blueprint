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

    [Alias("s")]
    [switch]$Sync,

    [Alias("a")]
    [switch]$Append,

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
    Write-Host "  .\agent-init.ps1 [-Profile <nama>] [-Target <path>] [-Sync] [-Force]"
    Write-Host "  agent-init.cmd   [-Profile <nama>] [-Target <path>] [-Sync] [-Force]"
    Write-Host ""
    Write-Host "PILIHAN PROFIL:" -ForegroundColor White
    Write-Host "  flutter, codeigniter, laravel, dotnet, nodejs, python, go, general"
    Write-Host ""
    Write-Host "CONTOH:" -ForegroundColor White
    Write-Host "  agent-init"
    Write-Host "  agent-init -Profile flutter"
    Write-Host "  agent-init -Profile python"
    Write-Host "  agent-init -Profile go"
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
    if (Test-Path (Join-Path $Dir "go.mod")) { return "go" }
    if ((Test-Path (Join-Path $Dir "pyproject.toml")) -or (Test-Path (Join-Path $Dir "requirements.txt")) -or (Test-Path (Join-Path $Dir "Pipfile")) -or (Test-Path (Join-Path $Dir "manage.py"))) { return "python" }
    return ""
}

if ([string]::IsNullOrWhiteSpace($ProfileName)) {
    $Detected = Detect-Stack -Dir $TargetDir
    if (-not [string]::IsNullOrWhiteSpace($Detected)) {
        Write-Host "🔍 Terdeteksi stack project: $Detected" -ForegroundColor Blue
        $ProfileName = $Detected
    } elseif ($Sync -and (Test-Path (Join-Path $TargetDir "AGENTS.md"))) {
        $ProfileName = "general"
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
        Write-Host "  6) Python (FastAPI/Django, Type Hints, Pydantic, SQLAlchemy)"
        Write-Host "  7) Go / Golang (Standard Layout, Context, Error Wrapping, Race Check)"
        Write-Host "  8) General (Prinsip Universal Clean Code & SOLID)"
        Write-Host ""
        $choice = Read-Host "Masukkan pilihan [1-8]"
        switch ($choice) {
            "1" { $ProfileName = "flutter" }
            "2" { $ProfileName = "codeigniter" }
            "3" { $ProfileName = "laravel" }
            "4" { $ProfileName = "dotnet" }
            "5" { $ProfileName = "nodejs" }
            "6" { $ProfileName = "python" }
            "7" { $ProfileName = "go" }
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

$SkipGenerate = $false

function Extract-ProjectKnowledge {
    param([string]$FilePath)
    if (-not (Test-Path $FilePath)) { return $null }
    $content = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)

    $anchor = "<!-- BAGIAN INI DIISI & DIPERBARUI"
    $idx = $content.IndexOf($anchor)
    if ($idx -ne -1) {
        $borderIdx = $content.LastIndexOf("<!-- ===", $idx)
        if ($borderIdx -ne -1) {
            return $content.Substring($borderIdx)
        }
        return $content.Substring($idx)
    }

    $headerAnchor = "# PROJECT-SPECIFIC KNOWLEDGE"
    $idx = $content.IndexOf($headerAnchor)
    if ($idx -ne -1) {
        return $content.Substring($idx)
    }

    return $null
}

function Safe-Append-Guardrails {
    param([string]$TargetFile, [string]$BlueprintDirectory)

    $existingContent = [System.IO.File]::ReadAllText($TargetFile, [System.Text.Encoding]::UTF8)
    $appendBuffer = ""
    $CoreFiles = Get-ChildItem -Path (Join-Path $BlueprintDirectory "templates\core") -Filter "0[1-5]*.md" | Sort-Object Name
    $addedCount = 0
    foreach ($cf in $CoreFiles) {
        $lines = Get-Content $cf.FullName
        $headerLine = $lines | Where-Object { $_ -match "^#+\s+(.+)" } | Select-Object -First 1
        $headerTitle = ""
        if ($headerLine -match "^#+\s+(.+)") {
            $headerTitle = $matches[1]
        }

        if ($headerTitle -and $existingContent.Contains($headerTitle)) {
            Write-Host "ℹ️ Bagian '$headerTitle' sudah ada, dilewati." -ForegroundColor Yellow
        } else {
            $content = [System.IO.File]::ReadAllText($cf.FullName, [System.Text.Encoding]::UTF8)
            $appendBuffer += "`n`n" + $content + "`n`n---`n"
            Write-Host "✓ Menyisipkan modul: $headerTitle" -ForegroundColor Green
            $addedCount++
        }
    }

    if ($addedCount -gt 0) {
        $banner = @"

---

<!-- ===================================================================== -->
<!-- UNIVERSAL SAFETY GUARDRAILS & AI BEHAVIORAL STANDARDS                 -->
<!-- Disisipkan otomatis oleh agent-blueprint (Safe Append Mode)           -->
<!-- Tanggal: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))                              -->
<!-- ===================================================================== -->
"@
        [System.IO.File]::AppendAllText($TargetFile, $banner + $appendBuffer, [System.Text.Encoding]::UTF8)
        Write-Host "✓ Berhasil menyisipkan $addedCount modul guardrails baru (100% aturan lama tetap utuh)." -ForegroundColor Green
    } else {
        Write-Host "ℹ️ Seluruh modul guardrails sudah lengkap di AGENTS.md (tidak ada yang perlu diubah)." -ForegroundColor Blue
    }
}

if ((Test-Path $OutputFile) -and (-not $Force)) {
    if ($Sync -or $Append) {
        $existingChoice = "1"
    } else {
        Write-Host "⚠️ Terdeteksi file AGENTS.md sudah ada di: $OutputFile" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Pilih tindakan yang diinginkan:" -ForegroundColor White
        Write-Host "  1) Smart Sync: Sisipkan Guardrails & Karpathy baru (100% aturan lama AMAN & UTUH) [Rekomendasi]" -ForegroundColor Green
        Write-Host "  2) Backup AGENTS.md lama & Ganti total dengan Blueprint baru" -ForegroundColor Cyan
        Write-Host "  3) Pasang Symlinks & Git Hooks saja (Pertahankan AGENTS.md apa adanya)" -ForegroundColor Yellow
        Write-Host "  4) Batal" -ForegroundColor Red
        Write-Host ""
        $existingChoice = Read-Host "Masukkan pilihan [1-4] (default: 1)"
        if ([string]::IsNullOrWhiteSpace($existingChoice)) { $existingChoice = "1" }
    }

    switch ($existingChoice) {
        "1" {
            $timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
            $backupFile = "$OutputFile.bak.$timestamp"
            Copy-Item -Path $OutputFile -Destination $backupFile -Force
            Write-Host "✓ File lama telah di-backup ke: $backupFile" -ForegroundColor Green
            Safe-Append-Guardrails -TargetFile $OutputFile -BlueprintDirectory $BlueprintDir
            $SkipGenerate = $true
        }
        "2" {
            $timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
            $backupFile = "$OutputFile.bak.$timestamp"
            Copy-Item -Path $OutputFile -Destination $backupFile -Force
            Write-Host "✓ File lama telah di-backup ke: $backupFile" -ForegroundColor Green
            $SkipGenerate = $false
        }
        "3" {
            Write-Host "ℹ️ Mempertahankan isi AGENTS.md yang sudah ada..." -ForegroundColor Blue
            $SkipGenerate = $true
        }
        Default {
            Write-Host "Operasi dibatalkan." -ForegroundColor Blue
            exit 0
        }
    }
} else {
    # Jika file sudah ada tapi mode Force aktif, tetap buat backup pengaman!
    if ((Test-Path $OutputFile) -and $Force) {
        $timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
        $backupFile = "$OutputFile.bak.$timestamp"
        Copy-Item -Path $OutputFile -Destination $backupFile -Force
        Write-Host "⚠️ Mode Force: File lama telah di-backup ke: $backupFile" -ForegroundColor Yellow
    }
}

if (-not $SkipGenerate) {
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
    $CoreFiles = Get-ChildItem -Path (Join-Path $BlueprintDir "templates\core") -Filter "0[1-5]*.md" | Sort-Object Name
    foreach ($cf in $CoreFiles) {
        $content = [System.IO.File]::ReadAllText($cf.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::AppendAllText($OutputFile, "`n" + $content + "`n`n---`n", [System.Text.Encoding]::UTF8)
    }

    # 3. Append Profile Template
    $ProfileContent = [System.IO.File]::ReadAllText($ProfileFile, [System.Text.Encoding]::UTF8)
    [System.IO.File]::AppendAllText($OutputFile, "`n" + $ProfileContent + "`n`n---`n", [System.Text.Encoding]::UTF8)

    # 4. Append Project-Specific Knowledge Registry
    if ($PreservedKnowledge) {
        [System.IO.File]::AppendAllText($OutputFile, "`n" + $PreservedKnowledge + "`n", [System.Text.Encoding]::UTF8)
        Write-Host "✓ Project-Specific Knowledge lama berhasil di-merge ke AGENTS.md baru!" -ForegroundColor Green
    } else {
        $ProjectKnowledgeFile = Join-Path $BlueprintDir "templates\core\06-project-knowledge.md"
        if (Test-Path $ProjectKnowledgeFile) {
            $KnowledgeContent = [System.IO.File]::ReadAllText($ProjectKnowledgeFile, [System.Text.Encoding]::UTF8)
            [System.IO.File]::AppendAllText($OutputFile, "`n" + $KnowledgeContent + "`n", [System.Text.Encoding]::UTF8)
        }
    }

    Write-Host "✓ File AGENTS.md berhasil dibuat di: $OutputFile" -ForegroundColor Green
}

# 5. Buat Symlink / Copy untuk AI Agent
function Link-Or-Copy {
    param([string]$LinkName)
    $Destination = Join-Path $TargetDir $LinkName
    $ParentDir = Split-Path -Parent $Destination
    if ($ParentDir -and (-not (Test-Path $ParentDir))) {
        New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
    }
    if (Test-Path $Destination) {
        Remove-Item -Path $Destination -Force -ErrorAction SilentlyContinue
    }

    $relativeTarget = "AGENTS.md"
    if ($LinkName.Contains("/") -or $LinkName.Contains("\")) {
        $relativeTarget = "..\AGENTS.md"
    }

    $symlinkSuccess = $false
    try {
        # Coba buat symbolic link
        New-Item -ItemType SymbolicLink -Path $Destination -Target $relativeTarget -Force -ErrorAction Stop | Out-Null
        $symlinkSuccess = $true
        Write-Host "✓ Symlink dibuat: $LinkName -> $relativeTarget" -ForegroundColor Green
    } catch {
        # Fallback jika akun Windows tidak memiliki hak cipta symlink (non-developer mode)
        Copy-Item -Path $OutputFile -Destination $Destination -Force
        Write-Host "✓ File disalin (fallback non-symlink): $LinkName" -ForegroundColor Yellow
    }
}

Link-Or-Copy "CLAUDE.md"
Link-Or-Copy ".cursorrules"
Link-Or-Copy ".windsurfrules"
Link-Or-Copy ".clinerules"
Link-Or-Copy ".github\copilot-instructions.md"

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
if ($SkipGenerate) {
    Write-Host "🎉 Smart Sync Berhasil!" -ForegroundColor Green
    Write-Host "Project Anda sekarang terlindungi oleh guardrails & standar Karpathy terbaru."
    Write-Host "Seluruh aturan kustom lama Anda tetap 100% utuh & aman."
} else {
    Write-Host "🎉 Inisialisasi Berhasil!" -ForegroundColor Green
    Write-Host "Project Anda sekarang terlindungi oleh guardrails standar profesional."
    Write-Host ""
    Write-Host "Langkah Selanjutnya bersama AI Agent Anda:" -ForegroundColor White
    Write-Host "Buka project ini di Antigravity / Cursor / Claude / Windsurf,"
    Write-Host "lalu copy-paste prompt onboarding di bawah ini ke chat AI:"
    Write-Host ""

    $PromptFile = Join-Path $BlueprintDir "prompts\ONBOARDING_AGENT.md"
    if (Test-Path $PromptFile) {
        $content = [System.IO.File]::ReadAllText($PromptFile, [System.Text.Encoding]::UTF8)
        $startIdx = $content.IndexOf("```markdown")
        if ($startIdx -ne -1) {
            $startIdx += "```markdown".Length
            $endIdx = $content.IndexOf("```", $startIdx)
            if ($endIdx -ne -1) {
                $onboardingPrompt = $content.Substring($startIdx, $endIdx - $startIdx).Trim()
                Write-Host "---------------------------------------------------------------" -ForegroundColor Yellow
                Write-Host $onboardingPrompt -ForegroundColor Yellow
                Write-Host "---------------------------------------------------------------" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "   `"Tolong baca AGENTS.md dan audit struktur project ini sebelum mulai bekerja.`"" -ForegroundColor Yellow
    }
}
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
