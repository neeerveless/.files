# Add yourself some shortcuts to projects you often work on
# Example:
#
# brainstormr=/Users/robbyrussell/Projects/development/planetargon/brainstormr
#
bindkey -e
setopt auto_cd              # cdなしで移動できるようになる
setopt auto_pushd           # cd -[TAB] で移動先を履歴から補完
setopt list_packed          # 補完候補を詰めて表示
setopt nolistbeep           # 補完時のビープ音を無効化
setopt complete_aliases     # alias展開後に補完する
unsetopt AUTOREMOVESLASH
# setopt noautoremoveslash    # ファイル名補完時に自動で末尾のスラッシュを削除しないようにする

# Ctrl-P, Ctrl-N でコマンド履歴で補完
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=50000
export SAVEHIST=100000
