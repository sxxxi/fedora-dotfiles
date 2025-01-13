[ -f /etc/zshrc ] && source /etc/zshrc

# Configure shell UI and shit
. $HOME/.dotfiles/config/.config/.myshell

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
