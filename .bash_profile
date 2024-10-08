# Add `~/bin` to the `$PATH`

export PATH="$HOME/bin:$PATH";

# Load shell dotfiles
# use ~/.path to extend $PATH

for DOTFILE in `find $HOME/.dotfiles`
do
    [ -f "$DOTFILE" ] && source "$DOTFILE"
done

