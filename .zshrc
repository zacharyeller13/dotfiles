setopt nolistbeep

# NVM - npm version manager.  Required for LSPs
# Using zsh-nvm, and lazy-load to save some startup time
# Must be set before zsh-nvm is loaded
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
# neovim obviously uses node for lsp at times
# and opencode is partially written in typescript and uses LSP, so assume need to load there too just in case
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'nvim' 'opencode')

# node is now loaded
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Completions settings
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
zstyle ':completion:*' menu select

# Aliases and env vars first
source "$HOME/.alias"
source "$HOME/.env"

# plugins
source "$ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH/plugins/zsh-nvm/zsh-nvm.plugin.zsh"

source "$ZSH/functions.zsh"
source "$ZSH/directories.zsh"
source "$ZSH/history.zsh"
source "$ZSH/keybinds.zsh"

# Set up fzf key bindings and fuzzy completion
if type fzf > /dev/null; then
    source <(fzf --zsh)
fi
eval "$(uv generate-shell-completion zsh)"

# Starship prompt
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# all other completions
fpath+=~/.zfunc
