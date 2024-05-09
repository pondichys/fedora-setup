#! /usr/bin/env bash

# Some variables
# List of nerd fonts to download
nf_list=(FiraCode,Hack,Meslo)

# Functions
check_pkg() {
    dnf list installed "$1" 2> /dev/null
}

# Get latest release from Github repository
gh_get_latest_release() {
    basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/ryanoasis/nerd-fonts/releases/latest)
}

# CONFIGURATION
echo "DNF configuration"
if ! grep -iq 'fastestmirror=' /etc/dnf/dnf.conf
then
    echo "Use fastest DNF mirrors"
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
else
    echo "DNF mirrors already configured -> nothing to do."
fi

if ! grep -iq 'max_parallel_downloads=' /etc/dnf/dnf.conf
then
    echo "Use 10 parallel download streams"
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
else
    echo "Parallel downloads already configured -> nothing to do."
fi


echo "Checking some $HOME/.local subdirectories"

# Create .local folders if needed
if [ ! -d "$HOME/.local/bin" ]
then
    echo "Create $HOME/.local/bin"
    mkdir -p "$HOME/.local/bin"
else
    echo "$HOME/.local/bin already exists -> nothing to do."
fi

if [ ! -d "$HOME/.local/share/fonts" ]
then
    echo "Create $HOME/.local/share/fonts"
    mkdir -p "$HOME/.local/share/fonts"
else
    echo "$HOME/.local/share/fonts already exists -> nothing to do."
fi

if [ ! -d "$HOME/.local/share/icons" ]
then
    mkdir -p "$HOME/.local/share/icons"
else
    echo "$HOME/.local/share/icons already exists -> nothing to do."
fi

if [ ! -d "$HOME/.local/share/themes" ]
then
    mkdir -p "$HOME/.local/share/themes"
else
    echo "$HOME/.local/share/themes already exists -> nothing to do."
fi

# Install nerd fonts
# First get latest release from Github repository
# Then download all fonts in a for loop using nf_list variable
# Then uncompress the zip files into $HOME/.local/share/fonts
# unzip %font_name.zip -d $HOME/.local/share/fonts

# Install RPM Fusion repositories
echo "Enable RPM Fusion repositories"
if ! check_pkg rpmfusion-free-release
then
    sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
else
    echo "rpmfusion-free repository already present -> nothing to do."
fi

if ! check_pkg rpmfusion-nonfree-release; then
    sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
else
    echo "rpmfusion-nonfree repository already present -> nothing to do."
fi

# PACKAGES
echo "Install Z shell"
sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting

echo "Install base software"
sudo dnf install -y bat curl dnf-utils fd-find fzf gh g++ git git-delta jq lsd meld neovim ripgrep stow tealdeer tmux zoxide

echo "Install distrobox"
sudo dnf install -y distrobox

echo "Install podman complementary packages"
sudo dnf install -y podman-compose podman-docker

echo "Install gnome-shell extensions"
sudo dnf install -y gnome-shell-extension-appindicator gnome-shell-extension-blur-my-shell gnome-shell-extension-dash-to-dock gnome-shell-extension-user-theme gnome-tweaks

# CODECs

# Swap ffmpeg
if check_pkg "ffmpeg-free"
then
    echo "Swap ffmpeg-free for ffmpeg"
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
else
    sudo dnf install -y ffmpeg --allowerasing
fi

if ! check_pkg code
then
    echo "Install VSCode from Microsoft"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf check-update
    sudo dnf install -y code
else
    echo "VSCode already installed -> nothing to do."
fi

# Global git configuration
# Configure git-delta package as diff pager
# git config --global core.pager "delta"
# git config --global interactive.diffFilter "delta --color-only"
# git config --global delta.navigation "true"
# git config --global delta.light "false"
# git config --global merge.conflicstyle "diff3"
# git config --global diff.colorMoved "default"

# COPR
# Lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y lazygit

# Starship
sudo dnf copr enable atim/starship -y
sudo dnf install starship -y

# FLATPAKS
echo "Configure Flathub"
if [ ! "$(flatpak remotes | grep -c flathub)" ]; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null
else
    echo "Flathub already configured -> nothing to do."
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
flatpak install flathub --noninteractive -y "org.gnome.World.PikaBackup"
flatpak install flathub --noninteractive -y "com.bitwarden.desktop"

# CLEANUP
echo "Remove some unwanted/unneeded applications"
echo "Uninstall Rhythmbox"
sudo dnf remove -y rhythmbox

# Install chezmoi for dotfiles management in $HOME/.local/bin
sh -c "$(curl -fsLS get.chezmoi.io/lb)
