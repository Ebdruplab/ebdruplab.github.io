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
