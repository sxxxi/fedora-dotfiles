#!/bin/sh
#
# FUNCTIONS
prompt() {
    local OUTPUT_VAR="$1";
    local PROMPT_MESSAGE="$2";
    local DEFAULT_VALUE="$3";
    local INPUT="";

    # Loop until valid input is provided
    while true; do
        # If default value is provided, display it as a suggestion
        if [ -n "$DEFAULT_VALUE" ]; then
            read -p "$PROMPT_MESSAGE [$DEFAULT_VALUE]: " INPUT;
        else
            read -p "$PROMPT_MESSAGE: " INPUT;
        fi;

        # If input is empty and default value is provided, use default value
        if [ -z "$INPUT" ] && [ -n "$DEFAULT_VALUE" ]; then
            INPUT="$DEFAULT_VALUE";
            break;
        # If input is non-empty, accept it
        elif [ -n "$INPUT" ]; then
            break;
        else
            echo "This is required, sir! 😢";
        fi;
    done;

    # Assign the validated input value to the variable passed as the first argument
    eval "$OUTPUT_VAR=\"$INPUT\"";
}

# ENTRYPOINT
sudo dnf update -y;

if [ "$SHELL" != "/bin/zsh" ]; then
    sudo dnf install -y zsh;
    sudo usermod -s /bin/zsh $USER;
    echo "Rebooting to change your shell to zsh. ABORT NOW IF YOU DONT WANNA!" && sleep 10;
    sudo reboot;
fi;

sudo dnf install -y curl tmux ripgrep git stow neovim alacritty;

# Docker
if [ -z $(command -v docker) ]; then
    # Remove old versions
    sudo dnf remove -y docker docker-client docker-client-latest docker-common \
        docker-latest docker-latest-logrotate docker-logrotate docker-selinux \
        docker-engine-selinux docker-engine;

    # Setup the repository
    sudo dnf -y install dnf-plugins-core;
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo;

    # Install the engine
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;

    # Start docker service
    sudo systemctl enable --now docker;

    # add user to docker group
    if [ -z $(groups $USER | grep "docker") ]; then
        sudo groupadd docker;
        sudo usermod -aG docker $USER;
        echo "Reboot after the script to add the user to the docker group." && sleep 10;
    fi;
fi;

# TPM
if [ ! -s $HOME/.tmux ]; then
    echo "Cloning TPM for tmux...";
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm;
fi;

# Node Version Manager
if [ ! -s $HOME/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | zsh;
fi;

# Setup git key
SSH_DIR="$HOME/.ssh";
prompt KEY_NAME "Enter Github SSH key name to search" "gitkey";
ABS_KEY_FILE="$SSH_DIR/$KEY_NAME";

if [ ! -f $ABS_KEY_FILE ]; then
    prompt KEY_COMMENT "Enter comment";
    ssh-keygen -t ed25519 -C $KEY_COMMENT -f $ABS_KEY_FILE;
fi;

echo "Public key: $(cat $ABS_KEY_FILE.pub)\n";

clear;

echo "Configure Git:";

prompt GIT_DEFAULT_BRANCH "Default branch" "main";
prompt GIT_USER_EMAIL "Email" "$(git config --global user.email)";
prompt GIT_USER_NAME "Name" "$(git config --global user.name)";

git config --global init.defaultBranch "$GIT_DEFAULT_BRANCH";
git config --global user.email "$GIT_USER_EMAIL";
git config --global user.name "$GIT_USER_NAME";

# GNOME settings
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

sudo su - $USER
