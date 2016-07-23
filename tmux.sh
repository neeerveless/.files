#!/bin/sh

sudo yum install -y epel-release libevent ncurses tmux
sudo yum install -y libevent
sudo yum install -y ncurses
sudo yum install -y tmux
ln -s ~/.files/.tmux.conf ~/
