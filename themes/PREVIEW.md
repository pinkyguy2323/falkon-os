# Falkon OS - одна система, три оформления, 25+25 тем

```
falkon-os/
  profiles/falkon/    # ЕДИНЫЙ профиль: один ISO на всех
  scripts/falkon-look      # sudo falkon-look kde|hypr|cmd - смена лица системы
  scripts/falkon-themes    # движок: 25 тем Классики + 25 тем Тайлинга
  scripts/falkon-customizer
  scripts/falkon-install-easy  # установщик: диск + оформление + язык
  airootfs/usr/share/falkon/themes/kde.conf   # 25 тем Классики
  airootfs/usr/share/falkon/themes/hypr.conf  # 25 тем Тайлинга
```

## Оформления (переключение без переустановки)
- **kde — Классика:** KDE Plasma, 25 тем (Falkon Swift, Dracula, Tokyo Night, ... Glacier, Neon Nights)
- **hypr — Тайлинг:** Hyprland как Omarchy, 25 тем (Midnight Pro, Nord, Mocha, ... Obsidian, Paper)
- **cmd — Консоль:** без графики, тем нет, ~300 МБ RAM

```bash
sudo falkon-look kde
falkon-themes list              # 25 тем текущего оформления
falkon-themes --hypr list       # заглянуть в чужой набор
falkon-themes apply "Neon Nights"
falkon-customizer               # пресеты сами берут тему под оформление
```

## Софт: в ISO лёгкое, тяжёлое в 1 клик
- **В ISO:** ghostty, kitty, vscode (`code`), firefox, lutris, mangohud, mpv, imv, zathura,
  thunar, dolphin + Claude Code и Codex (через npm в установщике).
- **В 1 клик (falkon-welcome):** «Офис и медиа» (libreoffice, thunderbird, krita, gimp, vlc, elisa),
  «Связь и стримы» (discord, telegram, steam, obs). Причина: лимит файла релиза GitHub 2 ГБ.
