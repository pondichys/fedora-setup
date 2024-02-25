echo "Install HomeBrew dependencies"
sudo dnf groupinstall -y 'Development Tools'

echo "Install HomeBrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bash_profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "Install software available through HomeBrew"
brew install azure-cli
brew install bitwarden-cli
brew install chezmoi
brew install fnm
brew install helm
brew install k9s
brew install kubie
brew install lazygit
brew install scw
brew install starship
brew install yazi
brew install yq
