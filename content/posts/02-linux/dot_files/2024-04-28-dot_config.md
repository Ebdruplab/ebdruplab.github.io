---
title: "Linux dot config"
author: Kristian
date: 2024-04-28
weight: 20
description: "A comprehensive guide on setting up and managing Linux dot files including .config and .bash_profile, specifically for Ubuntu installed using WSL2."
slug: "linux-dot-config"
tags: ["guide", "linux"]
---

# dot files for linux
In this guide I will provide you with info on how i setup my .config and .zshrc. I use it on a ubuntu, installed using wsl2. Beware im using zsh as i really love the colouring, plugins and more over efficiency of use. I have th

## Setup
I use the following locations:
- .config/{.bash_public, .bash_private}
- .bash_profile, that loads my .bash_private, .bash_public and the standard items like .bashrc

The newest files are located at [dotfiles](https://github.com/Ebdruplab/dotfiles)

**Important** Remember to change mod to 0700 and to set the owner to `$USER`.

**The `.zshrc` script is here, but for the newest go to the link:**
IMPORTANT change INSERT UR USER HERE to your use e.g for me its kristian!
```bash
# Powerlevel10k Instant Prompt
# ----------------------------
# This should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Vim Configuration
# -----------------
# Enable Vim configuration from .config directory if it exists.
if [[ -r "$HOME/.config/vim/vimrc" ]]; then
  export VIMINIT='source $HOME/.config/vim/vimrc'
fi

# Environment Variables
# ---------------------
export EDITOR=vim
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/git/ebdruplab/ansible-shared/scripts:/bin:/usr/bin:/snap/bin:$PATH

# Oh-My-Zsh Configuration
# -----------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_COLORIZE_TOOL=pygments
ZSH_COLORIZE_STYLE="colorful"

# Oh-My-Zsh Installation Check
# ----------------------------
if [ ! -d "$ZSH" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Load Custom Configurations and Secrets
# --------------------------------------
[ -f "$HOME/.config/.shell_functions.sh" ] && . "$HOME/.config/.shell_functions.sh"
[ -f "$HOME/.config/functions_scripts.sh" ] && . "$HOME/.config/functions_scripts.sh"
[ -f "$HOME/.config/.secrets.sh" ] && . "$HOME/.config/.secrets.sh"

# Oh-My-Posh (commented out)
# --------------------------
#if command -v oh-my-posh &>/dev/null; then
#  eval "$(oh-my-posh init zsh --config ~/.config/.oh_my_posh.toml)"
#  eval "$(oh-my-posh completion zsh --config ~/.config/.oh_my_posh.toml)"
#else
#  echo "oh-my-posh is not installed"
#fi

# Load Fabric Bootstrap
# ---------------------
[ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ] && . "$HOME/.config/fabric/fabric-bootstrap.inc"

# macOS-specific Configurations
# -----------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Zinit Setup and Plugins
# -----------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not already installed (commented out)
#if [ ! -d "$ZINIT_HOME" ]; then
#  mkdir -p "$(dirname $ZINIT_HOME)"
#  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
#fi

# Oh My Zsh Plugins
# -----------------
plugins=(
  helm
  git
  zsh-interactive-cd
  ansible
  web-search
  podman
  aliases
  sudo
  colored-man-pages
  colorize # Syntax highlight in file contents
)
source $ZSH/oh-my-zsh.sh

# Zsh Syntax Highlighting and Autosuggestions
# -------------------------------------------
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Completion Styling
# ------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:*:cp:*' file-sort size
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# History Settings
# ----------------
HISTSIZE=5000
HISTFILE=~/.cache/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keyboard Shortcuts
# ------------------
bindkey '^[[1;5D' backward-word      # Ctrl+Left Arrow
bindkey '^[[1;5C' forward-word       # Ctrl+Right Arrow
bindkey '^A' beginning-of-line       # Ctrl+A
bindkey '^E' end-of-line             # Ctrl+E
bindkey '^P' up-line-or-history      # Ctrl+P
bindkey '^N' down-line-or-history    # Ctrl+N

# Powerlevel10k Prompt Configuration
# ----------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Dracula Theme Setup
# -------------------
if [ ! -d "$HOME/.vim/pack/themes/start/dracula" ]; then
  mkdir -p ~/.vim/pack/themes/start
  git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula
fi

# SSH Configuration
# -----------------
# This section is placed last to ensure that it doesn't interfere with the
# rest of the script if the user presses Ctrl+C during load.

# Define SSH keys
SSH_KEYS=(
  "id_rsa"
  "id_example"
)

# Start ssh-agent and add the keys
eval $(ssh-agent) >/dev/null
for key in "${SSH_KEYS[@]}"; do
  key_path="$HOME/.ssh/$key"
  [ -f "$key_path" ] && /bin/ssh-add "$key_path" >/dev/null
done

```

**The `.bash_profile` script is here, but for the newest go to the link:**

```bash
#~/.bash_profile
# System loads
# -------------
# Check if the current user is a member of the 'wheel' group
# Check if the user is not INSERT UR USER HERE
if [ "$USER" != "INSERT UR USER HERE" ]; then
    # Check for group membership in 'wheel' or 'sudo'
    if id $USER | grep -E 'wheel|sudo' &>/dev/null; then
        export TMOUT=1800 # Set timeout to 30 minutes for users in wheel or sudo groups
    else
        export TMOUT=3600 # Set timeout to 60 minutes for other users
    fi
fi

# Enable Vim configuration from .config directory if it exists.
# This block ensures that Vim uses the configuration from the .config/vim directory.
# It checks if the vimrc file exists before sourcing it.
if [[ -r "$HOME/.config/vim/vimrc" ]]; then
  export VIMINIT='source $HOME/.config/vim/vimrc'
fi

# if running bash
# Source .bashrc and .profile if they exist
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
[ -f "$HOME/.config/.shell_functions.sh" ] && . "$HOME/.config/.shell_functions.sh"
[ -f "$HOME/.config/.secrets.sh" ] && . "$HOME/.config/.secrets.sh"

# Variables
# ---------
# List of directories to potentially add to PATH
directories=("$HOME/bin" "$HOME/.local/bin" "/usr/local/bin")

# Define a list of your SSH keys
SSH_KEYS=("id_rsa" "id_rsa_example2")

# Initialize an array to hold the additional paths
additional_paths=()

# Loop through each directory and add it to the array if it exists
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        additional_paths+=("$dir")
    fi
done

# Add the additional paths to the PATH environment variable
for path in "${additional_paths[@]}"; do
    PATH="$PATH:$path"
done

# Export the updated PATH
export PATH

# Set the terminal colors
# -----------------------
# Check if the hostname starts with "prod-"
# https://robotmoon.com/bash-prompt-generator/
# https://ezprompt.net/
# Check if the hostname starts with "prod-"
if [[ "$HOSTNAME" == prod-* ]]; then
    # If the user is root, set the PS1 prompt with red username and yellow hostname
    if [[ "$USER" == "root" ]]; then
        export PS1="\[$(tput setaf 9)\]\u\[$(tput setaf 9)\]@\[$(tput setaf 9)\]\h\[$(tput setaf 7)\]:\w\[$(tput sgr0)\]$ "
    else
        # If the user is not root, set the PS1 prompt with default username and yellow hostname
        export PS1="\[$(tput setaf 15)\]\u\[$(tput setaf 9)\]@\[$(tput setaf 9)\]\h\[
$(tput setaf 15)\]:\w\[$(tput sgr0)\]$ "
    fi
fi

# Check if oh-my-posh is installed
# --------------------------------
# https://ohmyposh.dev/docs/installation/linux
if command -v oh-my-posh &>/dev/null; then
    # Initialize oh-my-posh with the specified configuration file
    eval "$(oh-my-posh init bash --config ~/.config/.oh_my_posh.toml)"
    eval $(oh-my-posh completion bash --config ~/.config/.oh_my_posh.toml)
else
    echo "oh-my-posh is not installed"
fi

# SSH
# ----

# Startigng ssh agent and adding the id_rsa
eval $(ssh-agent) >/dev/null

# Loop through each key and add it if it exists
for key in "${SSH_KEYS[@]}"; do
    key_path="$HOME/.ssh/$key"
    if [ -f "$key_path" ]; then
        ssh-add "$key_path" 1>/dev/null
    fi
done

 if [ -f "~/.config/fabric/fabric-bootstrap.inc" ]; then . "~/.config/fabric/fabric-bootstrap.inc"; fi

```

**The `~/.config/.shell_functions.sh` script:**

```bash
#!/bin/bash
# =====================================================
# Shell Utility Functions and Aliases for Terminal Productivity
# =====================================================

# -----------------------------------------------------
# Terminal Improvements
# -----------------------------------------------------

# Directory Navigation Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias -- -='cd -'

# Terminal Control Alias
alias c='clear'

# -----------------------------------------------------
# Miscellaneous Aliases
# -----------------------------------------------------
alias psg='ps aux | grep -v grep | grep -i'
alias df='df -h'
alias du='du -h -c'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tolower="tr '[:upper:]' '[:lower:]'"

# -----------------------------------------------------
# Ansible Aliases
# -----------------------------------------------------
alias a='ansible'
alias aconf='ansible-config'
alias acon='ansible-console'
alias aver='ansible-version'
alias arinit='ansible-role-init'
alias aplaybook='ansible-playbook'
alias ainv='ansible-inventory'
alias adoc='ansible-doc'
alias agal='ansible-galaxy'
alias apull='ansible-pull'
alias aval='ansible-vault'
alias ahelp='ansible-help'

# -----------------------------------------------------
# Git Aliases
# -----------------------------------------------------
alias gco='git checkout'
alias gaa='git add --all'
alias gcmsg='git commit --message'
alias gcam='git commit --all --message'
alias gfp='git fetch --prune'

# -----------------------------------------------------
# Reload Configuration Alias
# -----------------------------------------------------
alias resource='if [ "$SHELL" = "/bin/bash" ]; then source ~/.bash_profile; elif [ "$SHELL" = "/bin/zsh" ]; then source ~/.zshrc; fi'

# -----------------------------------------------------
# ls Command Aliases
# -----------------------------------------------------
alias ll='ls -alhZ'
alias llr='ls -alhr'
alias lls='ls -alhS'
alias llsr='ls -alhSr'
alias lld='ls -alht'
alias lldr='ls -alhtr'
alias lldc='ls -alhtU'
alias lldcr='ls -alhtUr'
alias ctree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# -----------------------------------------------------
# JSON Prettifier Alias
# -----------------------------------------------------
alias json='python -m json.tool'

# -----------------------------------------------------
# SSH Aliases
# -----------------------------------------------------
alias pssh='ssh -l "$($SSH_USER)" -o PreferredAuthentications=password -o PubkeyAuthentication=no'

# -----------------------------------------------------
# Clipboard Aliases (Linux)
# -----------------------------------------------------
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# -----------------------------------------------------
# Enable Color Support for ls and Related Commands
# -----------------------------------------------------
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

# -----------------------------------------------------
# Add less Alias with Color Support
# -----------------------------------------------------
alias less='less -R'

# -----------------------------------------------------
# Networking Aliases
# -----------------------------------------------------
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias netCons='lsof -i'
alias flushDNS='dscacheutil -flushcache'
alias lsock='sudo /usr/sbin/lsof -i -P'

# -----------------------------------------------------
# Fabric Aliases
# -----------------------------------------------------
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then
    . "$HOME/.config/fabric/fabric-bootstrap.inc"
fi

# -----------------------------------------------------
# Safety Aliases (Require Confirmation Before Overwriting)
# -----------------------------------------------------
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# -----------------------------------------------------
# Windows-Specific Aliases (for WSL)
# -----------------------------------------------------
if grep -q microsoft /proc/version; then
    alias explorer="explorer.exe ."
    alias vs='code .'
fi

# =====================================================
# Functions
# =====================================================

# -----------------------------------------------------
# Function to Extract Various Types of Compressed Files
# -----------------------------------------------------
function extract() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Usage: extract <file>\n"
        printf "Extract various types of compressed files.\n"
        printf "Supported file types:\n"
        printf "  *.tar.bz2, *.tar.gz, *.bz2, *.rar, *.gz\n"
        printf "  *.tar, *.tbz2, *.tgz, *.zip, *.Z, *.7z, *.ztd\n"
        return 0
    fi

    if [[ ! -f $1 ]]; then
        printf "Error: '%s' is not a valid file\n" "$1" >&2
        return 1
    fi

    case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar e $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *.ztd) tar --use-compress-program=unzstd -xvf $1 ;;
        *) 
            printf "Error: '%s' cannot be extracted via extract()\n" "$1" >&2
            return 2
            ;;
    esac
}

# -----------------------------------------------------
# Function to Display Data Usage
# -----------------------------------------------------
function data_usage() {
    du -sh --exclude='/proc/*' --exclude='/tmp/*' --exclude='/var/*' /* 2>/dev/null | sort -hr
}

# -----------------------------------------------------
# Function to Connect via SSH with Password Authentication
# -----------------------------------------------------
function pssh() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Usage: pssh [user] <host>\n"
        printf "Connect via SSH with password authentication.\n"
        printf "Options:\n"
        printf "  user    Optional. Username to connect with. Default is 'root'.\n"
        printf "  host    Required. Host to connect to.\n"
        return 0
    fi

    local user="${1:-root}"
    shift
    ssh -l "$user" -o PreferredAuthentications=password -o PubkeyAuthentication=no "$@"
}

# -----------------------------------------------------
# Function to Connect via SSH Using a Specified SSH Key
# -----------------------------------------------------
function issh() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Usage: issh [user] <host>\n"
        printf "Connect via SSH using a specified SSH key.\n"
        printf "Options:\n"
        printf "  user    Optional. Username to connect with. Default is 'root'.\n"
        printf "  host    Required. Host to connect to.\n"
        return 0
    fi

    local user="${1:-root}"
    shift
    ssh -l "$user" -i ~/.ssh/id_rsa_ssh_access "$@"
}

# -----------------------------------------------------
# Function to Check if a Process is Running
# -----------------------------------------------------
function check_process() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Usage: check_process <process_name>\n"
        printf "Check if a process is running.\n"
        printf "Options:\n"
        printf "  process_name   Required. The name of the process to check.\n"
        return 0
    fi

    local process_name="$1"

    if [[ -z "$process_name" ]]; then
        printf "Error: Process name must be specified.\n" >&2
        return 1
    fi

    if pgrep "$process_name" >/dev/null; then
        printf "Process '%s' is running.\n" "$process_name"
    else
        printf "Process '%s' is not running.\n" "$process_name"
    fi
}

# -----------------------------------------------------
# Function to Convert Markdown to PDF
# -----------------------------------------------------
function md2pdf() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Usage: md2pdf <input_file> <output_file>\n"
        printf "Convert a Markdown file to PDF using pandoc.\n"
        printf "Options:\n"
        printf "  input_file   Required. The Markdown file to convert.\n"
        printf "  output_file  Required. The name of the output PDF file.\n"
        return 0
    fi

    local input_file="$1"
    local output_file="$2"

    if [[ -z "$input_file" || -z "$output_fileHere's the continuation of the `md2pdf` function:

```bash
    if [[ -z "$input_file" || -z "$output_file" ]]; then
        printf "Error: Both input and output files must be specified.\n" >&2
        return 1
    fi

    if [[ ! -f "$input_file" ]]; then
        printf "Error: Input file '%s' does not exist.\n" "$input_file" >&2
        return 1
    fi

    pandoc "$input_file" -o "$output_file"

    if [[ $? -eq 0 ]]; then
        printf "PDF created successfully: %s\n" "$output_file"
    else
        printf "Error creating PDF.\n" >&2
        return 1
    fi
}

# -----------------------------------------------------
# Function to Show the Top 10 Largest Files in a Directory
# -----------------------------------------------------
function largest_files() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Usage: largest_files <directory> [count]\n"
        printf "Show the top largest files in a directory.\n"
        printf "Options:\n"
        printf "  directory   Required. The directory to search.\n"
        printf "  count       Optional. Number of files to display. Default is 10.\n"
        return 0
    fi

    local directory="$1"
    local count="${2:-10}"

    if [[ -z "$directory" ]]; then
        printf "Error: Directory must be specified.\n" >&2
        return 1
    fi

    if [[ ! -d "$directory" ]]; then
        printf "Error: '%s' is not a valid directory.\n" "$directory" >&2
        return 1
    fi

    find "$directory" -type f -exec du -h {} + | sort -rh | head -n "$count"
}


```

**The `~/.config/.secrets.sh` script:**

```bash
# EXPORTS
# -------
export SAT_USERNAME="<username>"
export SAT_PASSWORD="<pass>"
export AUTOMATIONHUB_API_KEY="<apikey>"
export AUTOMATIONHUB_SERVER="https://automationhub.ebdruplab.dk/api/galaxy/content/staging/"
export SSH_USER="<ssh_user>"
# Fabric Exports
# ---------------
# Need ollama remote or local - https://www.ollama.com/
# Need fabric - https://github.com/danielmiessler/fabric
if command -v fabric &>/dev/null; then
    export OPENAI_API_KEY="NULL"
    export DEFAULT_MODEL="phi3:mini"
    export OPENAI_BASE_URL=http://localhost:11434/api
fi

```

**The `~/.gitconfig` script:**
This makes you able to have multiple gitconfigs that loads different users for eaith of your repos.
```bash
[include]
    path = ~/.config/.gitconfig/.gitconfig-default
    
[includeIf "gitdir:~/git/business/"]
    path = ~/.config/.gitconfig/.gitconfig-business

[includeIf "gitdir:~/git/ebdruplab/"]
    path = ~/.config/.gitconfig/.gitconfig-personal

```
example **~/.config/.gitconfig/.gitconfig-default** 
```
[user]
    email = USER@users.noreply.github.com
    name = NAME
    username = username
```
Can add a business also so the user is different for that.

**Then to set correct file ownership:**
```bash
chmod 0700 .config .config/.bash_private .config/.bash_public .bash_profile
chown $USER:$USER .config .config/.bash_private .config/.bash_public .bash_profile
```
