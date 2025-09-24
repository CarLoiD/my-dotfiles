# HOME folders
cp -r .vim/ ~/
cp -r .config/ ~/
cp -r .smb/ ~/

# Vim init file
cp .vimrc ~/
cp .env_vars.sh ~/

# Append the source to the custom environment variables, if not present already
BASHRC_APPEND="source ~/.env_vars.sh"
grep -qxF "$BASHRC_APPEND" ~/.bashrc || echo "$BASHRC_APPEND" >> ~/.bashrc
