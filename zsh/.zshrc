setopt nolistbeep

# NVM - npm version manager.  Required for LSPs
# Using zsh-nvm, and lazy-load to save some startup time
# Must be set before zsh-nvm is loaded
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
# neovim obviously uses node for lsp at times
# and opencode is partially written in typescript and uses LSP, so assume need to load there too just in case
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'nvim' 'opencode')

# Completions settings
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit
zmodload zsh/complist
zstyle ':completion:*' menu select

# Case insensitive matching
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'

compinit -d "$ZSH_COMPDUMP" # needs to be run after zmodload per zsh docs
_comp_options+=(globdots)

# Aliases and env vars first
source "$HOME/.alias"
source "$HOME/.env"

# plugins
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-nvm/zsh-nvm.plugin.zsh"

source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/directories.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/keybinds.zsh"

# Functions sourced for completions/autoload
fpath+=~/.zfunc

# Other Stuff

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

