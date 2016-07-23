alias ls='ls -AGp'
alias cl='clear'
alias ps='ps aux'
alias mkdir='mkdir -p'
alias hist='history 1'
alias pmv='perl -le '"'"'for $module (@ARGV) { eval "use $module"; print "$module ", ${"$module\::VERSION"} || "not found" }'"'"
alias pmmm='perl -Ilib -M$1 -MData::Dumper -e "print Dumper(%$1::)"'
alias start='./script/*_server.pl -r -p 3004'
alias create='./script/*_create.pl'
alias mp="plmetrics --result methods --file $1"
alias mpp="echo $1"
alias repl='perl -le "use Carp::Reply qw();Carp::Reply::repl();"'
# alias ag='ag --pager="less -R"'
alias heyjenkins='curl -X POST "http://192.168.56.87:8080/job/Tachyon-Test/build"'
alias dc='du -m | sort -nr | head -10'
pmm() { perl -Ilib -M$1 -MData::Dumper -e "print Dumper(%$1::)" }
startc() { ./script/*_server.pl -r -p $1; }
plackc() { plackup -p $1 -e 'use Plack::App::Directory; Plack::App::Directory->new({root => "'$2'"})->to_app'; }
alias tmux='tmux -2'
# cd ()
# {
#   builtin cd "$@" && ls
# }
mkcd ()
{
  mkdir "$@" && cd "$@"
}

_pq() {
  peco --query "$LBUFFER"
}

_sct() {
  awk '{print $2}'
}

_gct() {
  awk '{print $2}'
}
# agコマンドからvim コマンドの引数を作る
_va() {
  awk -F : '{print "-c " $2 " " $1}'
}
# ブランチを作成した時のリビジョン番号取得
_br() {
  svn log --stop-on-copy -q --incremental | tail -1 | sed 's/^r\([0-9]\+\).*$/\1/' | tr -d '\n'
}

# merge() {
#   OLDEST=`_br`
#   COMMAND="svn merge --dry-run -r $OLDEST:HEAD ./ ../../development"
#   print -z $COMMAND
# }
# branchを作成してからのsvn diff
da() {
  svn diff -r `_br`:HEAD | vim -R -
}
# branchを作成してから変更を加えたファイルのパスを取得
chp() {
  svn diff --summarize -r `_br`:HEAD
}
# chpの結果をvimで開く
chpv() {
  vim $(chp | grep -v "^D" | _pq | _sct)
}
# chpの結果に対してag
chpag() {
  chp | grep -v -e "^D" | _sct | xargs ag --line-numbers $1
}
# chagの結果をvimで開く
chpagv() {
  vim $(chpag $1 | _pq | _va)
}
# branchを作成してから変更を加えたファイル内の行末スペースを見つける
ds() {
  chpag "( )+$"
}
# dsの結果をvimで開く
dsv() {
  vim $(ds | _pq | _va)
}
# agで検索した結果から選択し、ファイルを開く
agv () {
  vim $(ag $@ | _pq | _va)
}

# agで検索した結果から選択し、ファイルを開く
agvl () {
  vim $(ag -l $@ | _pq | _va)
}

# svn st から色々
# {{{
#svn st からpeco を使ってパスを取得
_sp() {
  svn st | _pq | _sct
}
# svn stの結果から選択し、ファイルを開く
# stv () {
#   vim $(_sp)
# }
stag () {
  svn st | grep -v -e "^?" | _sct | xargs ag --line-numbers $1
}
stagv () {
  vim $(stag $1 | _pq | _va)
}
# svn stの結果から選択し、diffをみる
# std () {
#   svn diff $(_sp) | vim -R -
# }
# }}}

stv () {
  vim $(git st | grep modified | _gct | _pq )
}

std() {
  git diff $(git st | grep modified | _gct | _pq )
}

# historyからコマンド実行
# {{{
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(
      \history 1                 | \
      \sort -k2 -r               | \
      \uniq -f1                  | \
      \sort -nr                  | \
      _pq                        | \
      \awk -F' ' '{$1="";print}' | \
      \sed -e 's/^ \+//'
    )
    CURSOR=$#BUFFER
}
zle -N peco-select-history
bindkey '^r' peco-select-history
# }}}

# リリース時に使える？
# {{{
pl() {
  rlog=`svn log --limit $(($1+1)) -q production/ | sed 's/^r\([0-9]\+\).*$/\1/' | grep -e '^[0-9]'`
  array=( `echo $rlog | tr -s '\n' ' ' `)
  for i in `seq 1 $1`
  do
    echo st ${array[i+1]} ${array[i]}
  done
}

plwc() {
  rlog=`svn log --limit $(($1+1)) production | sed 's/^r\([0-9]\+\).*$/\1/' | sed 's/.*#\([0-9]\+\).*$/\1/' | grep -e '^[0-9]'`
  array=( `echo $rlog | tr -s '\n' ' ' `)
  for i in `seq 0 $(($1-1))`
  do
    j=$((${i}*2+1))
    echo stwc ${array[j+2]} ${array[j]} \(refs\#${array[j+1]}\)
  done

}

pplwc() {
  $(plwc $1 | _pq)
}

ppl() {
  $(pl $1 | _pq)
}

_summarize() {
  svn diff --summarize production -r $1:$2
}

st_d() {
  _summarize $1 $2 | grep -e "^D" | _sct
}
st_a() {
  _summarize $1 $2 | grep -e "^A" | _sct
}
st_m() {
  _summarize $1 $2 | grep -e "^M" | _sct
}
st_etc() {
  _summarize $1 $2 | grep -v "^M" | grep -v "^A" | grep -v "^D"
}

stwc() {
  echo $3
  st $1 $2
}

st() {
  echo 下記は削除
  st_d $1 $2
  echo 下記は新規
  st_a $1 $2
  echo 下記は編集
  st_m $1 $2
  echo その他
  st_etc $1 $2
}
# }}}

# docker
de () {
  docker exec -it $(docker ps | awk 'NR>1 {print $NF}' | _pq) $@
}

tt() {
  TACHYON_WEBSITE_HOME=. TACHYON_WEBSITE_CONFIG_LOCAL_SUFFIX=test_mysqld CATALYST_DEBUG=0 prove -Ilib -It/lib -rvc $1;
}

