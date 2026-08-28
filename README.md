# dotfiles

Personal configuration files for Omarchy.

## Spotify

The Spotify flags enable native Wayland rendering and include the `-no-zygote`
compatibility option required on this ThinkPad T14 Gen 1.

```bash
ln -s "$HOME/dotfiles/.config/spotify-flags.conf" "$HOME/.config/spotify-flags.conf"
```

## Typora

The Typora flag enables native Wayland input-method support, which is required
for Korean input with Fcitx5.

```bash
ln -s "$HOME/dotfiles/.config/typora-flags.conf" "$HOME/.config/typora-flags.conf"
```
