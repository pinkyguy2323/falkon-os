#!/usr/bin/env bash
# Falkon OS - Core edition: только метаданные.
# Сам профиль берётся из штатного releng (см. scripts/build-iso.sh),
# поэтому формат всегда совпадает с версией archiso.
ISO_NAME="falkon-core"
ISO_LABEL="FALKON_CORE_$(date +%Y%m)"
ISO_PUBLISHER="Falkon OS <https://github.com/falkon-os>"
ISO_APPLICATION="Falkon OS Core - minimal console"
ISO_VERSION="$(date +%Y.%m.%d)"
