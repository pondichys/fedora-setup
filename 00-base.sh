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
sudo dnf install -y bat curl fd-find fzf gh git-delta jq lsd meld ripgrep stow tealdeer tmux tree zoxide

echo "Install distrobox"
sudo dnf install -y distrobox

echo "Install podman complementary packages"
sudo dnf install -y podman-compose podman-docker
