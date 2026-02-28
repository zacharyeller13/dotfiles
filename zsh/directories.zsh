# Copied much from oh-my-zsh

setopt auto_cd # automatically cd to a directory if not found as a command
setopt auto_pushd # auto add to dirs so popd works etc.
setopt pushd_ignore_dups
setopt pushdminus

# -g so that even 'cd ...' will expand to 'cd ../..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# List directory contents
alias ls='ls --color=auto'
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias ld="ls -ld */" # List only directories


alias -- -='cd -'

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d # completions
