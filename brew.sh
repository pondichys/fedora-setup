echo "Install HomeBrew dependencies"
sudo dnf groupinstall -y 'Development Tools'

echo "Install HomeBrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bash_profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "Install software available through HomeBrew"
brew install bottom
brew install lazygit
brew install scw
brew install starship



