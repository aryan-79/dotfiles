#!/usr/bin/env bash
#
# Arch Linux + Hyprland bootstrap
# Companion script for https://github.com/aryan-79/dotfiles (chezmoi source dir)
#
# Usage: ./setup.sh
# Safe to re-run: steps are guarded so a second run won't fail on
# "already exists" errors.

set -euo pipefail

log() { printf '\n\033[1;32m==>\033[0m %s\n' "$1"; }

# root guard + sudo keepalive
[ "$EUID" -ne 0 ] || {
  echo "Run as your user, not root"
  exit 1
}
sudo -v
(while kill -0 "$$" 2>/dev/null; do
  sudo -n true
  sleep 50
done) &

# ---------------------------------------------------------------------------
# 0. Full system update first (avoid partial-upgrade issues with new pkgs)
# ---------------------------------------------------------------------------
log "Syncing and updating system"
sudo pacman -Syu --noconfirm

# ---------------------------------------------------------------------------
# 1. yay (AUR helper)
# ---------------------------------------------------------------------------
if ! command -v yay >/dev/null 2>&1; then
  log "Installing yay"
  sudo pacman -S --needed --noconfirm git base-devel
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
else
  log "yay already installed, skipping"
fi

# ---------------------------------------------------------------------------
# 2. Chezmoi + dotfiles (do this early so configs exist before apps that
#    read them, e.g. hyprland.lua, quickshell, ghostty, tmux, zsh, nvim)
# ---------------------------------------------------------------------------
log "Installing chezmoi and applying dotfiles"
yay -S --needed --noconfirm chezmoi
chezmoi init --apply https://github.com/aryan-79/dotfiles.git

# ---------------------------------------------------------------------------
# 3. Hyprland ecosystem + desktop utilities
# ---------------------------------------------------------------------------
log "Installing Hyprland ecosystem"
yay -S --needed --noconfirm \
  hypridle hyprlock hyprpaper hyprshot hyprpolkitagent \
  walker-bin quickshell dunst ghostty wl-clipboard

# ---------------------------------------------------------------------------
# 4. Zsh + Oh My Zsh + plugins
#    (dot_zshrc from the dotfiles repo already lists these plugins, so
#    just make sure the plugin source is present)
# ---------------------------------------------------------------------------
log "Installing zsh"
yay -S --needed --noconfirm zsh

if [ "$SHELL" != "$(command -v zsh)" ]; then
  log "Setting zsh as default shell"
  sudo chsh -s "$(command -v zsh)" "$USER"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://install.ohmyz.sh)"
else
  log "Oh My Zsh already installed, skipping"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A ZSH_PLUGINS=(
  ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  ["zsh-completions"]="https://github.com/zsh-users/zsh-completions.git"
)
log "Installing zsh plugins"
for name in "${!ZSH_PLUGINS[@]}"; do
  dest="$ZSH_CUSTOM/plugins/$name"
  if [ ! -d "$dest" ]; then
    git clone --depth 1 "${ZSH_PLUGINS[$name]}" "$dest"
  else
    echo "  - $name already present, skipping"
  fi
done

# ---------------------------------------------------------------------------
# 5. Dev tooling
#    fzf, zoxide, and yazi are required by dot_tmux.conf / dot_zshrc from
#    the dotfiles repo (fzf session/window popups, zoxide init, M-y yazi popup)
# ---------------------------------------------------------------------------
log "Installing dev tools"
yay -S --needed --noconfirm \
  tmux neovim lazygit fzf zoxide yazi \
  docker docker-compose docker-buildx

sudo systemctl enable --now docker.service
sudo usermod -aG docker "$USER"
echo "  (log out/in, or 'newgrp docker', for the docker group to take effect)"

# tmux plugin manager, required by the last line of dot_tmux.conf
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Installing tmux plugin manager (tpm)"
  git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
log "Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

# Node via nvm (PROFILE=/dev/null stops the installer editing your chezmoi-managed .zshrc)
if [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash
fi

log "Installing latest Node"
export NVM_DIR="$HOME/.nvm"
set +u
. "$NVM_DIR/nvm.sh"
nvm install node
nvm alias default node
set -u

# ---------------------------------------------------------------------------
# 6. Fonts, clipboard, notifications, audio
#    (dunst/set-wallpaper.sh use notify-send -> libnotify)
# ---------------------------------------------------------------------------
log "Installing fonts and system utilities"
yay -S --needed --noconfirm \
  cliphist noto-fonts-emoji maple-mono-nf-cn-unhinted \
  pavucontrol libnotify

# ---------------------------------------------------------------------------
# 7a. Bluetooth
# ---------------------------------------------------------------------------
log "Setting up Bluetooth"
yay -S --needed --noconfirm bluez bluez-utils blueberry
sudo systemctl enable --now bluetooth

# ---------------------------------------------------------------------------
# 7b. Power & brightness
# ---------------------------------------------------------------------------
log "Setting up power management and brightness"
yay -S --needed --noconfirm upower power-profiles-daemon brightnessctl
sudo systemctl enable --now upower power-profiles-daemon

# ---------------------------------------------------------------------------
# 8. Theming
# ---------------------------------------------------------------------------
log "Installing theming tools"
yay -S --needed --noconfirm nwg-look gtk-engine-murrine tokyonight-gtk-theme-git
yay -S --needed --noconfirm bibata-cursor-theme-bin

if ! command -v wallust >/dev/null 2>&1; then
  log "Installing wallust"
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/wallust.git "$tmpdir/wallust"
  (cd "$tmpdir/wallust" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
else
  log "wallust already installed, skipping"
fi

# SDDM login theme (Qt6 - see https://github.com/JaKooLit/simple-sddm-2)
# NOTE: the repo's own theme.conf/README expect the installed folder to be
# named "simple_sddm_2" (underscores), even though the git repo is
# "simple-sddm-2" (hyphens) - it must be renamed on install.
if [ ! -d /usr/share/sddm/themes/simple_sddm_2 ]; then
  log "Installing SDDM theme (simple_sddm_2)"
  yay -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
  tmpdir=$(mktemp -d)
  git clone --depth 1 https://github.com/JaKooLit/simple-sddm-2.git "$tmpdir/simple_sddm_2"
  sudo mv "$tmpdir/simple_sddm_2" /usr/share/sddm/themes/simple_sddm_2
  rm -rf "$tmpdir"
  sudo mkdir -p /etc/sddm.conf.d
  sudo sh -c "printf '[Theme]\nCurrent=simple_sddm_2\n\n[General]\nInputMethod=qtvirtualkeyboard\n' > /etc/sddm.conf.d/10-theme.conf"
else
  log "SDDM theme already installed, skipping"
fi
sudo systemctl enable sddm.service

# ---------------------------------------------------------------------------
# 9. Networking (impala + iwd backend)
#    networkmanager and iwd come from archinstall
# ---------------------------------------------------------------------------
log "Setting up networking"
yay -S --needed --noconfirm impala
sudo mkdir -p /etc/NetworkManager/conf.d
printf '[device]\nwifi.backend=iwd\n' | sudo tee /etc/NetworkManager/conf.d/wifi-backend.conf >/dev/null
sudo systemctl enable --now iwd NetworkManager
echo "  (restart NetworkManager or reboot for the iwd backend change to apply)"

log "Done. Reboot to apply the docker group, iwd backend, and SDDM changes."
