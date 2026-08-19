#!/usr/bin/env bash

set -ex

install_go() {
    # exit early if go is already installed
    [[ -x $(which go) ]] && return
    curl -fsSL -O https://go.dev/dl/go1.27.0.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.27.0.linux-amd64.tar.gz
}

symlinks() {
    ln -sf $HOME/.dotfiles/.alias $HOME/.alias
    ln -sf $HOME/.dotfiles/.env $HOME/.env
    ln -sf $HOME/.dotfiles/.scripts $HOME/.local/scripts
    ln -sf $HOME/.dotfiles/zsh $HOME/.config/zsh
    ln -sf $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
    ln -sf $HOME/.dotfiles/nvim-config $HOME/.config/nvim
    ln -sf $HOME/.dotfiles/wezterm $HOME/.config/wezterm
    ln -sf $HOME/.dotfiles/glide $HOME/.config/glide

}

zsh_config() {
    cat <<'EOF' > $HOME/.zshenv
    source '$HOME/.env'
    EOF

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.config/zsh/plugins/zsh-autosuggestions
    git clone https://github.com/lukechilds/zsh-nvm.git $HOME/.config/zsh/plugins/zsh-nvm
}

install_go
symlinks
zsh_config
