---
title: OpenSource AI Server
author: Kristian
weight: 14
date: 2024-05-05
categories: [Guide, OpenSource]
tags: [it, AI]
---

# OpenSource AI Server
In this blog post i will be showing you how to setup an AI server that looks a bit like ChatGPT.
It uses OpenSource projects like:
1. [ollama](https://ollama.com/download)
2. [Open-webui](https://github.com/open-webui/open-webui)
3. Diffrent opensource models

> NOTE: you can also install RHEL 8 on wsl but i will not provide a guide as it is writen [here](https://developers.redhat.com/articles/2023/11/15/create-customized-rhel-images-wsl-environment#procedure)

> Note: Instructlab can be installed for better working with LLM's [instructlab: guide](https://github.com/instructlab/instructlab/blob/main/README.md#to-install-with-nvidia-cuda) I did a install nvidia cuda and then there is the ilab command (read documentation)

## Installation

I'll install on wsl as this is just my home test server. But this should work on any linux host. First i spin up my wsl instance, and then I do the following.

### Install ollama
1. Install ollama `curl -fsSL https://ollama.com/install.sh | sh` check the script before running!
2. Start the ollama server:   

```shell
sudo systemctl enable ollama
sudo systemctl start ollama
```   
   
3. Open a new connection to the server in seperate window
4. pull a model (check available models here)[https://ollama.com/library]  
`ollama pull llama3`  


### Install docker and open-webui

**If yu want to use open-webui you need docker:**  

```shell
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add your user to the docker group
sudo usermod -a -G docker $USER
```  

**To run the web ui:**    
`docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name ebdruplab_open-webui --restart always ghcr.io/open-webui/open-webui:main`  

> to expose the webui if you are on wsl use netsh interface portproxy add v4tov4 listenport=80 listenaddress=YOUR_HOST_IP connectport=8080 connectaddress=127.0.0.1

#### Open-webui Model example

Here I will provide you with examples on how to tweak your robot to perform better on diffrent tasks

##### Ansible-Helper
Example model for ansible use:
Name: Ansible_helper  
Description: Helps Creating Ansible Code
llama3:latest or Codegemma:Latest:
```shell
FROM llama3:latest 
PARAMETER num_ctx 16384
SYSTEM """Ansible-Helper provides direct infomation on Ansible, Bash and python code.
The standard code is ansible but if the user specific ask for a bash or python code it is allowed to help. Python is mainly focussed in the cotext of asnible. 
Role and Goal: You are designed to assist me in creating Ansible playbooks, providing guidance and suggestions to ensure successful project setup and execution. Ansible-Helper are well-versed in a wide range of Ansible special variables and facts, which helps in managing and utilizing these elements effectively in your playbooks.
Constraints:
Module Usage: Ansible-Helper recommend using the package module instead of dnf, yum, or apt for package management to ensure a more universal approach.
Variable Naming: Ansible-Helper use snake-case for all variables.
Targeting Hosts: Ansible-Helper suggest using 'hosts: example' for simple and clear targeting in playbook examples.
File Content: Ansible-Helper use the template module for managing file content rather than direct file edits or using scripts.
Security and Best Practices: Ansible-Helper am programmed to avoid presenting scripts or configurations that deviate from secure and best-practice approaches.
Please use fully qualified collection names like ansible.builtin.yum instead of just yum.
If asked to generate code - Ansible-Helper DOES NOT EXPLAIN AND JUST OUTPUTS THE COMPLETED CODE while ensuring all requirements are met.
When providing a name to a task it represente what actually happens in the task, and it does to by setting '' arround no variables are allowed in the -name: 'HERE' part.
Ansible-Helper provides info on RHEL systems, and only change if the user ask to create a playbook, role or anything else targeting another os.
Guidelines:
Detailed Explanations: Ansible-Helper offer detailed explanations of scripts and configurations, providing context and insights into their structure and usage.
Testing Suggestions: Ansible-Helper provide suggestions for testing playbooks to ensure their functionality before full deployment.
Explanation Style: My responses are clear and understandable, tailored to users with varying levels of expertise in Ansible.
Use of Fully Qualified Collection Names: Ansible-Helper encourage the use of fully qualified collection names to avoid ambiguity and ensure clarity in playbook scripts.
Personalization and Tone: Ansible-Helper maintain a friendly and informative tone, making the automation and Ansible topics accessible and comprehensible to all users."""
```
img_for_the_bot:  
<img src="/assets/img/projects/ai/ansible-helper.webp" alt="Ansible-Helper">

# Install guide of instructlab
This is a mini guide that provides a more development approach. I will be showing you how to install instructlab on ubuntu. As the official guide only focus on RHEL.
Ilab is used to train models on an easier more non-dev way. Using yaml books.

```bash
sudo apt update
sudo apt install g++ gcc make python3-pip python3-dev python3-git
mkdir instructlab
cd instructlab
python3 -m venv --upgrade-deps venv
source venv/bin/activate
pip cache remove llama_cpp_python
# check offical documentation for this command for your specific needs
# I'll need nvidea cuda 
pip install git+https://github.com/instructlab/instructlab.git@stable --extra-index-url=https://download.pytorch.org/whl/cpu
```
You need to run `source venv/bin/activate` everytime you want to use ilab.  
also for bash completion you can put `eval "$(_ILAB_COMPLETE=bash_source ilab)"` insite your `.bash_profile` or `.bashrc` file  
  
Now you can use the `ilab` commands.

## Conclusion

In this blog post, we explored how to set up an AI server using OpenSource projects like Ollama, Open-webui, and different open-source models. We installed Ollama on a WSL instance and started the server, then pulled a model (LLaMa3) and used it to create Ansible code.  

We also installed Docker and Open-webui, which allows us to run the web UI and interact with the AI server. We ran an example model (Ansible_Helper) that provides direct information on Ansible, Bash, and Python code, helping users create playbooks and providing guidance and suggestions for successful project setup and execution.  

The key takeaways from this blog post are:  
1. Install Ollama: Use the script provided by Ollama to install the server on your WSL instance.
2. Start Ollama Server: Enable and start the Ollama server using systemd.
3. Pull a Model: Pull a model (e.g., LLaMa3) from the Ollama library to use for creating code.
4. Install Docker and Open-webui: Install Docker and Open-webui on your WSL instance to run the web UI and interact with the AI server.
5. un an Example Model: Run an example model (e.g., Ansible_Helper) that provides guidance and suggestions for creating Ansible playbooks.

Also a mini guide on how to install instructlab, something Red Hat is supporting.

This setup allows you to create an AI-powered server that can assist in automating tasks, such as creating Ansible code, and provides a foundation for building more advanced AI-powered automation tools.

