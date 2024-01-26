# Set the oh-my-posh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/agnosterplus.omp.json" | Invoke-Expression

# Function to make navigating to Nand2Tetris faster
function gotoNand2Tetris { Set-Location "C:\Users\zachary.eller.WILSONLEGAL\Nextcloud\Documents\Learning\OSSU\Nand2Tetris\nand2tetris" }
# Function to make navigation to Projects faster
function gotoProjects { Set-Location "C:\Users\zachary.eller.WILSONLEGAL\OneDrive - Harbor Global\Documents\Projects" }
function gotoScripts { Set-Location "C:\Users\zachary.eller.WILSONLEGAL\OneDrive - Harbor Global\Documents\Scripts" }

# Aliases
Set-Alias nand gotoNand2Tetris
Set-Alias projects gotoProjects
Set-Alias scripts gotoScripts
Set-Alias -Name touch -Value New-Item
Set-Alias -Name nano -Value notepad++
Set-Alias -Name gedit -Value notepad++

# Environment Variables
$env:PYTHONSTARTUP = "C:\Users\zachary.eller.WILSONLEGAL\.dotfiles\dotfiles\.scripts\pythonstartup.py"