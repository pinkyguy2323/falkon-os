#!/usr/bin/env bash
# Falkon OS - сборка ISO (запускать на чистом Arch Linux)
# Использование:
#   sudo ./build-iso.sh desktop   # классический KDE
#   sudo ./build-iso.sh tiling    # Hyprland как Omarchy
#   sudo ./build-iso.sh core      # консоль, <500МБ RAM
#   sudo ./build-iso.sh all
set -euo pipefail

FLAVOR="${1:-all}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$HERE/out"
WORK="$HERE/work"

need_root() {
  if [[ $EUID -ne 0 ]]; then echo "Запусти через sudo"; exit 1; fi
}

install_deps() {
  pacman -Sy --needed --noconfirm archiso git reflector rsync squashfs-tools
}

prepare_profile() {
  local flavor="$1"
  local src="$HERE/profiles/$flavor"
  local dst="/tmp/falkon-build-$flavor"
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -a "$src/profiledef.sh" "$dst/"
  # Склеиваем base + flavor пакеты в packages.x86_64
  cat "$HERE/profiles/base-packages.txt" "$src/packages.x86_64" | grep -v '^#' | grep -v '^$' | sort -u > "$dst/packages.x86_64"
  cp "$HERE/profiles/pacman.conf" "$dst/pacman.conf"
  # airootfs overlay
  rm -rf "$dst/airootfs"
  cp -a "$HERE/airootfs" "$dst/airootfs" 2>/dev/null || mkdir -p "$dst/airootfs"
  mkdir -p "$dst/airootfs/usr/bin"
  cp -a "$HERE/scripts/falkon-drivers" "$dst/airootfs/usr/bin/falkon-drivers"
  cp -a "$HERE/scripts/falkon-tweaks" "$dst/airootfs/usr/bin/falkon-tweaks"
  cp -a "$HERE/scripts/falkon-welcome" "$dst/airootfs/usr/bin/falkon-welcome" 2>/dev/null || true
  cp -a "$HERE/scripts/falkon-themes" "$dst/airootfs/usr/bin/falkon-themes" 2>/dev/null || true
  cp -a "$HERE/scripts/falkon-customizer" "$dst/airootfs/usr/bin/falkon-customizer" 2>/dev/null || true
  cp -a "$HERE/scripts/falkon-install" "$dst/airootfs/usr/bin/falkon-install" 2>/dev/null || true
  cp -a "$HERE/scripts/falkon-wallpaper" "$dst/airootfs/usr/bin/falkon-wallpaper" 2>/dev/null || true
  cp -a "$HERE/scripts/falkon-lang" "$dst/airootfs/usr/bin/falkon-lang" 2>/dev/null || true
  cp -a "$HERE/scripts/falkon-install-easy" "$dst/airootfs/usr/bin/falkon-install-easy" 2>/dev/null || true
  mkdir -p "$dst/airootfs/usr/share/falkon/themes"
  cp -a "$HERE/airootfs/usr/share/falkon/themes/"* "$dst/airootfs/usr/share/falkon/themes/" 2>/dev/null || true
  # Calamares для desktop/tiling
  if [[ "$flavor" != "core" ]]; then
    mkdir -p "$dst/airootfs/etc/calamares"
    cp -a "$HERE/calamares/"* "$dst/airootfs/etc/calamares/" 2>/dev/null || true
  fi
  echo "$dst"
}

build_one() {
  local flavor="$1"
  echo "=== Сборка Falkon OS: $flavor ==="
  local prof
  prof=$(prepare_profile "$flavor")
  rm -rf "$WORK/$flavor"
  mkdir -p "$OUT" "$WORK/$flavor"
  mkarchiso -v -w "$WORK/$flavor" -o "$OUT" "$prof"
  echo "Готово: $OUT/falkon-$flavor-*.iso"
}

need_root
install_deps

if [[ "$FLAVOR" == "all" ]]; then
  build_one desktop
  build_one tiling
  build_one core
else
  build_one "$FLAVOR"
fi
