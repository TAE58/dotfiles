#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}
backup_suffix="backup.$(date +%Y%m%d%H%M%S)"

if ! command -v omarchy >/dev/null 2>&1; then
  echo "This setup script requires Omarchy." >&2
  exit 1
fi

omarchy pkg add fcitx5 fcitx5-hangul fcitx5-configtool

link_config() {
  local source=$1
  local target=$2

  mkdir -p -- "$(dirname -- "$target")"

  if [[ -L "$target" && $(readlink -f -- "$target") == $(readlink -f -- "$source") ]]; then
    echo "Already linked: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mv -- "$target" "$target.$backup_suffix"
    echo "Backed up: $target.$backup_suffix"
  fi

  ln -s -- "$source" "$target"
  echo "Linked: $target -> $source"
}

link_config "$dotfiles_dir/.config/fcitx5/config" "$config_dir/fcitx5/config"
link_config "$dotfiles_dir/.config/fcitx5/profile" "$config_dir/fcitx5/profile"
link_config "$dotfiles_dir/.config/fcitx5/conf/hangul.conf" "$config_dir/fcitx5/conf/hangul.conf"
link_config "$dotfiles_dir/.config/typora-flags.conf" "$config_dir/typora-flags.conf"

hypr_input="$config_dir/hypr/input.lua"
korean_marker="-- dotfiles: Korean input"

if [[ ! -f "$hypr_input" ]]; then
  echo "Missing Omarchy Hyprland config: $hypr_input" >&2
  exit 1
fi

if ! grep -Fq -- "$korean_marker" "$hypr_input" &&
  ! grep -Eq '^[[:space:]]*kb_options[[:space:]]*=.*korean:ralt_hangul' "$hypr_input"; then
  cp -- "$hypr_input" "$hypr_input.$backup_suffix"
  printf '\n%s\n' "$korean_marker" >> "$hypr_input"
  printf '%s\n' 'hl.config({' '  input = {' '    kb_options = "compose:caps,shift:both_capslock_cancel,korean:ralt_hangul",' '  },' '})' >> "$hypr_input"
  echo "Enabled the right Alt key as Hangul in: $hypr_input"
else
  echo "Korean keyboard option already present: $hypr_input"
fi

hyprctl reload
if config_errors=$(hyprctl configerrors) && [[ -z "$config_errors" ]]; then
  echo "Hyprland configuration is valid."
else
  echo "Hyprland configuration errors:" >&2
  printf '%s\n' "$config_errors" >&2
  exit 1
fi

echo
echo "Korean input setup is complete. Log out and back in before testing it."
