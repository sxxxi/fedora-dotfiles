OS_NAME=$(uname -s)

if [ "$OS_NAME" = "Darwin" ]; then
    export PATH="/usr/local/bin:/usr/bin:$HOME/.local/bin:$PATH"
    eval "$(/opt/homebrew/bin/brew shellenv)"        # Homebrew doing its thing
    JB_SCRIPTS="$HOME/Library/Application Support/JetBrains/Toolbox/scripts";    # OSX

elif [ "$OS_NAME" = "Linux" ]; then
    JB_SCRIPTS="$HOME.local/share/JetBrains/Toolbox/scripts";
fi

# Only append JetBrains script path to PATH if exists
[ -s $JB_SCRIPTS ] && export PATH="$JB_SCRIPTS:$PATH";

# SSH agent
if [ -z $SSH_AUTH_SOCK ] && [ ! pgrep -u $USER ssh-agent > /dev/null ]; then
    eval $(ssh-agent -s);
fi
