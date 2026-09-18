#!/usr/bin/env bash
# Falkon OS - Desktop edition: только метаданные.
# Сам профиль берётся из штатного releng (см. scripts/build-iso.sh),
# поэтому формат всегда совпадает с версией archiso.
ISO_NAME="falkon-desktop"
ISO_LABEL="FALKON_DESKTOP_$(date +%Y%m)"
ISO_PUBLISHER="Falkon OS <https://github.com/falkon-os>"
ISO_APPLICATION="Falkon OS Desktop - Arch-based, KDE Plasma"
ISO_VERSION="$(date +%Y.%m.%d)"
