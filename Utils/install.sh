# !/bin/bash

# install xcode tools
xcode-select --install

# install brew
caffeinate -idm /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install via brew
brew bundle --file=./Brewfile
