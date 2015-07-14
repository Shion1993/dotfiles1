# LANGの設定
export LANG=ja_JP.UTF-8
case ${UID} in
  0)
    LANG=C
    ;;
esac
 
# lsの色を指定
# eval "$(dircolors -b)"  # 環境変数 LS_COLORS を設定
#----- 手動で設定する場合
#export LS_COLORS='di=01;34:ln=01;36:ex=01;32:*.tar=01;31:*.gz=01;31'
#-----
 
# lessから使うエディタの指定
export VISUAL=emacs
 
 
#####
##### Default shell configuration
#####
 
###############################################################################
# Prompt config                                                               #
###############################################################################
autoload colors
colors
# ----- begin for git
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
setopt prompt_subst  # プロンプトが表示されるたび評価、置換
function rprompt-git-current-branch {
  local name st color gitdir action
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi
  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  if [[ -z $name ]]; then
    return
  fi
  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%B%F{red}
  else
    color=%F{red}
  fi
  echo "$color$name$action%f%b "
}
# ----- end for git
# [%n@%m]
#PROMPT="%B%F{magenta}(΄◉◞౪◟◉ ) %(!.#.$) %f%b"
#PROMPT="%B%F{magenta}─=≡Σ((( つ•̀ω•́)つ%(!.#.$) %f%b"
PROMPT="%B%F{magenta}(*´﹃｀*)%(!.#.$) %f%b"
PROMPT2="$B%F{magenta}%_> %f%b"
RPROMPT='%B%F{yellow}[%f%b%D{%K:%M:%S} `rprompt-git-current-branch`%B%F{yellow}%~]%f%b'
SPROMPT="%B%F{red} correct: %R -> %r [n,y,a,e]? %f%b"
 
 
#----- 手動で設定する場合の例
#local DEFAULT=$'%{\e[1;37m%}'
#local MAGENTA=$'%{\e[1;35m%}'
#local RED=$'%{\e[1;31m%}'
#local YELLOW=$'%{\e[1;33m%}'
#PROMPT="
#${MAGENTA}[%n@%m] %(!.#.$) $DEFAULT"
#PROMPT2="${MAGENTA}%_> % $DEFAULT"
#SPROMPT="${RED}correct: %R -> %r [n,y,a,e]? $DEFAULT"
#RPROMPT="${YELLOW}[%~]$DEFAULT"
#-----
 
# Terminal title
case "${TERM}" in
  kterm*|xterm*)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST}\007"
    }
    ;;
esac
 
# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory         # HISTFILEを上書きせずに追記
setopt hist_ignore_all_dups  # 重複したとき、古い履歴を削除
setopt hist_ignore_space     # 先頭にスペースを入れると履歴を保存しない
setopt share_history         # 履歴を共有する
 
# Filter history searching(<C-p>, <C-n>)
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
 
# Completion
autoload -U compinit
compinit
setopt complete_aliases
zstyle ':completion:*:default' list-colors ${LS_COLORS}
 
#----- 手動で設定する場合
#zstyle ':completion:*' list-colors 'di=01;34:ln=01;36:ex=01;32:*.tar=01;31:*.gz=01;31' # 補完候補を色付きで表示
#-----
zstyle ':completion:*:default' menu select=1 # 補完候補をEmacsのキーバインドで選択
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31' # killの候補を色付き表示
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[-_.]=**' # 大文字を補完、-_.の前に*を補うようにして補完
setopt auto_list         # TAB一回目で補完候補を一覧表示
setopt complete_in_word  # 単語の途中でもカーソル位置で置換
setopt list_packed       # 補完候補を詰めて表示
setopt list_types        # 補完候補表示時にファイルの種類を表示。*, @, /
 
### Moving directory ###
# execute ls automatically after moving directory
function chpwd() {
  ls 
}
setopt autocd             # Move directory by directory name only, withput "cd"
setopt autopushd          # 自動でpushdする。cd -[tab]で候補表示
setopt chase_links        # リンクへ移動するとき実際のディレクトリへ移動
setopt pushd_ignore_dups  # 重複するディレクトリは記憶しない
# Job
setopt NOBGNICE           # バックグランドのジョブのスピードを落とさない
setopt NOHUP              # ログアウトしてもバックグランドジョブを続ける
 
# Other
bindkey -e           # Use emacs key-binds
setopt nobeep
setopt brace_ccl     # ブレース展開において{}の中身をソートして展開、また、{a-z}で文字範囲指定
setopt correct       # コマンドのスペルミスを指摘して直す
setopt extendedglob  # 正規表現のなんか？
setopt nomatch       # マッチしない場合はエラー？
setopt notify        # ジョブが終了したらただちに知らせる
setopt rm_star_wait  # rm * を実行する前に確認
 
 
###############################################################################
# Aliases                                                                     #
###############################################################################
eval "$(rbenv init -)"
alias grep='grep --color=auto'
# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1" 
alias vi="vim" 

man() {
  LESS_TERMCAP_mb=$'\e[1;31m' \
    LESS_TERMCAP_md=$'\e[1;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[1;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[4;36m' \
    command man "$@"
}
 
case ${OSTYPE} in
  cygwin)
    alias clear='echo -ne "\ec\e[3J"'
    ;;
esac

#####
##### ホストごとの設定があれば読み込む
#####
 
# [ -f ~/.zshrc.mine ] && source ~/.zshrc.mine
 
# autoload -Uz colors; colors
# PROMPT="%(?.%{$bg[green]%}.%{$bg[blue]%})%(?!(._.)/!(;_;%)?) %B%~$%b%{${reset_color}%} "
# PROMPT2="%{$bg[blue]%}%_>%{$reset_color%}%b "
# setopt correct
# SPROMPT="%{$bg[red]%}%{$suggest%}(._.%)? %B %r is correct? [n,y,a,e]:%{${reset_color}%}%b "
# 既にtmuxを起動してないか
if [ "$TMUX" = "" ]; then
	tmux attach;

# detachしてない場合
	if [ $? ]; then
		tmux;
	fi
fi


# -------------------------------------
# zshのオプション
# -------------------------------------
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## 色を使う
setopt prompt_subst
## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct
# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd 
# mintty
