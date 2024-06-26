---
title: "Ansible Best Practices and help"
weight: 5
draft: false
description: "Ansible best practices from Kristian's perspective. Corrulated from information gathered from a lot of different projects"
slug: "ansible"
#summary:
tags: ["ansible", "scripts", "automation", "Notes"]
date: 2024-04-14
#showSummary: true
---
# Ansible Practices and help
This file should provide you with help on how to use my Ansible init scripts. Also I will provide you with info on my best practices, knowhows and nice to have stuff. On your automation journey.

## Ansible Repository Initialization Guide

This guide provides detailed instructions on how to use the `initialize_ansible_repo.sh` script to set up a new Ansible repository with a predefined directory structure and configuration. It also includes guidelines for developing within the playbook.

### About the Script

The `initialize_ansible_repo.sh` script is designed to streamline the setup of a new Ansible repository. It automatically creates a set of directories and files that are commonly used in Ansible projects, including roles, inventories, collections, and variable directories. Additionally, the script generates an Ansible configuration file and a vault password file with a random password.

### Repository Structure

Upon execution, the script creates the following directory structure in the specified repository path:

- `roles/`: Directory for Ansible roles.
- `inventories/`: Directory for inventory files.
- `collections/`: Directory for Ansible collections.
- `vars/`: Directory for variable files.
- `scripts/`: Directory for storing scripts, including the initialization scripts.

The script also creates several configuration files:

- `ansible.cfg`: An Ansible configuration file with predefined settings.
- `requirements.yml` files in both the `roles` and `collections` directories for managing dependencies.
- `.gitignore`: Configured to exclude specific directories from version control while keeping their requirements files.
- Vault password file: Located in `~/.vault_keys/`, used for Ansible Vault operations.

### How to Use the Script

To set up your new Ansible repository using the `initialize_ansible_repo.sh` script, follow these steps:

1. **Download the Script**
   - Download the script from the official repository using this command:
   
     ```bash
     wget https://raw.githubusercontent.com/Ebdruplab/ansible-shared/main/scripts/initialize_ansible_repo.sh
     ```

2. **Make the Script Executable**
   - Change the permissions of the script to make it executable with the following command:
   
     ```bash
     chmod +x initialize_ansible_repo.sh
     ```

3. **Execute the Script**
   - Run the script by specifying the directory where you want to initialize your new Ansible repository:
   
     ```bash
     ./initialize_ansible_repo.sh ~/path/to/your/new/ansible-repo
     ```
   
   This will create the necessary directory structure, configuration files, and initialization scripts as described in the earlier sections.

### Development Practices

You can on your development bench use the init_dev.sh, this will export the vault password file. NOTE: you offcourse need to add a value to this file to use it.
Standard location from script is: `~/.vault_keys/repo-name`
I would recommend using a minimum of 32 charactes for the vault password as it isn't really something you want to be cracked.

## Ansible Collections

This will guide you in creating collections. I will provide you with info from my own expirence. This means that what I provide you with is mainly something used to create a collection for a firm. I will be calling the firm in my guide ebdruplab, but it could be what ever company.
I will also provide you with information on how those created collections can be pushed to Private Automationhub. I will also make a snippet on how you can push code to here with a API key.

I would suggets creating a github or what ever git software you use. e.g `ansible_collection_ebdruplab`. If it should be available at ansible galaxy. You would need to make it public.

THe collection I have and will keep on developing on is at [ansible_collection_ebdruplab](https://github.com/Ebdruplab/ansible_collection_ebdruplablab)

### Collection Creation

Here I provide you with info on how you could generate your own ansible collection. A collection consist of 3 things:

- <namespace> e.g `ebdruplab`
- <collection_name> e.g `linux`, `windows` or something else
- <role_name> wihin each `namespace.collection_name` you can generate a role `ansible-galaxy role init podman_stack`

```bash
ansible-galaxy collection init ebdruplab.linux
cd ebdruplab/linux/roles
ansible-galaxy role init podman_stack
# You can then provide info for the role and for the collection in the diffrent readme files.
vi README.md
# To build the collection use
ansible-galaxy collection build
# This should be done in the dir with the build .yml file
```

### Bash Scripts
To make it a bit easier to push collection to private automation hub you can use the following bash scripts.
Thease are for publishing collection, and if you want to install from your own automation platform.

```bash
# Functions for managing collections in a Private Automation Hub

# Publish a collection to the Automation Hub
publish_collection() {
    if [[ -z "$1" ]]; then
        echo "Error: Missing argument."
        echo "Usage: publish_collection <collection_archive>"
        return 1  # Return with error
    fi
    ansible-galaxy collection publish "$1" --api-key="$AUTOMATIONHUB_API_KEY" -s "$AUTOMATIONHUB_SERVER"
    echo "Collection published successfully."
}

# Install a collection from the Automation Hub
install_collection() {
    if [[ -z "$1" ]]; then
        echo "Error: Missing argument."
        echo "Usage: install_collection namespace/collection_name [options]"
        return 1  # Return with error
    fi

    ansible-galaxy collection install "$1" --api-key="$AUTOMATIONHUB_API_KEY" -s "$AUTOMATIONHUB_SERVER"
    echo "Collection installed successfully."
}
```

And for the export list:

```bash
# Export for ansible scripts
export AUTOMATIONHUB_API_KEY=<API_KEY>
export AUTOMATIONHUB_SERVER=https://<Automation_Hub>
```

I will not explain how to load these on login. But it include using your `.bash_profile`, and for my own example I use the `.config` with some `.bash_private` and `.bash_public` files.
