# Falkon OS - 45 встроенных тем + предустановленный софт

## Где лежит система?
Всё в папке `falkon-os/` рядом с этим файлом:
```
falkon-os/
  profiles/desktop/  # KDE + ghostty + vscode + firefox + lutris + dolphin
  profiles/tiling/   # Hyprland + ghostty + vscode + firefox + lutris + thunar
  profiles/core/     # консоль
  scripts/falkon-themes      # движок 45 тем
  scripts/falkon-customizer  # ОЧЕНЬ КРУТАЯ кастомизация
  airootfs/usr/share/falkon/themes/themes.conf  # база 45 тем
```

## Предустановленный софт (Desktop + Tiling)
- **Терминал:** ghostty (главный) + kitty + konsole/alacritty запасные
- **Код:** vscode (`code`), neovim, kate
- **Браузер:** firefox (+ru), thunderbird
- **Гейминг:** lutris + mangohud + gamemode
- **Файловый менеджер:** dolphin (Desktop) / thunar + yazi (Tiling)
- **Связь:** discord, kdeconnect
- **Медиа:** vlc/elisa/mpv, gimp/krita, libreoffice
- **AI:** Claude Code (`claude`) + Codex (`codex`) — ставятся установщиком через npm
- `falkon-themes apply "Dracula"` — меняет тему везде сразу

## 45 тем (применяются одной командой везде: Hyprland+Ghostty+Kitty+Waybar+GTK)
01 Falkon Swift (фирменная) | 02 Falkon Midnight Pro | 03 Dracula | 04 Nord | 05 Tokyo Night |
06 Catppuccin Mocha | 07 Catppuccin Latte | 08 Macchiato | 09 Frappe | 10 Gruvbox Dark |
11 Gruvbox Light | 12 Everforest Dark | 13 Everforest Light | 14 Rose Pine | 15 Rose Pine Moon |
16 Kanagawa | 17 One Dark | 18 Monokai Pro | 19 Solarized Dark | 20 Solarized Light |
21 Cyberpunk Neon | 22 Matrix | 23 Sunset Glow | 24 Ocean Deep | 25 Forest Mist |
26 Lavender Dream | 27 Crimson Blood | 28 Arctic Ice | 29 Volcano | 30 Midnight City |
31 Candy Pop | 32 Coffee Bean | 33 Mint Fresh | 34 Grape Soda | 35 Blood Moon |
36 Sakura | 37 Slate Gray | 38 Emerald City | 39 Amethyst | 40 Inferno |
41 Ghost White | 42 Storm | 43 Aurora | 44 Nebula | 45 Desert Sand

```bash
falkon-themes list
falkon-themes apply "Tokyo Night"
falkon-themes random
falkon-customizer   # GUI: темы + blur + gaps + rounding + waybar top/bottom + терминал + пресеты
```

## Пресеты кастомизации
- Минимализм, Киберпанк, macOS-like, Omarchy-like, Windows-like
- Ручное: gaps 0-40, rounding 0-25, blur on/off, анимации, waybar top/bottom, терминал ghostty/kitty/konsole, шрифты Inter/JetBrainsMono, иконки Papirus, курсор Adwaita
