#!/bin/bash
cp -r ~/.config/alacritty ~/git/nar-dotfiles  
cp -r ~/.config/fish ~/git/nar-dotfiles  
cp -r ~/.config/nvim ~/git/nar-dotfiles  
cp -r ~/.config/fuzzel ~/git/nar-dotfiles  

#-------------------------------------------------#
cd ~/git/nar-dotfiles
git add --all
git commit
git push
