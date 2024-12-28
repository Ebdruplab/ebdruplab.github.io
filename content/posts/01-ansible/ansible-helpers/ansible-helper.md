---
title: "Ansible from Kristian"
weight: 6
draft: false
description: "Ansible helpers, and good to have items, for a enhancement for writing Ansible Playbooks. Assistance to Ansible Automation Platform 2"
slug: "ansible_automation"
#summary:
tags: ["ansible", "inventory", "AAP2", "Commandline"]
date: 2024-12-25
#showSummary: true
---

## Ansible Inventory (AAP2 and CMD)

A inventory on the command line can contain `ansible-vault` passwords, this can be either in `group_vars` or `host_vars`, this isn't supported within Ansible Automation Platform 2.  
Instead of using `group_vars` and `host_vars` we can use `vars files`. Thease can be loaded using `vars_files`.  

Inventory file: Write in `inventories/prd/prd.ini`
```ini
[appservers]
appsrvvm01prd.ebdruplab.dk
appsrvvm02prd.ebdruplab.dk
```

Write in `inventories/prd/group_vars/appservers.yml`
```yaml
target_env: prd
```

Write in `vars/prd/vault.yml`:
In Real life you need to `ansible-vault` this file
```yaml
app_name_secret: "my_app_prod"
app_secret: "08v09180n18v12n830"
```

Playbook:
```yaml
- name: Example Playbook
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

