# HOME folders
cp -r .vim/ ~/
cp -r .config/ ~/
cp -r .smb/ ~/

# HOME items
cp .vimrc ~/
cp .env_vars.sh ~/
cp .Xresources ~/
cp base16-default-dark-256.Xresources ~/

# Append the source to the custom environment variables, if not present already
BASHRC_APPEND="source ~/.env_vars.sh"
grep -qxF "$BASHRC_APPEND" ~/.bashrc || echo "$BASHRC_APPEND" >> ~/.bashrc

# Apply XTerm settings
xrdb -merge ~/.Xresources
