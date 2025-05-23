#!/usr/bin/env bash

set -e

# Generate a new ssh key, add it to the agent, and remind ourselves to add to
# Github
echo "Generating a new ed25519 ssh key-pair for use with Github identified by $(whoami)@$(hostname)";
echo "Follow the prompt and copy the resulting public key and add it to Github";
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)";
# this should be the filename of the public key
cat ~/.ssh/id_ed25519.pub
echo "When finished, press any key to continue install";
read;

# Now we can successfully clone via ssh
# Let's clone our dotfiles
git clone git@github.com:zacharyeller13/dotfiles.git "$HOME/.dotfiles";

# Not all of the packages will be listed if we don't do this first
sudo apt update && sudo apt upgrade

# venv is necessary for ruff and ruff_lsp in neovim
# probably also for some other stuff
sudo apt install python3-venv;

#Let's also install pip3 now cause we'll need it
sudo apt install python3-pip;

# Also pipx because PEP668 makes life hard
sudo apt install pipx;

# ripgrep is a better grep and also necessary for telescope in neovim
sudo apt install ripgrep;

# fd for better find
sudo apt install fd-find;

# install jq for json querying
sudo apt install jq;

# install latest neovim (the package manager version is going to be old
# for whatever reason)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo rm -rf /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz;

# Install unzip in order for some neovim extensions to work
sudo apt install unzip;

# Let's install zsh and oh-my-zsh
sudo apt install zsh;
# oh-my-zsh
echo "You will need to exit ZSH in order to continue"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";

# Now install zsh-autocomplete for oh-my-zsh
# And add it to the custom plugins directory
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autocomplete";

# Setup a new background with pywal
# We also need to install pip right now
pipx install pywal
echo "Please select a new background and create a wal colorscheme using
    'wal -i <path to picture>'
.zshrc will then source this from .cache/wal.  You can do this later";

# NVM (Node Version Manager) so we can install npm/node and let that be used for
# LSPs with neovim. I don't care about the ouput so do it in the background
# and throw it away
(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    > /dev/null 2>&1 &);

# Need to source nvm before we can actually use it
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node;

# Install mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# Let's get these symlinks setup
ln -s "$HOME/.dotfiles/nvim" "$HOME/.config/nvim";
ln -s "$HOME/.dotfiles/.alias" "$HOME/.alias";
ln -s "$HOME/.dotfiles/.env" "$HOME/.env";
ln -s "$HOME/.dotfiles/.gitconfig" "$HOME/.gitconfig";
ln -s "$HOME/.dotfiles/.ideavimrc" "$HOME/.ideavimrc";
ln -s "$HOME/.dotfiles/.nanorc" "$HOME/.nanorc";
ln -s "$HOME/.dotfiles/.tmux.conf" "$HOME/.tmux.conf";
ln -s "$HOME/.dotfiles/.scripts" "$HOME/.local/scripts";
ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc";

# Install xclip as our clipboard manager so that neovim config
# "clipboard=unnamedplus" actually works
sudo apt install xclip;

# Fuzzy finder, download it, but wait to install
# Ubuntu 22.04 package manager is on version 0.29 and current version is 0.59 so
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf";

# End with a couple reminders
echo "All done for now.  Remember to install steam (apt) and protonup (pip3) \
if we're playing games with Steam.  Also manually install fzf from .fzf directory";

