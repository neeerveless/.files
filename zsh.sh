#!/bin/sh
sudo yum install -y zsh
chsh -s /bin/zsh

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

ln -s ~/.files/zsh/alias.zsh ~/.oh-my-zsh/custom
ln -s ~/.files/zsh/conf.zsh ~/.oh-my-zsh/custom
