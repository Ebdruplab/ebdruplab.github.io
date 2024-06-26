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
In this guide I will provide you with info on how i setup my .config and .bash_profile. I use it on a ubuntu, installed using wsl2.

## Setup
I use the following locations:
- .config/{.bash_public, .bash_private}
- .bash_profile, that loads my .bash_private, .bash_public and the standard items like .bashrc

The newest files are located at [dotfiles](https://github.com/Ebdruplab/dotfiles)

**Important** Remember to change mod to 0700 and to set the owner to `$USER`.

**The `.bash_profile` script is here, but for the newest go to the link:**

```bash
# File: .bash_profile
#~/.bash_profile
# System loads
# -------------
# if running bash
# Source .bashrc and .profile if they exist
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
[ -f "$HOME/.config/.bash_public" ] && . "$HOME/.config/.bash_public"
[ -f "$HOME/.config/.bash_private" ] && . "$HOME/.config/.bash_private"



# Variables
# ---------
# List of directories to potentially add to PATH
directories=("$HOME/bin" "$HOME/.local/bin" "/usr/local/bin" "$HOME/git/ebdruplab/ansible-shared/scripts")

# Define a list of your SSH keys
SSH_KEYS=("id_rsa_example1" "access_example" "idexample")

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


```

**The `.bash_public` script:**

```bash
# file: .bash_public
# Terminal Improvements
# ---------------------
# Setup
# Nice to have
alias cd_ebd='cd ~/git/ebdruplab'

# Then add to your .bash_profile
# Install using sudo apt install xsel
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Change strings
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tolower="tr '[:upper:]' '[:lower:]'"

# Source bash_profile
alias resource='source ~/.bash_profile'
# List files
alias ll='ls -alhZ'
# List files (reverse)
alias llr='ls -alhr'
# List files by size
alias lls='ls -alhS'

alias llsr='ls -alhSr'
# List files by date
alias lld='ls -alht'
# List files by date (reverse)
alias lldr='ls -alhtr'
# List files by date created
alias lldc='ls -alhtU'
# List files by date created (reverse)
alias lldcr='ls -alhtUr'
# List the file structure of the current directory
alias ctree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# NETWORKING
# -----------
# myip: Public facing IP Address
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
# netCons: Show all open TCP/IP sockets
alias netCons='lsof -i'
# flushDNS: Flush out the DNS Cache
alias flushDNS='dscacheutil -flushcache'
# lsock: Display open sockets
alias lsock='sudo /usr/sbin/lsof -i -P'

# Require confirmation before overwriting target files. This setting keeps me from deleting things I didn't expect to, etc
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Windows
# -------
if grep -q microsoft /proc/version; then
    alias explorer="explorer.exe ."
fi

# Functions
# -----------
# Git fast track alias
# Function to add, commit, and push changes to a Git repository
# Usage: cgitadd "commit message"
#
# Args:
#     commit message (str): The commit message describing the changes.
#
# Returns:
#     None
function cgitadd() {
    git add .
    git commit -m "$1"
    git push
}

# Display the current Git branch in your shell prompt
function parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Get a quick overview of the status of your Git repository
function gstatus() {
    git status -s
}

# Add all changes and commit them with a message
function gcommit() {
    git add -A && git commit -m "$*"
}

# Shows a concise git log
function glog() {
    git log --pretty=format:"%h - %an, %ar : %s"
}

# List all branches and then checkout to a selected one
function gcheckout() {
    git branch -a
    echo "Enter branch name:"
    read branch
    git checkout "$branch"
}

# Pull the latest changes with rebase
function gpull() {
    git pull --rebase
}

# Create and switch to a new branch
function gbranch() {
    git checkout -b "$*"
}

# Push a new branch to remote and set upstream
function gpushnew() {
    git push -u origin "$(git branch --show-current)"
}

# Delete local branches that have been merged into the current branch
function gclean() {
    git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
}

# Show git diff with word-level differences
function gdiff() {
    git diff --color-words "$*"
}

#  extract:  Extract most know archives with one command
function extract() {
    if [ -f $1 ]; then
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
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function data_usage() {
    du -sh --exclude='/proc/*' --exclude='/tmp/*' --exclude='/var/*' /* 2>/dev/null | sort -hr
}

# SSH Functions
function pssh() {
    local user=${1:-root}
    ssh -l "$user" -o PreferredAuthentications=password -o PubkeyAuthentication=no "${@:2}"
}

function issh() {
    local user=${1:-root}
    ssh -l "$user" -i ~/.ssh/example_key "${@:2}"
}
# Function
# --------
# Private Automation Hub
publish_collection() {
    if [[ -z "$1" ]]; then
        echo "You need to provide a collection archive file as an argument."
    else
          ansible-galaxy collection publish "$1" --api-key="$AUTOMATIONHUB_API_KEY" -s "$AUTOMATIONHUB_SERVER"
    fi
}
install_collection() {
    if [[ -z "$1" ]]; then
        echo "You need to provide a collection name as an argument."
        echo "Usage: install_collection namespace/collection_name [--force]"
    else
        if [[ "$2" == "--force" ]]; then
              ansible-galaxy collection install "$1" --api-key="$AUTOMATIONHUB_API_KEY" -s "https://<HUB_URL>/api/galaxy/content/<content_location>/" --force
        else
              ansible-galaxy collection install "$1" --api-key="$AUTOMATIONHUB_API_KEY" -s "https://<HUB_URL>/api/galaxy/"
        fi
    fi
}



```

**The `.bash_private` script:**

```bash
# file: .bash_private
# EXPORTS
# -------
export SAT_USERNAME=<USERNAME>
export AUTOMATIONHUB_API_KEY=<API_KEY>
export AUTOMATIONHUB_SERVER=<Hub_sever>
```

**Then to set correct file ownership:**
```bash
chmod 0700 .config .config/.bash_private .config/.bash_public .bash_profile
chown $USER:$USER .config .config/.bash_private .config/.bash_public .bash_profile
```
