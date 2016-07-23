#!/bin/sh

wget https://github.com/peco/peco/releases/download/v0.3.5/peco_linux_386.tar.gz
tar xvzf peco_linux_386.tar.gz
rm peco_linux_386.tar.gz
echo 'export PATH=$HOME/peco_linux_386/:$PATH' >> ~/.zshrc
