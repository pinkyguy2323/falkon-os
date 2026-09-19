# Falkon OS 1.6 — одна система, три оформления

Дистрибутив на базе **Arch Linux**. Один ISO, одна установка — а лицо системы меняется одной командой. 100% совместимость с Arch (pacman, AUR, yay, Wiki).

## Главная фишка
**ОДНА система вместо трёх.** Больше нет отдельных редакций — при установке выбираешь оформление, а сменить его можно когда угодно без переустановки:
```bash
sudo falkon-look kde    # Классика: KDE Plasma
sudo falkon-look hypr   # Тайлинг: Hyprland как Omarchy
sudo falkon-look cmd    # Чистая консоль, ~300 МБ RAM
falkon-look gui         # окно выбора
```

| Оформление | Что это | RAM | Тем |
|---|---|---|---|
| **Классика (KDE)** | Оконный стол Plasma, «чтобы просто работало» | ~800 МБ | **25 своих** |
| **Тайлинг (Hyprland)** | Всё с клавиатуры, Waybar, Wofi | ~600 МБ | **25 своих** |
| **Консоль (CMD)** | Только CLI: nvim, tmux, yazi, mpv. Тем нет — там нечего красить | ~300 МБ | — |

**Удобство как раньше:** драйверы ставятся сами (`falkon-drivers`), установка в пару кликов (`falkon-install-easy` с выбором диска и детектом Windows), обновления с GitHub (`falkon-update`).
**Предустановлено:** ghostty + vscode + firefox + lutris + файловый менеджер (dolphin/thunar) + mpv + AI Claude Code и Codex. Тяжёлое (офис, gimp, vlc, discord, telegram, steam, obs) ставится в 1 клик через `falkon-welcome` — иначе ISO не влез бы в лимит релиза 2 ГБ.

## Установка — пошаговый гайд

### Шаг 0. Скачай ISO
Вкладка **Releases** → один файл `falkon-*.iso`. Проверка: `sha256sum falkon-*.iso`.

### Шаг 1а. Виртуалка (Windows не тронута)
VirtualBox: Arch 64-bit, 4 ГБ RAM, 2 ядра, видео 128 МБ + 3D, **EFI вкл**. VMware: Linux 6.x 64-bit, EFI. Драйверы гостевых систем уже внутри.

### Шаг 1б. Настоящий ПК
Ventoy / Rufus / balenaEtcher → загрузись с флешки (UEFI и BIOS поддерживаются).

### Шаг 2. Запусти «Установить Falkon»
Иконка на рабочем столе или `sudo falkon-install-easy`.

### Шаг 3. Ответь на вопросы
1. **Диск** — размер, модель, что сейчас на нём. Флешка с Live скрыта.
2. **Нашлась Windows?** Покажет что именно и спросит «очистить ВЕСЬ диск?» дважды. Без «да» ничего не трёт.
3. **Пользователь, пароль, оформление (KDE/Hypr/консоль), язык.** Дальше ~10 минут: система **копируется с ISO** почти без интернета (сеть нужна только для yay и AI-ассистентов в конце).

### Шаг 4. Первый вход
Вытащи флешку, перезагрузись. Откроется Falkon Welcome: зеркала, драйверы, темы, офис в 1 клик.

## После установки

**Tiling, горячие клавиши:**

| Клавиши | Действие |
|---|---|
| `Super+Enter` | Терминал Ghostty |
| `Super+D` | Меню |
| `Super+W` / `Super+Shift+W` | Следующие обои / выбор |
| `Super+T` | Кастомизация |
| `Super+Q` | Закрыть окно |
| `Alt+Shift` | Язык ввода |

**Команды:**
```bash
sudo falkon-look hypr      # сменить оформление (kde/hypr/cmd)
falkon-themes apply "Neon Nights"  # тема своего оформления (25 штук)
falkon-customizer          # темы + blur, зазоры, скругления, пресеты
falkon-wallpaper next      # следующие обои
falkon-lang                # язык из 12
sudo falkon-update         # обновление с GitHub (применится после перезагрузки)
falkon-welcome             # центр: зеркала, драйверы, офис, Flatpak
```

## Частые вопросы

**Это одна система правда? Переключение без переустановки?**
Да. Оба стека (KDE + Hyprland) ставятся сразу. `falkon-look` меняет сессию SDDM или гасит графику — за секунды.

**Потянет ли 2 ГБ?**
Да: оформление «Консоль» ест ~300 МБ. Тайлинг ~600 МБ.

**Windows не сотрётся сама?**
Нет, двойное подтверждение, без «да» ничего не форматируется.

**Где Steam/Telegram/офис?**
Не в ISO (лимит релиза 2 ГБ), а в 1 клик: `falkon-welcome` → «Офис» / «Связь и стримы».

**NVIDIA?**
`sudo falkon-drivers`, перезагрузка. Готово.

## Для разработчиков

```bash
git clone https://github.com/<user>/falkon-os.git && cd falkon-os
sudo ./scripts/build-iso.sh            # один ISO в out/
# Windows: powershell -ExecutionPolicy Bypass -File scripts/build-windows.ps1
# Облако: git tag v1.6; git push origin v1.6  (ISO сам упадёт в Releases)
```

Профиль строится поверх штатного releng — не ломается от обновлений archiso.
```
profiles/falkon/       # единый профиль: метаданные + общий список пакетов
profiles/base-packages.txt
scripts/falkon-look    # переключение kde/hypr/cmd
scripts/falkon-themes  # 25+25 тем (kde.conf/hypr.conf)
scripts/falkon-install-easy  # установщик с выбором оформления
airootfs/              # оверлей: темы, языки, ярлыки, сервис обновлений
.github/workflows/     # автобилд ISO
```

Баги — в Issues, идеи — в Discussions. Лицензия MIT (свои скрипты), база Arch Linux.
