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

promptreboot() {
    prompt SHOULD_REBOOT "Reboot now?" "y";
    if [ "$SHOULD_REBOOT" == "y" ]; then
        sudo reboot;
    fi;
}

promptbool() {
    local PROMPT=$1;

    prompt SHOULD "$PROMPT" "Y";

    if [ "$SHOULD" = "y" ] || [ "$SHOULD" = "Y" ]; then
        return 0;
    else
        return 1;
    fi;
}

# ENTRYPOINT
sudo dnf update -y;
sudo dnf install -y curl tmux zsh ripgrep git stow neovim alacritty;

if promptbool "Modify GNOME settings?"; then
    # GNOME settings
    # Mess with the settings app while running `dconf watch /` to see the changes
    # Run this outside of tmux and make sure the $DISPLAY variable is not empty when you echo it
    gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden true;                                               # Show hidden files in the file explorer
    gsettings set org.gnome.system.location enabled false;                                                          # Location sharing
    gsettings set org.gnome.desktop.session idle-delay 0;                                                           # Turn off screen timeout
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark;                                             # Dark mode
    gsettings set org.gnome.desktop.interface accent-color "purple";                                                # SLAAAAYY!
    gsettings set org.gnome.desktop.screensaver picture-uri "file:///usr/share/backgrounds/gnome/blobs-l.svg";      # Set my favourite wallpaper as default
    gsettings set org.gnome.desktop.screensaver primary-color "#241f31";                                            # IDK
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat;                                           # Mouse acceleration off
    gsettings set org.gnome.desktop.peripherals.mouse speed 0;                                                      # Mouse speed
    gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'anthy'), ('xkb', 'us')]";                     # Add japanese input
    gsettings set org.gnome.desktop.input-sources mru-sources "[('xkb', 'us')]";                                    # IDK lol

    # The new terminal's config. Just install Ptyxis when using F40 I guess?
    gsettings set org.gnome.Ptyxis interface-style "dark";
    gsettings set org.gnome.Ptyxis use-system-font false;
    gsettings set org.gnome.Ptyxis font-name "JetBrainsMonoNL Nerd Font Mono Thin 12";
    gsettings set org.gnome.Ptyxis cursor-shape "ibeam";
    gsettings set org.gnome.Ptyxis cursor-blink-mode "on";
    gsettings set org.gnome.Ptyxis.Shortcuts move-previous-tab "<Shift><Control>h";
    gsettings set org.gnome.Ptyxis.Shortcuts move-next-tab "<Shift><Control>l";
fi;

# Link config files
cd $(dirname $0) && stow .;

# Change user shell to zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    sudo usermod -s /bin/zsh $USER;
    echo "Rebooting to change your shell to zsh. ABORT NOW IF YOU DONT WANNA!" && sleep 5;
    sudo reboot;
fi;

# Docker
if promptbool "Install Docker engine?" && [ -z $(command -v docker) ]; then
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
else
    echo "Docker already installed or you just didn't wanna install. IDK";
fi;

# TPM
if promptbool "Clone TPM for tmux?" && [ ! -s $HOME/.tmux ]; then
    echo "Cloning TPM for tmux...";
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm;
fi;

# Node Version Manager
if promptbool "Install Node Version Manager?" && [ ! -s $HOME/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash;
fi;

if promptbool "Perform GIT configuration?"; then
    # Setup git key
    SSH_DIR="$HOME/.ssh";
    prompt KEY_NAME "Enter Github SSH key name to search" "gitkey";
    ABS_KEY_FILE="$SSH_DIR/$KEY_NAME";

    if [ ! -f $ABS_KEY_FILE ]; then
        prompt KEY_COMMENT "Enter comment";
        ssh-keygen -t ed25519 -C $KEY_COMMENT -f $ABS_KEY_FILE;
        eval "$(ssh-agent -s)";
        ssh-add $ABS_KEY_FILE;
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
fi;

promptreboot;
