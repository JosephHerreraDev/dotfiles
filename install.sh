#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/JosephHerreraDev/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# --- 0. Clone if missing ---
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "[0/8] Cloning dotfiles repository..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# --- 1. Base packages ---
echo "[1/8] Installing base packages..."
sudo pacman -Syu --noconfirm \
  man-db nvim git base-devel ttf-cascadia-code-nerd \
  spotify-launcher rofi starship swaync tmux waybar \
  zathura zathura-pdf-poppler hyprpaper hyprlock yazi lazygit stow

echo "[1/8] Ensuring base tools are installed..."
sudo pacman -Syu --noconfirm git base-devel stow

echo "[2/8] Installing yay..."
if ! command -v yay &> /dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
fi

echo "[3/8] Installing SDDM silent theme..."
yay -S --noconfirm sddm-silent-theme
sudo tee /etc/sddm.conf > /dev/null <<EOF
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
EOF

echo "[4/8] Installing Brave..."
yay -Sy --noconfirm brave-bin

echo "[5/8] Setting up wallpapers..."
mkdir -p ~/Pictures
cd ~/Pictures
if [ ! -d "wallpapers" ]; then
  git clone https://github.com/JosephHerreraDev/wallpapers.git
fi
yay -S --noconfirm waypaper

echo "[6/8] Installing and configuring Spicetify..."
yay -S --noconfirm spicetify-cli spicetify-themes-git
spicetify
spicetify backup apply enable-devtools
spicetify config current_theme Sleek
spicetify config color_scheme Nord
spicetify apply


echo "[7/8] Installing Hyprshot..."
yay -S --noconfirm hyprshot

echo "[8/8] Linking dotfiles..."
cd "$DOTFILES_DIR"
for dir in */; do
  if [ "$dir" != "yay/" ] && [ "$dir" != ".git/" ]; then
    stow -v --target="$HOME" "$dir" || true
  fi
done

echo "Setup complete. Dotfiles installed and linked."
