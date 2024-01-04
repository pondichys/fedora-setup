#! /usr/bin/env bash

# Some variables
RPMFUSIONCOMP="rpmfusion-free-appstream-data rpmfusion-nonfree-appstream-data rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted"

# Functions
check_pkg() {
    dnf list installed "$1" 2> /dev/null
}

# CONFIGURATION
echo "DNF configuration"
if [ ! $(grep -ic 'fastestmirror=' /etc/dnf/dnf.conf) ]; then
    echo -n "Use fastest DNF mirrors"
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
fi

if [ ! $(grep -ic 'max_parallel_dowwnloads=' /etc/dnf/dnf.conf) ]; then
    echo -n "Use 10 parallel download streams"
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
fi

mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share/{fonts,icons,themes}

echo "Enable RPM Fusion repositories"
if ! check_pkg rpmfusion-free-release; then
    sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
fi

if ! check_pkg rpmfusion-nonfree-release; then
    sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
fi

# PACKAGES
echo "Install Z shell"
sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting

echo "Install base software"
sudo dnf install -y bat curl dnf-utils fd-find fzf gh git git-delta jq lsd meld neovim ripgrep stow tealdeer tmux zoxide

echo "Install distrobox"
sudo dnf install -y distrobox

echo "Install podman complementary packages"
sudo dnf install -y podman-compose podman-docker

echo "Install gnome-shell extensions"
sudo dnf install -y gnome-shell-extension-appindicator gnome-shell-extension-blur-my-shell

# FLATPAKS
echo "Configure Flathub if needed ..."
if [ ! $(flatpak remotes | grep -c flathub) ]; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null
fi

echo "Installing flatpaks"
flatpak install flathub --noninteractive -y "com.mattjakeman.ExtensionManager"
flatpak install flathub --noninteractive -y "com.usebottles.bottles"
flatpak install flathub --noninteractive -y "com.valvesoftware.Steam"
flatpak install flathub --noninteractive -y "io.github.dvlv.boxbuddyrs"  # GUI for distrobox management
flatpak install flathub --noninteractive -y "com.github.tchx84.Flatseal"
flatpak install flathub --noninteractive -y "com.discordapp.Discord"
flatpak install flathub --noninteractive -y "md.obsidian.Obsidian"
flatpak install flathub --noninteractive -y "org.mozilla.Thunderbird"
# flatpak install flathub --noninteractive -y "org.onlyoffice.desktopeditors"
flatpak install flathub --noninteractive -y "org.gnome.World.PikaBackup"
flatpak install flathub --noninteractive -y "com.bitwarden.desktop"

echo "Install starship command prompt in $HOME/.local/bin"
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $HOME/.local/bin

# CLEANUP
echo "Remove some unwanted/unneeded applications"
# echo "Uninstall LibreOffice ..."
# sudo dnf group remove -y @LibreOffice
# sudo dnf remove -y libreoffice*
echo "Uninstall Rhythmbox"
sudo dnf remove -y rhythmbox
