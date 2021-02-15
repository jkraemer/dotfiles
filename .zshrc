#
# zsh config
#
unsetopt notify

# history
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000

setopt appendhistory            # append
setopt hist_ignore_all_dups     # no duplicate
setopt hist_ignore_space        # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
setopt share_history            # share hist between sessions
# setopt bang_hist                # !keyword

# keybindings
bindkey -e
bindkey '\e[1;5C' forward-word            # C-Right
bindkey '\e[1;5D' backward-word           # C-Left

# word matching like in bash
# https://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter
autoload -U select-word-style
select-word-style bash

# zsh completion
# https://dustri.org/b/my-zsh-configuration.html
autoload -Uz compinit
compinit
zmodload -i zsh/complist
setopt nomatch                  # error when completion pattern had no match
setopt hash_list_all            # hash everything before completion
unsetopt completealiases        # so gco mas<tab> completes the branch name
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'  # ignore case and complete from mid-word
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=(jk root)           # because I don't care about others
zstyle ':completion:*' users $users

# git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# ssh known hosts completion
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# other zsh options
setopt auto_cd                  # if command is a path, cd into it
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
unsetopt correct_all           # turn off auto correction
setopt extended_glob            # activate complex pattern globbing
setopt glob_dots                # include dotfiles in globbing
#setopt print_exit_value         # print return value if non-zero
#unsetopt beep                   # no bell on error
#unsetopt bg_nice                # no lower prio for background jobs
unsetopt clobber                # must use >| to truncate existing files
#unsetopt hist_beep              # no bell on error in history
unsetopt hup                    # no hup signal at shell exit
unsetopt ignore_eof             # do not exit on end-of-file
#unsetopt list_beep              # no bell on ambiguous completion
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'
# setxkbmap -option compose:ralt  # compose-key
# print -Pn "\e]0; %n@%M: %~\a"   # terminal title


# prompt
if [[ -s "/usr/share/powerlevel9k/powerlevel9k.zsh-theme" ]]; then
  source /usr/share/powerlevel9k/powerlevel9k.zsh-theme
  POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND='green1'
fi

# aliases
if [[ -s "${HOME}/.aliases" ]]; then
  source "${HOME}/.aliases"
fi

# chruby
if [[ -s "/usr/local/share/chruby/chruby.sh" ]]; then
  source /usr/local/share/chruby/chruby.sh
fi

# direnv
if [[ -x "/usr/bin/direnv" ]]; then
  eval "$(direnv hook zsh)"
fi

# fzf
# https://medium.com/better-programming/boost-your-command-line-productivity-with-fuzzy-finder-985aa162ba5d
if [[ -s "/usr/share/doc/fzf/examples/key-bindings.zsh" ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

#
# environment
#
export EDITOR=vim
export VISUAL=$EDITOR
export RUBYOPT=-rrubygems
export PATH=$HOME/bin:$PATH
if [[ -z "$TMUX" ]]; then
  export TERM="xterm-256color"
else
  export DISABLE_AUTO_TITLE=true
fi

# more stuff, if any
if [[ -s "${HOME}/.zsh_local" ]]; then
  source "${HOME}/.zsh_local"
fi

