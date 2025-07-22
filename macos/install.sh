#!/usr/bin/env zsh

set -e

if ! command -v "brew" > /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew already installed"
fi

echo "Adding select custom brew taps and installing select applications..."
brew bundle install
