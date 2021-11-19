alias site="cd ~/enjoei/website"
alias website-server="docker exec -it website bin/rails s -b 0.0.0.0"
alias website-migrate="docker exec -it website bin/rake db:migrate"
alias website-console="docker exec -it website bin/rails c"
alias website-bundle-install="docker exec -it website bundle install"
alias website-shell="docker exec -it website /bin/bash"
alias coverage="brave-browser ~/enjoei/website/coverage/index.html"
alias config="nvim ~/.config/matheus_aliazes.sh"
alias gclean="git branch | grep -v "master" | xargs git branch -D"
function lazygit() {
    git add .
    git commit -a -m "$1"
    git push
}
alias vim="nvim"
alias vimconfig="nvim ~/.config/nvim/init.vim"
bindkey -v
bindkey "^R" history-incremental-search-backward
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
