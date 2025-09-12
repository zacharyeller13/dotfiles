zmodload zsh/zprof

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="yyyy-mm-dd"

# NVM - npm version manager.  Required for LSPs
# Using zsh-nvm, and lazy-load to save some startup time
# !!Must be set before zsh-nvm is loaded
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
# neovim obviously uses node for lsp at times
# and opencode is partially written in typescript and uses LSP, so assume need to load there too just in case
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'nvim' 'opencode')

#node is now loaded
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autocomplete dotnet zsh-nvm)

# User configuration

# Tmux config
if [[ "$TERMINAL_EMULATOR" != "Jetbrains-Jedi" ]]; then  ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOCONNECT=false
fi
# ZSH_TMUX_AUTOQUIT=false

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
source "$HOME/.alias"
source $HOME/.env

# Import colorscheme from 'wal' asynchronously
# typically need to create with `wal -n -a "alpha" -i "<path>"`
# -a for transparency
# -n for not setting wallpaper
# -i for path of picture

[ -f "$HOME/.cache/wal/sequences" ] && (cat ~/.cache/wal/sequences &)

# Set up fzf key bindings and fuzzy completion
if type fzf > /dev/null; then
    source <(fzf --zsh)
fi
eval "$(uv generate-shell-completion zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
