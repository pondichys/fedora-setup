echo "Installing Z shell"
sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting

echo "Installing base software"
sudo dnf install -y bat curl fd-find fzf gh git-delta jq meld ripgrep stow tealdeer tmux tree zoxide

echo "Install kitty terminal"
sudo dnf install -y kitty

echo "Install distrobox"
sudo dnf install -y distrobox

