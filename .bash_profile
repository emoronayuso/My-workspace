#startx automatically

if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
  startx
fi


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


export LANG="es_ES.UTF-8"
export LANGUAGE=$LANG
export LC_ALL=$LANG
