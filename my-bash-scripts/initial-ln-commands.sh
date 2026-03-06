ln -s ~/.config/vimrc ~/.vimrc
ln -s ~/.config/zshrc ~/.zshrc
ln -s ~/.config/wezterm.lua ~/.wezterm.lua
ln -s ~/.config/gitconfig ~/.gitconfig
ln -s ~/.config/vim/coc-settings.json ~/.vim/coc-settings.json 
mkdir -p ~/.git-hooks
ln -s ~/.config/my-bash-scripts/pre-commit ~/.git-hooks/pre-commit
git config --global core.hooksPath ~/.git-hooks
