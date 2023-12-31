#! /usr/bin/env bash
echo "DNF configuration ..."
if [ ! $(grep -ic 'fastestmirror=' /etc/dnf/dnf.conf) ]; then
    echo -n "Use fastest DNF mirrors"
    echo "fastestmirror=True" >> /etc/dnf/dnf.conf
fi

if [ ! $(grep -ic 'max_parallel_dowwnloads=' /etc/dnf/dnf.conf) ]; then
    echo -n "Use 10 parallel download streams"
    echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
fi

echo "Installing Z shell"
sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting

echo "Installing base software"
sudo dnf install -y bat curl fd-find fzf gh git-delta jq lsd meld ripgrep stow tealdeer tmux zoxide

echo "Install distrobox"
sudo dnf install -y distrobox

echo "Install podman complementary packages"
sudo dnf install -y podman-compose podman-docker

echo "Install gnome-shell extensions"
sudo dnf install -y gnome-shell-extension-appindicator gnome-shell-extension-blur-my-shell

echo "Remove some unwanted/unneeded applications"
echo "Uninstall LibreOffice ..."
sudo dnf group remove -y @LibreOffice
sudo dnf remove -y libreoffice*
echo "Uninstall Rhythmbox"
sudo dnf remove -y rhythmbox

echo "Configure Flathub if needed ..."
if [ ! $(flatpak remotes | grep -c flathub) ]; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null
fi

echo "Installing flatpaks"
flatpak install flathub --noninteractive -y "com.mattjakeman.ExtensionManager"
flatpak install flathub --noninteractive -y "com.usebottles.bottles"
flatpak install flathub --noninteractive -y "com.valvesoftware.Steam"
# GUI for distrobox management
flatpak install flathub --noninteractive -y "io.github.dvlv.boxbuddyrs"
flatpak install flathub  --noninteractive -y "com.github.tchx84.Flatseal"
flatpak install flathub --noninteractive -y "com.discordapp.Discord"
flatpak install flathub  --noninteractive -y "md.obsidian.Obsidian"
flatpak install flathub  --noninteractive -y "org.mozilla.Thunderbird"
flatpak install flathub  --noninteractive -y "org.onlyoffice.desktopeditors"
