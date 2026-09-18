# Falkon OS 1.0 "Swift" — Arch-based, удобно, быстро, твоё

Собственный дистрибутив на базе **Arch Linux**. 100% совместимость с Arch (pacman, AUR, yay, Wiki).

## Главная фишка
**Удобство:** драйверы ставятся сами (`falkon-drivers`), установка с графическим интерфейсом (Calamares), ОЧЕНЬ КРУТАЯ кастомизация (`falkon-customizer` + 45 тем + `falkon-themes`).
**Предустановлено:** ghostty + vscode + firefox + steam + файловый менеджер (dolphin/thunar) + discord/telegram + obs/gimp/libreoffice.

## 3 редакции

| Редакция | Что это | RAM в простое | Для кого |
|---|---|---|---|
| **Desktop** | Классический оконный стол (KDE Plasma + SDDM) | ~700-900 МБ | Все, кто хочет "просто работает" |
| **Tiling** | Как Omarchy OS: Hyprland + Waybar + Wofi, тайлинг, всё с клавиатуры | ~500-700 МБ | Прогеры, любители кастома |
| **Core** | Чистая консоль, только базовые CLI (nvim, tmux, yazi, mpv, links). Без X/Wayland | **~250-400 МБ** (на 2 ГБ летает) | Серверы, слабые ПК, минималисты |

Переключение: Core -> Desktop в любой момент одной командой:
```bash
sudo pacman -S plasma-desktop sddm && sudo systemctl enable sddm
# или tiling:
sudo pacman -S hyprland kitty waybar wofi
```

## Быстрый старт (сборка ISO)

Собирать **только на Arch Linux** (или в Docker `archlinux:latest`):

```bash
git clone <этот-репо> && cd falkon-os
chmod +x scripts/*.sh scripts/falkon-*
sudo ./scripts/build-iso.sh desktop  # или tiling / core / all
# ISO появится в out/
```

Запись на флешку:
```bash
sudo dd bs=4M if=out/falkon-desktop-*.iso of=/dev/sdX status=progress oflag=sync
# или Ventoy / Balena Etcher
```

## Установка

1. Загрузись с флешки (UEFI + BIOS поддерживаются).
2. **Desktop / Tiling:** открой Calamares (иконка Install), выбери язык/диск/пользователя. Драйверы и твики применятся сами в конце.
3. **Core:** `sudo falkon-install` — ответь на 4 вопроса, всё остальное само.

## Что внутри

- Ядро `linux-zen` + `zram` (zstd) + `swappiness=180` — отзывчиво даже на 2 ГБ.
- `pacman`: ParallelDownloads=5, Color, multilib включён.
- `yay-bin` из коробки, опционально Chaotic-AUR и Flatpak через `falkon-welcome`.
- `reflector` для быстрых зеркал, `firewalld` + `apparmor`, `fstrim.timer` для SSD.
- AUR/Arch Wiki работают 1:1 — это всё ещё Arch.

```
falkon-os/
  profiles/desktop/  # KDE, оконный
  profiles/tiling/   # Hyprland как Omarchy
  profiles/core/     # консоль
  profiles/base-packages.txt
  profiles/pacman.conf
  scripts/build-iso.sh
  scripts/falkon-drivers  # авто-драйверы: NVIDIA/AMD/Intel/Broadcom/Realtek/принтеры/ВМ
  scripts/falkon-tweaks   # производительность
  scripts/falkon-welcome  # GUI/TUI центр кастомизации
  scripts/falkon-install  # консольный установщик
  calamares/              # графический установщик
  airootfs/               # оверлей live-системы (Hyprland-конфиг, motd, bashrc)
```

## Команды после установки

```bash
falkon-welcome      # кастомизация: зеркала, темы, Chaotic, Flatpak
sudo falkon-drivers # пересканировать железо (напр. после смены GPU)
sudo falkon-tweaks  # применить perf-твики заново
fastfetch           # проверить систему
```

## Как получить исошник

**Вариант А — скачать готовый (рекомендую):**
1. Открой страницу репозитория на GitHub → вкладка `Releases`
2. Скачай `falkon-desktop-*.iso` (или tiling/core)
3. Проверь: `sha256sum *.iso`, запиши на флешку через Ventoy/Rufus/balenaEtcher

**Вариант Б — собрать самому:**
- На Arch: `sudo ./scripts/build-iso.sh all` → ISO в `out/`
- На Windows: `powershell -ExecutionPolicy Bypass -File scripts/build-windows.ps1 desktop` (нужен Docker Desktop)

> ISO в git НЕ коммитится (весит ~2 ГБ, GitHub режет файлы >100 МБ). ISO живёт только в `Releases`, исходники — в репо. Так делают все любительские дистры.

## Как выложить на GitHub как любительский проект

```powershell
# 1. Поставь git и gh: winget install Git.Git GitHub.cli
# 2. Залогинься: gh auth login
# 3. Из папки falkon-os:
powershell -ExecutionPolicy Bypass -File scripts/publish-github.ps1
# скрипт сам сделает git init, коммит и gh repo create + push
```

Дальше для красоты:
- Добавь описание + топики `arch-linux distro hyprland kde` в About репозитория
- Включи Issues + Discussions (любительские проекты так живут)
- Первый релиз: `git tag v1.0; git push origin v1.0` → GitHub Actions сам соберёт ISO (~20 мин) и прикрепит к Releases. Файл: `.github/workflows/build-iso.yml:1`
- Скриншоты кинь в `screenshots/` и покажи в README — скачиваний будет в разы больше

## Совместимость с Arch

Ничего не ломаем: нет своих репозиториев по умолчанию, нет форков пакетов. Любой гайд с Arch Wiki работает. Кастомизации (темы, dotfiles) с Arch встают 1:1.

## Дорожная карта

- [ ] Свой репозиторий `falkon` (пока пакеты лежат локально в скриптах)
- [ ] Secure Boot (shim)
- [ ] Оffline NVIDIA ISO
- [ ] Falkon Store (GUI над pacman+flatpak+AUR)

Лицензия: MIT (свои скрипты). База: Arch Linux (пакеты — под своими лицензиями).
