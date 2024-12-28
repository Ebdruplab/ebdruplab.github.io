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

### Jinja2 Templating Cheat Sheet for Ansible

#### 1. **Iterating Over a List**

**Example**: Generating a list of users for a configuration file.

```jinja
{% for user in users %}
- Username: {{ user.name }}
  UID: {{ user.uid }}
  Shell: {{ user.shell | default('/bin/bash') }}
{% endfor %}
```

**Practical Use in Ansible**:
```yaml
users:
  - name: alice
    uid: 1001
    shell: /bin/zsh
  - name: bob
    uid: 1002
```

**Rendered Output**:
```yaml
- Username: alice
  UID: 1001
  Shell: /bin/zsh
- Username: bob
  UID: 1002
  Shell: /bin/bash
```



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

**Example**: Enabling SSL configuration based on a variable.

```jinja
{% if enable_ssl %}
ssl_certificate: {{ ssl_cert_path | default('/etc/ssl/cert.pem') }}
ssl_certificate_key: {{ ssl_key_path | default('/etc/ssl/key.pem') }}
{% else %}
# SSL is disabled
{% endif %}
```

**Practical Use in Ansible**:
```yaml
enable_ssl: true
ssl_cert_path: /etc/ssl/custom_cert.pem
```

**Rendered Output**:
```yaml
ssl_certificate: /etc/ssl/custom_cert.pem
ssl_certificate_key: /etc/ssl/key.pem
```



#### 4. **Rendering Complex Data**

**Example**: Iterating through nested dictionaries.

```jinja
{% for service, config in services.items() %}
- Service: {{ service }}
  State: {{ config.state }}
  Ports:
    {% for port in config.ports %}
    - {{ port }}
    {% endfor %}
{% endfor %}
```

**Practical Use in Ansible**:
```yaml
services:
  httpd:
    state: running
    ports: [80, 443]
  redis:
    state: stopped
    ports: [6379]
```

**Rendered Output**:
```yaml
- Service: httpd
  State: running
  Ports:
    - 80
    - 443
- Service: redis
  State: stopped
  Ports:
    - 6379
```

#### 5. **Combining Variables Dynamically**

**Example**: Concatenating variables to form file paths.

```jinja
log_path: {{ log_dir }}/{{ service_name }}.log
```

**Practical Use in Ansible**:
```yaml
log_dir: /var/log
service_name: httpd
```

**Rendered Output**:
```yaml
log_path: /var/log/httpd.log
```

#### 6. **Filters for Data Transformation**

**Example**: Converting a list to a comma-separated string.

```jinja
services: {{ service_list | join(', ') }}
```

**Practical Use in Ansible**:
```yaml
service_list:
  - httpd
  - redis
  - postgresql
```

**Rendered Output**:
```yaml
services: httpd, redis, postgresql
```

#### 7. **Checking Variable Existence**

**Example**: Safely handle undefined variables.

```jinja
{% if my_variable is defined %}
Variable is defined: {{ my_variable }}
{% else %}
Variable is not defined.
{% endif %}
```

**Practical Use in Ansible**:
```yaml
my_variable: "Hello, World!"
```

**Rendered Output**:
```yaml
Variable is defined: Hello, World!
```

#### 8. **Complex Conditionals**

**Example**: Dynamically choose configuration values.

```jinja
debug_mode: {{ 'enabled' if environment == 'development' else 'disabled' }}
```

**Practical Use in Ansible**:
```yaml
environment: production
```

**Rendered Output**:
```yaml
debug_mode: disabled
```

#### 9. **Loop with Index**

**Example**: Adding an index to looped items.

```jinja
{% for user in users %}
{{ user.name }}
{% endfor %}
```

**Practical Use in Ansible**:
```yaml
users:
  - name: alice
  - name: bob
```

**Rendered Output**:
```text
alice
bob
```

#### 10. **Condition in Loops**

**Example**: Filtering items within a loop.

```jinja
{% for user in users if user.is_admin %}
- Admin: {{ user.name }}
{% endfor %}
```

**Practical Use in Ansible**:
```yaml
users:
  - name: alice
    is_admin: true
  - name: bob
    is_admin: false
```

**Rendered Output**:
```yaml
- Admin: alice
```
