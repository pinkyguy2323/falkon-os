#!/usr/bin/env bash
# Falkon OS - Tiling edition: только метаданные.
# Сам профиль берётся из штатного releng (см. scripts/build-iso.sh),
# поэтому формат всегда совпадает с версией archiso.
ISO_NAME="falkon-tiling"
ISO_LABEL="FALKON_TILING_$(date +%Y%m)"
ISO_PUBLISHER="Falkon OS <https://github.com/falkon-os>"
ISO_APPLICATION="Falkon OS Tiling - Arch + Hyprland"
ISO_VERSION="$(date +%Y.%m.%d)"
