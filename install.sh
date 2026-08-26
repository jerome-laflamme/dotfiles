#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- CONFIGURATION VARIABLES ---
DOTFILES_REPO="git@github.com:YOUR_USERNAME/dotfiles.git"
WALLPAPER_PATH="$HOME/.config/wallpapers"

# 1. UPDATE SYSTEM AND INSTALL PACMAN PACKAGES
echo "Updating pacman and installing base packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    git \
    base-devel \
    feh \
    openssh \
    neovim \
    

# 2. SETUP SSH AND GIT CONFIGURATION
echo "Setting up SSH and Git..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "No SSH key found. Generating a new Ed25519 key..."
    # Replace with your email address
    ssh-keygen -t ed25519 -C "jerome@jlaflamme.com" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    
    echo "========================================================"
    echo "COPY THIS SSH KEY AND ADD IT TO YOUR GITHUB/GITLAB ACCT:"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo "========================================================"
    read -p "Press [Enter] once you have added the key to your Git provider..."
fi

# 3. INSTALL AUR HELPER (YAY)
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    mkdir -p /tmp/yay-build
    git clone https://archlinux.org /tmp/yay-build/yay
    cd /tmp/yay-build/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay-build
fi

# 4. REINSTALL AUR PACKAGES
echo "Installing AUR packages..."
# Add your favorite AUR packages here
yay -S --needed --noconfirm \
		quickshell-git \
		discord \
		helium-browser-bin \
		spotify

# 5. CLONE AND DEPLOY DOTFILES
echo "Cloning dotfiles..."
if [ ! -d "$HOME/.cfg" ]; then
    # Clone as a bare repository or standard repository depending on your preference
    # Standard cloning into a temp directory or straight to .config:
    mkdir -p "$HOME/.config"
    git clone "$DOTFILES_REPO" "$HOME/dotfiles-repo"
    
    # Example using GNU Stow to symlink configuration files into place
    cd "$HOME/dotfiles-repo"
    # Assuming your repo structure has a folder named 'config' containing your apps
    stow -t "$HOME/.config" config 
    cd -
fi

# 6. SETUP WALLPAPER
echo "Setting up wallpaper..."
mkdir -p "$(dirname "$WALLPAPER_PATH")"
curl -Lo "$WALLPAPER_PATH" "$WALLPAPER_URL"

# Set wallpaper (Use 'feh' for X11 or adapt to 'swww' / 'hyprpaper' for Wayland)
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "Wayland detected. Please ensure you have a Wayland wallpaper utility installed."
else
    swww --bg-fill "$WALLPAPER_PATH"
    # Save to .fehbg for persistence across reboots
    echo "feh --bg-fill '$WALLPAPER_PATH'" > "$HOME/.fehbg"
    chmod +x "$HOME/.fehbg"
fi

echo "🎉 Script execution finished successfully!"

