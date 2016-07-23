#!/bin/sh

cd ~/
wget http://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2 -F ~/
tar jxvf vim-7.4.tar.bz2
cd ~/vim74

mkdir ~/vim74/patches
cd ~/vim74/patches
seq -f http://ftp.vim.org/pub/vim/patches/7.4/7.4.%03g 052 | xargs wget
cd ~/vim74
cat ~/vim74/patches/7.4.* | patch -p0

cd ~/vim74
sudo ./configure --with-features=huge --enable-multibyte --disable-selinux --prefix=/usr/local
sudo make
sudo make install

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/undodir
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

ln -s ~/.files/.vimrc ~/
cp .files/vim/colors ~/.vim
