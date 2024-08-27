---
Title: Setting Up Your Own Password Vault with Pass and GitHub  
Author: Kristian  
Date: 2025-08-27  
Weight: 12  
Description: Learn how to set up your own secure password manager using Pass, GPG, and GitHub. This guide includes everything from generating GPG keys to configuring auto-loading of your key in Ubuntu.  
Slug: password-vault  
Tags: ["guide", "password_manager", "tools"]
---

## Introduction

Passwords are an essential part of digital life, and managing them securely is a critical responsibility. Using an open-source password manager like `pass` in conjunction with GPG (GNU Privacy Guard) and GitHub gives you both security and flexibility. In this guide, we will walk through setting up a password vault using `pass`, GPG encryption, and syncing with a GitHub repository for backup. Additionally, we’ll show you how to auto-load your GPG key upon login, streamlining your workflow.

## Step 1: Installing Pass and Dependencies

To start, install `pass` and the necessary dependencies on your Ubuntu system. This will install the password manager `pass`, which uses GPG for encryption.

- Install the necessary software by executing the command:  
  `sudo apt install pass`

## Step 2: Generating Your GPG Key

Next, you need to create a GPG key that will be used to encrypt your passwords. Run the following command to generate a new key:

- To generate your GPG key, execute the command:  
  `gpg --full-generate-key`

You will be prompted to select the type of key (RSA and RSA recommended), key size (4096 bits for strong encryption), and validity period (choose according to your preference, but setting it to 0 makes it valid indefinitely). After this, you’ll be asked for your name, email, comment, and a passphrase to secure the key. Once done, your GPG key will be created.

- Confirm the key was created successfully by executing:  
  `gpg --list-keys`

Make note of the **uid** you chose for the key as you'll need it to initialize your password store.

## Step 3: Initializing Your Password Store

Now that you have your GPG key, you can initialize your password store.

- Initialize the password store with the following command:  
  `pass init [GPG UID]`

This creates a directory called `~/.password-store` where all of your passwords will be securely stored.

## Step 4: Connecting Your Password Store to a GitHub Repository

To keep your password store safe and synced across multiple devices, you can push it to a GitHub repository. Start by creating a new GitHub repository, then follow these steps:

- Create a new local Git repository in the password store directory:  
  `pass git init`

- Connect your local repository to the remote GitHub repository:  
  `pass git remote add origin [GIT URL]`

- Fetch and prepare the remote repository:  
  `cd ~/.password-store`  
  `git fetch -p`  
  `git branch password-store`

- Push the password store to GitHub:  
  `git push origin password-store`

Every time you add or modify passwords, `pass` will automatically create a new local commit. Use the following command to push those changes to GitHub:

- Push the changes to the remote repository:  
  `pass git push`

## Step 5: Adding Passwords to Your Store

To add a new password to your store:

- Use the command:  
  `pass insert [OPTIONAL DIR]/[FILENAME]`

This will prompt you to enter a password and save it securely. You can retrieve this password later by running:

- Retrieve the password with:  
  `pass [OPTIONAL DIR]/[FILENAME]`

## Step 6: Using the Password Store on Multiple Machines

If you need to use your password store on multiple machines, you’ll need to export and import your GPG key. The GPG ID is either the email associated with the key or the id e.x:
```
pub   rsa4096 2022-01-01 [SC] [expires: 2024-08-27]
      ABCDEF1234567890ABCDEF1234567890ABCDEF12
uid           [ultimate] Kristian <kristian@ebdruplab.dk>
sub   rsa4096 2022-01-01 [E] [expires: 2024-08-27]
```
gpg id is either `ABCDEF1234567890ABCDEF1234567890ABCDEF12` or `kristian@ebdruplab.dk`

On your primary machine:

- Export the public key:  
  `gpg --export [GPG ID] > public.key`

- Export the private key:  
  `gpg --export-secret-key [GPG ID] > private.key`

Copy these files to the secondary machine(s) where you want to use your password store.

On the secondary machine(s):

- Import the keys with the following commands:  
  `gpg --import public.key`  
  `gpg --import private.key`

- Set the trust level for the imported key:  
  `gpg --edit-key [GPG ID]`  
  `cd gpg> trust`  
  Follow the prompts to set the appropriate trust level, then quit.


## Conclusion

By following these steps, you’ll have a fully encrypted password vault that’s synced securely with GitHub and auto-loads your GPG key for smooth operation. With a secure vault in place, you can manage your passwords across devices with confidence, knowing that your sensitive data is encrypted and protected.


