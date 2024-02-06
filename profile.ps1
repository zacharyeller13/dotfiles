# Set the oh-my-posh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/agnosterplus.omp.json" | Invoke-Expression

# Functions
# Including gotoNand2Tetris, gotoProjects, gotoScripts
. "$HOME/.dotfiles/dotfiles/functions.ps1"

# Aliases
Set-Alias nand gotoNand2Tetris
Set-Alias projects gotoProjects
Set-Alias scripts gotoScripts
Set-Alias -Name touch -Value New-Item
Set-Alias -Name nano -Value notepad++
Set-Alias -Name gedit -Value notepad++
Set-Alias -Name vim -Value nvim

# Environment Variables
$env:PYTHONSTARTUP = "C:\Users\zachary.eller.WILSONLEGAL\.dotfiles\dotfiles\.scripts\pythonstartup.py"
