# Falkon OS - publish to GitHub in 3 steps (Windows PowerShell 5.1 safe, ASCII only)
# Requires: git + gh CLI (https://cli.github.com/)
# Run: powershell -ExecutionPolicy Bypass -File scripts/publish-github.ps1
# Optional: -RepoName "falkon-os" -Visibility "public" -Tag "v1.0"
param(
  [string]$RepoName = "falkon-os",
  [string]$Visibility = "public",
  [string]$Tag = ""
)

$ErrorActionPreference = "Stop"

# 0. Checks
try { git --version | Out-Null } catch { Write-Host "Install git: https://git-scm.com/download/win" -ForegroundColor Red; exit 1 }
try { gh --version | Out-Null } catch { Write-Host "Install gh: winget install GitHub.cli" -ForegroundColor Red; exit 1 }

# 1. git init (repo root is the falkon-os folder)
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path ".git")) {
  git init -b main
  git add .
  git commit -m "Falkon OS 1.0 Swift: Arch + ghostty/vscode/firefox/steam, 45 themes, 12 langs, easy installer"
  Write-Host "[1/3] Commit created" -ForegroundColor Green
} else {
  git add .
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
  git commit -m "update $stamp" --allow-empty | Out-Null
  Write-Host "[1/3] Changes committed" -ForegroundColor Green
}

# 2. Create repo and push
$User = (gh api user --jq .login)
Write-Host ("[2/3] Pushing to github.com/" + $User + "/" + $RepoName + " (" + $Visibility + ")...") -ForegroundColor Cyan
gh repo create $RepoName --$Visibility --source=. --push --remote=origin 2>$null
if ($LASTEXITCODE -ne 0) {
  git branch -M main
  git remote add origin ("https://github.com/" + $User + "/" + $RepoName + ".git") 2>$null
  git push -u origin main
}

# 3. Tag triggers cloud ISO build -> ISO appears in Releases
if ($Tag -ne "") {
  git tag $Tag
  git push origin $Tag
  Write-Host ("[3/3] Tag " + $Tag + " pushed. ISO will build in Actions (~20 min), see Releases tab.") -ForegroundColor Green
} else {
  Write-Host "[3/3] Done. To build ISO in cloud, run:" -ForegroundColor Green
  Write-Host "  git tag v1.0; git push origin v1.0" -ForegroundColor White
  Write-Host "  or Actions -> Build ISO -> Run workflow (ISO lands in Artifacts)." -ForegroundColor White
}
Write-Host ("Link: https://github.com/" + $User + "/" + $RepoName) -ForegroundColor Cyan
