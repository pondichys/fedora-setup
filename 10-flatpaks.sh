#!/usr/bin/env bash
# FLATPAKS
echo "Configure Flathub"
if [ "$(flatpak remotes | grep -c flathub)" ]; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null
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
