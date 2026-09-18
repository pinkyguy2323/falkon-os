# Falkon OS - build ISO from Windows via Docker, no Linux install needed (ASCII only)
# Requires: Windows 10/11 + Docker Desktop (https://www.docker.com/products/docker-desktop/)
# Run: powershell -ExecutionPolicy Bypass -File scripts/build-windows.ps1 desktop
param([string]$Flavor = "all")

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $ProjectRoot "profiles"))) { $ProjectRoot = (Get-Location).Path }
Write-Host ("[Falkon] Project: " + $ProjectRoot + "  Flavor: " + $Flavor) -ForegroundColor Cyan

# 1. Docker check
try { docker info | Out-Null } catch {
  Write-Host "[ERROR] Install and start Docker Desktop: https://www.docker.com/products/docker-desktop/" -ForegroundColor Red
  Write-Host "Alternative: WSL2 + Arch: wsl --install -d ArchLinux" -ForegroundColor Yellow
  exit 1
}

# 2. Build inside archlinux:latest (has mkarchiso)
$DockerCmd = "set -e; pacman -Sy --noconfirm archiso git reflector rsync squashfs-tools dosfstools; cd /build; chmod +x scripts/build-iso.sh scripts/falkon-*; ./scripts/build-iso.sh " + $Flavor

Write-Host "[Falkon] Building in Docker (10-20 min, downloads ~1.5 GB)..." -ForegroundColor Green
docker run --rm --privileged `
  -v ($ProjectRoot + ":/build") `
  -v "falkon-out:/build/out" `
  -v "falkon-work:/build/work" `
  archlinux:latest bash -c "$DockerCmd"

# 3. Copy ISO out
$OutDir = Join-Path $ProjectRoot "out"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
docker run --rm -v "falkon-out:/in" -v ($OutDir + ":/out") archlinux:latest bash -c "cp -v /in/*.iso /out/ 2>/dev/null || echo 'no iso yet'"
Get-ChildItem (Join-Path $OutDir "*.iso") | Format-Table Name, Length

Write-Host ""
Write-Host "[DONE] ISO is in out\. Next:" -ForegroundColor Green
Write-Host "  VirtualBox: new VM Linux/Arch64, enable EFI, 4GB RAM, attach ISO, Start" -ForegroundColor White
Write-Host "  VMware: Guest OS Linux 6.x kernel 64-bit, EFI, 4GB RAM" -ForegroundColor White
Write-Host "  Ventoy/Rufus: flash ISO to USB for real hardware" -ForegroundColor White
