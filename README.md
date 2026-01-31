# Arch Linux Hyprland Setup Guide

A comprehensive guide for setting up Arch Linux with Hyprland and essential development tools.

## Table of Contents
- [Package Manager](#package-manager)
- [Dotfiles Management](#dotfiles-management)
- [Window Manager & Desktop](#window-manager--desktop)
- [Terminal & Shell](#terminal--shell)
- [Development Tools](#development-tools)
- [System Utilities](#system-utilities)
- [Theming](#theming)
- [Hardware Control](#hardware-control)
- [Network Management](#network-management)
- [Custom Scripts](#custom-scripts)

---

## Dotfiles Management

### Chezmoi (Dotfiles Manager)

Chezmoi is a dotfile manager that helps you manage your configuration files across multiple machines.

#### Install Chezmoi
```sh
yay -S chezmoi
```

#### Initialize with Your Dotfiles Repository
```sh
# Clone and apply dotfiles in one command
chezmoi init --apply https://github.com/aryan-79/dotfiles.git
```

#### Common Chezmoi Commands

**Check what would change:**
```sh
chezmoi diff
```

**Apply the latest changes from your repository:**
```sh
chezmoi update
```

**Add a new config file to chezmoi:**
```sh
# Add a file to be managed by chezmoi
chezmoi add ~/.config/hypr/hyprland.conf

# Edit the file with chezmoi's editor
chezmoi edit ~/.config/hypr/hyprland.conf
```

**Re-add an existing config file (update it in chezmoi):**
```sh
# If you've modified a file locally and want to update it in chezmoi
chezmoi re-add ~/.config/hypr/hyprland.conf
```

**Apply changes to your system:**
```sh
# Apply all changes
chezmoi apply

# Apply changes verbosely to see what's happening
chezmoi apply -v
```

**Push changes to your repository:**
```sh
# Navigate to chezmoi source directory
chezmoi cd

# Use git commands to commit and push
git add .
git commit -m "Update config"
git push

# Return to previous directory
exit
```

**Quick workflow for updating dotfiles:**
```sh
# 1. Re-add modified files
chezmoi re-add ~/.config/waybar/config.jsonc

# 2. Navigate to source directory and commit
chezmoi cd
git add .
git commit -m "Update waybar config"
git push
exit
```

> **Note:** After the initial setup, use `chezmoi update` to pull and apply the latest changes from your repository on other machines.

---

## Package Manager

### Install yay (AUR Helper)
```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

---

## Window Manager & Desktop

### Hyprland Ecosystem
```sh
yay -S hypridle hyprlock hyprpaper hyprshot
```

### Walker (Application Launcher)
```sh
yay -S walker-bin
```

The above command should install its dependencies like elephant and other providers. If it doesn't use the command below:

```sh
yay -S elephant-bin elephant-desktopapplications-bin elephant-calc-bin \
  elephant-runner-bin elephant-files-bin elephant-clipboard-bin \
  elephant-websearch-bin
```

### Waybar (Status Bar)
```sh
yay -S waybar
```

### SwayNC (Notification Daemon)
```sh
yay -S swaync
```

---

## Terminal & Shell

### Ghostty Terminal
```sh
yay -S ghostty
```

#### Ghostty Configuration
Create `~/.config/ghostty/config`:
```conf
background-opacity=0.8
font-family="JetBrains Mono"
```

### Tmux
```sh
yay -S tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
```
> **Note:** Install plugins with `prefix + I`

### Zsh & Oh My Zsh
```sh
# Install Oh My Zsh
sh -c "$(curl -fsSL https://install.ohmyz.sh)"

# Install plugins
git clone https://github.com/zsh-users/zsh-history-substring-search \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```

#### Configure Plugins
Edit `~/.zshrc` and update the plugins section:
```sh
plugins=(
    sudo
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)
```

---

## Development Tools

### Neovim
```sh
yay -S nvim
```

#### LSP Servers, Formatters, and Linters
- `typescript-language-server`
- `tailwindcss-language-server`
- `css-lsp`
- `marksman`
- `rust-analyzer`

> **Note:** After installing LazyVim, optionally install `biome` with Mason for global formatting and linting.

### Node.js (via NVM)
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

### Git Configuration
```sh
git config --global init.defaultBranch main
git config --global user.email "aryanmgr79@gmail.com"
git config --global user.name "aryan"
git config --global pull.rebase true
```

### LazyGit
```sh
yay -S lazygit
```

### Docker
```sh
yay -S docker docker-compose docker-buildx
sudo systemctl enable docker.service
sudo systemctl start docker.service
```

#### Enable Non-Root Docker Access
```sh
sudo groupadd docker
sudo usermod -aG docker $USER
```
> **Note:** Reboot after running these commands.

---

## System Utilities

### Clipboard & Emoji
```sh
yay -S cliphist wofi-emoji noto-fonts-emoji
```

### Audio Control
```sh
yay -S pavucontrol
```

### Bluetooth
```sh
yay -S bluez bluez-utils blueberry
sudo systemctl enable --now bluetooth
```

#### Configure Bluetooth (CLI)
```sh
bluetoothctl
> power on
> agent on
> default-agent
> scan on
```

---

## Theming

### Fonts
#### Option 1: Manual Installation
1. Download [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
2. Unzip to `/usr/share/fonts`
3. Run font cache:
```sh
fc-cache -fv
fc-list  # Verify installation
```

#### Option 2: Package Installation
```sh
yay -S nerd-fonts  # Select JetBrains Mono Nerd Font
```

### GTK Theme
```sh
# Install theme manager and dependencies
yay -S nwg-look gtk-engine-murrine

# Install Tokyo Night theme
yay -S tokyonight-gtk-theme-git
```
> **Alternative:** [Tokyo Night GTK Theme GitHub](https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme)

### Cursor Theme
```sh
yay -S bibata-cursor-theme-bin
```

### SDDM Login Manager Theme
Follow the [simple-sddm](https://github.com/JaKooLit/simple-sddm) guide.

#### Dependencies
```sh
yay -S qt5-quickcontrols2 qt5-graphicaleffects
```

### Dynamic Theming with Wallust

[Wallust](https://codeberg.org/explosion-mental/wallust) generates color schemes from your wallpaper and applies them across your entire desktop environment.

#### Install Wallust
```sh
yay -S wallust
```

#### Generate Colors from an Image
```sh
wallust run ~/path/to/image
```

#### Test Colors Without Applying
```sh
wallust run ~/path/to/image -s -T
```
> **Flags:** `-s` skips setting terminal colors, `-T` skips the templating sequence

#### Configuration
Wallust is configured in `~/.config/wallust/wallust.toml`. The current setup generates colors for:
- **Waybar** - Status bar colors (`~/.config/waybar/colors.css`)
- **Ghostty** - Terminal theme (`~/.config/ghostty/themes/custom.conf`)
- **Hyprland** - Window border and UI colors (`~/.config/hypr/modules/colors.conf`)
- **Walker** - Application launcher theme (`~/.config/walker/themes/default/style.css`)

> **Tip:** Use the [`set-wallpaper`](#set-wallpapersh) script for a convenient one-command workflow.

---

## Hardware Control

### ASUSctl (ASUS Laptop Control)
```sh
# Add repository signing key
sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
```
> **Important:** Use `pacman` for installation, not `yay` or other AUR helpers.  
> **Reference:** [ASUSctl Installation Guide](https://asus-linux.org/guides/arch-guide/)

---

## Network Management

### Impala WiFi Manager

#### Enable NetworkManager and iwd
```sh
sudo systemctl enable --now NetworkManager iwd
```

#### Configure iwd as NetworkManager Backend
Edit `/etc/NetworkManager/NetworkManager.conf`:
```conf
[device]
wifi.backend=iwd
```

---

## Custom Scripts

Custom scripts are located in the `~/scripts/` directory and can be symlinked to `/usr/local/bin/` for system-wide access.

### Installation
```sh
sudo ln -s ~/scripts/personal.sh /usr/local/bin/pp
sudo ln -s ~/scripts/set-wallpaper.sh /usr/local/bin/set-wallpaper
```

### `personal.sh`
A tmux session manager for development workflows. Creates a "work" session with four windows:
| Window | Name | Purpose |
|--------|------|---------|
| 1 | `frontend` | Frontend code editing |
| 2 | `frontend-server` | Frontend development server |
| 3 | `backend` | Backend code editing |
| 4 | `backend-server` | Backend development server |

**Usage:**
```sh
pp
```

### `set-wallpaper.sh`
An automated wallpaper and theming script that:
1. Copies the specified image to `~/.config/hypr/wallpaper/active.<ext>`
2. Sends a desktop notification confirming the change
3. Runs [`wallust`](#dynamic-theming-with-wallust) to generate colors from the image
4. Reloads Hyprpaper to display the new wallpaper
5. Restarts Waybar to apply new colors

**Usage:**
```sh
set-wallpaper ~/path/to/image.jpg
```

> **Note:** The script cleans up old `active.*` files to prevent conflicts between different image formats.

## Additional Notes

- Always review package dependencies before installation
- Keep your system updated regularly with `yay -Syu`
- Back up configuration files before making changes
- Consult the [Arch Wiki](https://wiki.archlinux.org/) for detailed documentation
