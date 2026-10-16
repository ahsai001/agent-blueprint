# ==============================================================================
# install.ps1: Windows Installer untuk agent-blueprint
# Mendaftarkan direktori repo ke User PATH agar perintah `agent-init` dapat dijalankan dari folder mana pun
# ==============================================================================

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "🔧 Memasang agent-blueprint di Windows..." -ForegroundColor Cyan

# Ambil User PATH saat ini
$UserPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

if ($UserPath -split ";" -contains $RepoDir) {
    Write-Host "✅ Direktori repo sudah terdaftar di User PATH:" -ForegroundColor Green
    Write-Host "   $RepoDir" -ForegroundColor White
} else {
    $NewPath = $UserPath.TrimEnd(";") + ";" + $RepoDir
    [Environment]::SetEnvironmentVariable("Path", $NewPath, [EnvironmentVariableTarget]::User)
    Write-Host "✅ Berhasil menambahkan repo ke User PATH:" -ForegroundColor Green
    Write-Host "   $RepoDir" -ForegroundColor White
    Write-Host "ℹ️  Buka jendela PowerShell / Terminal baru agar perubahan PATH aktif." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setelah terminal baru dibuka, Anda bisa menjalankan perintah berikut di folder project apa pun:" -ForegroundColor White
Write-Host "  agent-init" -ForegroundColor Green
Write-Host "  agent-init -Profile flutter" -ForegroundColor Green
