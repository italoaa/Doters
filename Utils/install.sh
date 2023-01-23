# !/bin/bash

# install xcode tools
xcode-select --install

# install brew
export HOMEBREW_BREW_GIT_REMOTE="..."  # put your Git mirror of Homebrew/brew here
export HOMEBREW_CORE_GIT_REMOTE="..."  # put your Git mirror of Homebrew/homebrew-core here

caffeinate -idm NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install via brew
caffeinate -idm /bin/bash -c "$(brew bundle --file=./Brewfile)"
