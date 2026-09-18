#!/usr/bin/env bash
# Falkon OS - Core edition (чистая консоль, только базовые программы)
# Цель: <500 МБ RAM в простое, установка на 2 ГБ RAM с запасом

iso_name="falkon-core"
iso_label="FALKON_CORE_$(date +%Y%m)"
iso_publisher="Falkon OS <https://github.com/falkon-os>"
iso_application="Falkon OS Core - minimal console"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.grub.esp' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/usr/bin/falkon-drivers"]="0:0:755"
  ["/usr/bin/falkon-tweaks"]="0:0:755"
  ["/usr/bin/falkon-lang"]="0:0:755"
  ["/usr/bin/falkon-install-easy"]="0:0:755"
  ["/usr/bin/falkon-install"]="0:0:755"
)
