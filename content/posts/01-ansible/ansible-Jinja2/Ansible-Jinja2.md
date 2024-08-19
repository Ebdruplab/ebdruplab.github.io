---
title: "Ansible Jinja Helpers"
weight: 10
draft: false
description: "How to use jinja2 within ansible"
slug: "ansible"
tags: ["ansible", "jinja2", "Guide", "Notes"]
date: 2024-04-10
---

# Ansible Jinja2 Helpers

This post delves into the functionalities of Jinja2 templating, primarily for use with Ansible but also applicable in any language that supports Jinja2, like Python.

## Well Known Jinja2 Clauses

Easy to find and commonly used clauses:

```yaml
# Omits the variable if it does not exist, useful to prevent errors or undefined messages.
{{ Ifnovariableexistremoveme | default(omit) }}

# Sets the variable to 'null' if it does not exist, can be used to ensure output consistency.
{{ Ifnovariableexistwritenull | default('null') }}

# Defaults to another variable if the initial variable is undefined.
{{ Ifidontexistwriteanothervariable | default(othervar) }}

```

## Template .j2 file

1. Set a var in a jinja template based on host fact:

```yaml
mysql_max_connections: "{{ (ansible_memtotal_mb // 12) | int }}"
```

2. A If something is true clause, or just check for defined

```yaml
{% if mysql_slow_query_log_enabled %}
slow_query_log = 1
slow_query_log_file = {{ mysql_slow_query_log_file }}
long_query_time = {{ mysql_slow_query_time }}
{% endif %}

# or if check it is there or not
# Ansible Jinja2 if variable is defined ( where variable is defined)
{% if example_variable is defined -%}
        example_variable is defined              
{% else -%}
        example_variable is not defined
{% endif %}
```

3. Jinja2 filters

```yaml
# Ansible Jinja2 for filters 
# min value    
{{ [1,2,3,4,5] | min }}

# max value
{{ [1,2,3,4,5] | max }}

 # unique [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
{{ [1, 1, 2, 2, 3, 3, 4, 4, 5, 5] | unique }}

 # difference [1, 2, 3, 4, 5] vs [2, 3, 4, 5]
{{ [1, 2, 3, 4, 5] | difference([2, 3, 4]) }}

 # random['rob', 'jane', 'freddy']
{{ ['rob', 'jane', 'freddy'] | random }}
```

4. A template.j2 with a lot of diffrent options

```yaml
# Jinja2 template if statement

{% if ansible_hostname == "examplehost2" -%}
    This is {{ ansible_hostname }} host
{% endif %}

# Ansible Jinja2 if elif statement

{% if ansible_hostname == "examplehost2" -%}
     This is {{ ansible_hostname }} host
{% elif ansible_hostname == "examplehost3" -%}
     This is {{ ansible_hostname }} host with modifications
{% endif %}

# Ansible Jinja2 if elif else statement

{% if ansible_hostname == "examplehost2" -%}
      This is {{ ansible_hostname }} host
{% elif ansible_hostname == "examplehost3" -%}
      This is {{ ansible_hostname }}  host with modifications
{% else -%}
      This is default {{ ansible_hostname }} host
{% endif %}

# Ansible Jinja2 if variable is defined ( where variable is not defined)

{% if example_variable is defined -%}
      example_variable is defined
{% else -%}
      example_variable is not defined
{% endif %}

# Ansible Jinja2 if variable is defined ( where variable is defined)

{% set example_variable = 'defined' -%}
     {% if example_variable is defined -%}
          example_variable is defined
     {% else -%}
          example_variable is not defined
{% endif %}

# Ansible Jinja2 for loop

{% for entry in ansible_all_ipv4_addresses -%}
     IP Address entry {{ loop.index }} - {{ entry }}
{% endfor %}

# Ansible Jinja2 for range

{% for entry in range(1, 11) -%}
     {{ entry }}
{% endfor %}

# Ansible Jinja2 for range , reversed(simulate while greater 5)

{% for entry in range(10, 0, -1) -%}
   {% if entry == 5 -%}
      {% break %}
   {% endif -%}
   {{ entry }}
{% endfor %}

# Ansible Jinja2 for range , reversed(continue if odd)

{% for entry in range(10, 0, -1) -%}
   {% if entry is odd -%}
      {% continue %}
   {% endif -%}
   {{ entry }}
{% endfor %}
```

## Lesser Known Features
More obscure yet highly useful features for complex data handling:

```yaml
# Example variable structure with nested values
somenestedvar:
    var1:
    - value1
    - value2
    var2:
    - value2
    - value3

# Debug task to output a unique list of all values in 'somenestedvar'
debug:
    msg: "{{ somenestedvar.values() | flatten | unique }}"
```

This configuration shows how to extract and manipulate lists from nested data structures in Ansible using Jinja2, providing a powerful way to handle dynamic data.
