#!/usr/bin/env bash
# Falkon OS - сборка ISO (запускать на чистом Arch Linux)
# Использование:
#   sudo ./scripts/build-iso.sh desktop   # классический KDE
#   sudo ./scripts/build-iso.sh tiling    # Hyprland как Omarchy
#   sudo ./scripts/build-iso.sh core      # консоль, <500МБ RAM
#   sudo ./scripts/build-iso.sh all
#
# Профиль строится поверх ШТАТНОГО releng-профиля установленного archiso
# (/usr/share/archiso/configs/releng): загрузчики, syslinux/grub/efiboot и
# имена bootmode всегда совпадают с версией archiso (v90+ их переименовал).
set -euo pipefail

FLAVOR="${1:-falkon}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$HERE/out"
WORK="$HERE/work"
RELENG="/usr/share/archiso/configs/releng"

need_root() {
  if [[ $EUID -ne 0 ]]; then echo "Запусти через sudo"; exit 1; fi
}

install_deps() {
  pacman -Sy --needed --noconfirm archiso git reflector rsync squashfs-tools dosfstools grub syslinux
  # Быстрые зеркала ОБЯЗАТЕЛЬНЫ: на дефолтном mirrorlist качание виснет
  # на мёртвых серверах (симптом: прогресс стоит на ~49% часами).
  echo "[Falkon] Обновляю зеркала (reflector)..."
  reflector --latest 30 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || true
  pacman -Sy || true
}

prepare_profile() {
  local flavor="$1"
  local src="$HERE/profiles/$flavor"
  local dst="/tmp/falkon-build-$flavor"
  [[ -d "$RELENG" ]] || { echo "Нет штатного профиля $RELENG. Поставь archiso."; exit 1; }
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -a "$RELENG/." "$dst/"

  # --- Метаданные редакции (profiles/<flavor>/profiledef.sh задаёт ISO_* переменные) ---
  # shellcheck disable=SC1090
  source "$src/profiledef.sh"
  sed -i "s|^iso_name=.*|iso_name=\"$ISO_NAME\"|" "$dst/profiledef.sh"
  sed -i "s|^iso_label=.*|iso_label=\"$ISO_LABEL\"|" "$dst/profiledef.sh"
  sed -i "s|^iso_publisher=.*|iso_publisher=\"$ISO_PUBLISHER\"|" "$dst/profiledef.sh"
  sed -i "s|^iso_application=.*|iso_application=\"$ISO_APPLICATION\"|" "$dst/profiledef.sh"
  sed -i "s|^iso_version=.*|iso_version=\"$ISO_VERSION\"|" "$dst/profiledef.sh"

  # --- Пакеты: штатные releng + базовые Falkon + редакция ---
  {
    grep -v '^\s*#' "$HERE/profiles/base-packages.txt" | grep -v '^\s*$' || true
    grep -v '^\s*#' "$src/packages.x86_64" | grep -v '^\s*$' || true
  } | sort -u >> "$dst/packages.x86_64"
  cp "$HERE/profiles/pacman.conf" "$dst/pacman.conf"

  # --- Falkon-брендинг загрузчиков: в меню только "Falkon OS", никакого "Arch" ---
  # Трогаем только отображаемый текст; параметры ядра (archisobasedir и т.д.) не трогаем.
  grep -rl "Arch Linux" "$dst/syslinux" "$dst/grub" "$dst/efiboot" 2>/dev/null | xargs -r sed -i 's/Arch Linux/Falkon OS/g'
  grep -rl "Arch Linux" "$dst/syslinux" "$dst/grub" "$dst/efiboot" 2>/dev/null | xargs -r sed -i 's/Arch/Falkon/g'

  # --- airootfs: штатный releng + оверлей Falkon ---
  cp -a "$HERE/airootfs/." "$dst/airootfs/"
  mkdir -p "$dst/airootfs/usr/bin" "$dst/airootfs/usr/share/falkon/themes"
  for t in falkon-drivers falkon-tweaks falkon-welcome falkon-themes falkon-customizer falkon-wallpaper falkon-lang falkon-install falkon-install-easy falkon-update falkon-look; do
    [[ -f "$HERE/scripts/$t" ]] && cp -a "$HERE/scripts/$t" "$dst/airootfs/usr/bin/$t"
  done
  cp -a "$HERE/airootfs/usr/share/falkon/themes/." "$dst/airootfs/usr/share/falkon/themes/" 2>/dev/null || true
  cp -a "$HERE/airootfs/usr/share/falkon/lang.conf" "$dst/airootfs/usr/share/falkon/" 2>/dev/null || true
  # Ярлыки ставятся из airootfs/usr/share/applications (Установить Falkon, Welcome, Темы)

  # --- Штамп версии для falkon-update (тег git, иначе дата) ---
  FVER="$(git -C "$HERE" describe --tags 2>/dev/null || date +%Y.%m.%d)"
  printf 'FALKON_VERSION=%s\nFALKON_EDITION=%s\n' "$FVER" "$flavor" > "$dst/airootfs/etc/falkon-release"

  # --- Права 0755 только для файлов, которые реально есть (mkarchiso строгий) ---
  {
    echo 'file_permissions+=('
    for t in "$dst"/airootfs/usr/bin/falkon-*; do
      echo "  [\"/usr/bin/$(basename "$t")\"]=\"0:0:755\""
    done
    echo ')'
  } >> "$dst/profiledef.sh"

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

# Одна система - один ISO. Старые имена редакций маппим на него.
if [[ "$FLAVOR" == "all" || "$FLAVOR" == "desktop" || "$FLAVOR" == "tiling" || "$FLAVOR" == "core" ]]; then
  FLAVOR="falkon"
fi
build_one "$FLAVOR"
