# Falkon OS - publish to GitHub (Windows PowerShell 5.1 safe, ASCII only)
# Requires: git + gh CLI, logged in (gh auth login)
# Run: powershell -ExecutionPolicy Bypass -File scripts/publish-github.ps1
# Optional: -RepoName "falkon-os" -Visibility "public" -Tag "v1.0"
param(
  [string]$RepoName = "falkon-os",
  [string]$Visibility = "public",
  [string]$Tag = ""
)

# NOTE: keep "Continue" here. With "Stop", PowerShell 5.1 treats ANY
# stderr output of git/gh (even normal progress like "To https://...")
# as a fatal error and kills the script. We check $LASTEXITCODE instead.
$ErrorActionPreference = "Continue"

function Run-Native([string]$cmd) {
  Write-Host ("> " + $cmd) -ForegroundColor DarkGray
  $out = Invoke-Expression $cmd 2>&1
  $code = $LASTEXITCODE
  foreach ($line in @($out)) { Write-Host ("  " + $line) }
  return $code
}

# 0. Checks
$code = Run-Native "git --version"
if ($code -ne 0) { Write-Host "Install git: https://git-scm.com/download/win" -ForegroundColor Red; exit 1 }
$code = Run-Native "gh --version"
if ($code -ne 0) { Write-Host "Install gh: winget install GitHub.cli" -ForegroundColor Red; exit 1 }

# 1. git init (repo root is the falkon-os folder)
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path ".git")) {
  if ((Run-Native "git init -b main") -ne 0) { exit 1 }
  if ((Run-Native "git add .") -ne 0) { exit 1 }
  if ((Run-Native "git commit -m 'Falkon OS 1.0 Swift: Arch + ghostty/vscode/firefox/steam, 45 themes, 12 langs, easy installer'") -ne 0) { exit 1 }
  Write-Host "[1/4] Commit created" -ForegroundColor Green
} else {
  Run-Native "git add ." | Out-Null
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
  Run-Native ("git commit -m 'update " + $stamp + "' --allow-empty") | Out-Null
  Write-Host "[1/4] Changes committed" -ForegroundColor Green
}

# 2. Create repo (or reuse existing) and push
$User = (gh api user --jq .login)
if ([string]::IsNullOrEmpty($User)) { Write-Host "Run: gh auth login" -ForegroundColor Red; exit 1 }
$Slug = ($User + "/" + $RepoName)
Write-Host ("[2/4] Target: github.com/" + $Slug) -ForegroundColor Cyan

$code = Run-Native ("gh repo create " + $RepoName + " --" + $Visibility + " --source=. --remote=origin")
if ($code -ne 0) {
  Write-Host "Repo exists already (or create failed), will reuse it." -ForegroundColor Yellow
  Run-Native "git remote remove origin" | Out-Null
  Run-Native ("git remote add origin https://github.com/" + $Slug + ".git") | Out-Null
}
Run-Native "git branch -M main" | Out-Null
if ((Run-Native "git push -u origin main") -ne 0) {
  Write-Host "Push failed, see lines above. Usual causes: no internet, wrong credentials (gh auth refresh -h github.com)." -ForegroundColor Red
  exit 1
}
Write-Host "[2/4] Code pushed" -ForegroundColor Green

# 3. Make the repo look complete: description + topics
Run-Native ("gh repo edit " + $Slug + " --description 'Falkon OS - Arch-based distro: easy installer, auto drivers, 45 themes, 12 languages' --add-topic arch-linux --add-topic distro --add-topic hyprland --add-topic kde-plasma --add-topic archiso") | Out-Null
Write-Host "[3/4] Description + topics set" -ForegroundColor Green

# 4. Tag triggers cloud ISO build -> ISO appears in Releases
if ($Tag -ne "") {
  Run-Native ("git tag " + $Tag) | Out-Null
  if ((Run-Native ("git push origin " + $Tag)) -ne 0) { exit 1 }
  Write-Host ("[4/4] Tag " + $Tag + " pushed. ISO builds in Actions (~20 min), see Releases tab.") -ForegroundColor Green
} else {
  Write-Host "[4/4] Done. To build ISO in cloud, run:" -ForegroundColor Green
  Write-Host "  git tag v1.0; git push origin v1.0" -ForegroundColor White
  Write-Host "  or Actions -> Build ISO -> Run workflow (ISO lands in Artifacts)." -ForegroundColor White
}
Write-Host ("Link: https://github.com/" + $Slug) -ForegroundColor Cyan
