# Make Vi mode transitions faster (KEYTIMEOUT is in hundreths of a second)
export KEYTIMEOUT=1
bindkey -v
source .zsh/p10k.zsh

autoload -Uz add-zsh-hook
export DISABLE_AUTO_TITLE=true
