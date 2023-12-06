echo "Installing Z shell"
sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting

echo "Installing base software"
sudo dnf install -y bat curl fd-find fzf gh git-delta jq meld ripgrep stow tealdeer tmux tree zoxide
