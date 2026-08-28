# dotfiles

Personal configuration files for Omarchy.

## Korean input

On a fresh Omarchy installation, clone this repository and run:

```bash
./setup-korean.sh
```

The script installs Fcitx5 with Hangul and its configuration tool, selects the
Dubeolsik layout, maps right Alt to the Hangul key, shares the input state
between applications, and enables Wayland IME support in Typora. Existing
configuration files are backed up before they are linked. Log out and back in
after setup.

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
