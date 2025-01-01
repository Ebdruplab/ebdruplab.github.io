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

## Core concepts

### Ansible Helper script
see [Ansible Helper Scripts](../../../posts/01-ansible/ansible_scripts/Ansible_helper_scripts.md) for a custom script on how I will init a Ansible Repository.

### Playbook Execution order

Execution order is:

1. pre_tasks
2. roles
3. tasks
4. post_tasks

A playbook file can be composed of one or more `plays`.


## Tips and tricks

### Ansible Inventory Vaulted files (AAP2 and CMD)

An inventory on the command line can contain `ansible-vault` passwords in either `group_vars`, `host_vars` or in `vars files`, only the `vars files` is supported in Ansible Automation Platform 2 (AAP2).  
Here is how to setup `vaulted/encrypted` files for use with bot the Ansible Core (command line) or AAP2.  

#### Example setup

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

### Assertions for Roles
When creating roles/collections/playbooks it might be beneficial to have something that checks if the variable used in the play are present.  
Here is an example on this:
```yaml
- name: 'Assert that required variables are defined'
  ansible.builtin.assert:
    that:
      - ebdruplab_rolename_service_name is defined
    fail_msg: "Required variables are not all defined. Please check them"

- name: 'Example to check for sub items in a variable'
  ansible.builtin.assert:
    that:
      - ebdruplab_rolename_subvar.script_location is defined
    fail_msg: "ebdruplab_rolename_subvar is not correctly defined. Ensure script_location are set."

- name: 'Example on check if supported OS is used'
  ansible.builtin.assert:
    that:
      - ansible_os_family in ['RedHat', 'Debian']
    fail_msg: "This role only supports Debian or RedHat OS families."
```

Example on loading this assert.yml in the main.yml file (roles specific):
```yaml
- name: 'Import assert.yml'
  ansible.builtin.include_tasks: assert.yml
  ```

### Jinja2 Templating Cheat Sheet for Ansible

#### 1. **Iterating Over a List**

**Example**: Generating a list of patches from doing patches, this is from my patch playbook

```jinja
<ul>
        {% if hostvars[linux_host].patchingresult is defined and hostvars[linux_host].patchingresult != 'Compliant' %}
        {% for line in
        hostvars[linux_host].patchingresult %}
        <li> {{ line }} </li>
        {% endfor %}
        {% elif
        hostvars[linux_host].patchingresultdnf.changed|default("false", true) ==
        true %}
        {% for packagename in
        hostvars[linux_host].patchingresultdnf.results|sort %}
        <li> {{ packagename }} </li>
        {% endfor %}
        {% elif hostvars[linux_host].patchingresultdnf.changed|default("false",
        true)
        == true %}
        <li> Patching Failed </li>
        {% elif hostvars[linux_host].patchingresult.changed |default("false",
        true) == true %}
        <li> Patching Failed </li>
        {% else %}
        <li> Compliant </li>
        {% endif %}
</ul>
```

**Practical Use in Ansible**:
Its used to generate a HTML report of patched machines. The variables are saved from the different results within the playbook example:

```yaml
- name: 'Upgrade all packages (dnf)'
  ansible.builtin.dnf:
    name: '*'
    state: latest
    exclude: "{{ patch_management_exclude_packages }}"
    update_only: true
  when: ansible_pkg_mgr == "dnf"
  become: true
  register: patchingresultdnf
```
Then there is something for generating the report. But that isn't included in this example.

#### 2. **Using Default Values**

**Example**: Ensuring a default value for optional configuration parameters.

```jinja
database:
  host: {{ db_host | default('localhost') }}
  port: {{ db_port | default(3306) }}
  user: {{ db_user | default('root') }}
```

**Practical Use in Ansible**:
```yaml
db_host: mydb.example.com
```

**Rendered Output**:
```yaml
database:
  host: mydb.example.com
  port: 3306
  user: root
```


#### 3. **Conditionals**

**Example**: Coditional items for a config file (keepalived)

```jinja
    {% if ebdruplab_keepalived_unicast %}
        {% if ebdruplab_keepalived_config['keepalived_state'] == 'BACKUP' %}
        unicast_src_ip {{ ebdruplab_keepalived_backup_ip }}
        unicast_peer {
            {{ ebdruplab_keepalived_primary_ip }}
        }
        {% elif ebdruplab_keepalived_config['keepalived_state'] == 'MASTER' %}
        unicast_src_ip {{ ebdruplab_keepalived_primary_ip }}
        unicast_peer {
            {{ ebdruplab_keepalived_backup_ip }}
        }
        {% endif %}
    {% endif %}
```

#### 4. **Combining Variables Dynamically**

**Example**: Concatenating variables to form file paths.

```jinja
log_path: {{ log_dir }}/{{ service_name }}.log
```

**Practical Use in Ansible**:
Can be used in a variaty of ways e.g within a task or maybe a jinja templating for a script?  
I have also used it for creating firewall rules.
```yaml
log_dir: /var/log
service_name: httpd
```

**Rendered Output**:
```yaml
log_path: /var/log/httpd.log
```
