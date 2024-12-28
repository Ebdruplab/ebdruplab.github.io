---
title: "The Ultimate Guide to Writing Better Ansible Code"
weight: 6
draft: false
description: "Discover actionable tips and best practices to elevate your Ansible skills. From managing inventory and securing vaulted secrets to optimizing variables, tags, and Jinja templating, this guide covers everything you need to write cleaner, more efficient, and maintainable Ansible code. Perfect for anyone looking to enhance their playbooks and streamline automation workflows, whether you're using Ansible Core or the Ansible Automation Platform"
slug: "ansible_automation"
#summary:
tags: ["ansible", "inventory", "AAP2", "Commandline"]
date: 2024-12-25
#showSummary: true
---

In this post I will try to give you some of those tips I have for making better Ansible Code. It is meant as a *look up* or *cheat sheet* kind of thing. So you (and Myself) can find tips, examples, and good idears on how to write Ansible Code.
At the right site on this post you can find diffrent sections, you can also just `ctrl+f`to search for something, e.g vault or jinja.


## Ansible Inventory Vaulted files (AAP2 and CMD)

An inventory on the command line can contain `ansible-vault` passwords in either `group_vars`, `host_vars` or in `vars files`, only the `vars files` is supported in Ansible Automation Platform 2 (AAP2).  
Here is how to setup `vaulted/encrypted` files for use with bot the Ansible Core (command line) or AAP2.  

### Example setup

**Inventory file: Write in `inventories/prd/prd.ini`:**
```ini
[appservers]
appsrvvm01prd.ebdruplab.dk
appsrvvm02prd.ebdruplab.dk
```

**Write in `inventories/prd/group_vars/appservers.yml`:**
```yaml
target_env: prd
```

**Write in `vars/prd/vault.yml`:**
In Real life you need to `ansible-vault` this file using command:  
`ansible-vault encrypt vars/prd/vault.yml`
```yaml
app_name_secret: "my_app_prod"
app_secret: "08v09180n18v12n830"
```

**Playbook:**
```yaml
- name: Example Playbook vaulted files
  hosts: "appservers"
  gather_facts: false
  vars_files:
    - vars/{{ target_env }}/vault.yml
  tasks:
    - name: Debug environment variables
      ansible.builtin.debug:
        msg:
          - "App Name: {{ app_name }}"
          - "Database Host: {{ db_host }}"
```

This setup loads the `target_env` from the `group` `appservers`, and then using this to load the vaulted files in `vars` using the `vars_files`.

