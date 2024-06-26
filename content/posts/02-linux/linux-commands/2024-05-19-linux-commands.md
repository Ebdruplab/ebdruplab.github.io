---
title: Linux Cheat Sheets commands
weight: 25
draft: false
description: "This gives you information on diffrent linux commands"
author: Kristian
date: 2024-05-19
slug: "bash"
categories: ["cheat-sheet", "linux", "commands", "bash", "sql"]
---

# Linux Cheat Sheets commands
This contains different heloers for commands on a linux os.

## Unix Command-Line Utilities Cheat-Sheet

### Using Cron and placing crontab files

#### CRON Fields

| Field         | Allowed Values | Description                                         |
|---------------|----------------|-----------------------------------------------------|
| `MINUTE`      | 0-59           | Trigger every MINUTE minute(s)                      |
| `HOUR`        | 0-23           | Trigger every HOUR hour(s)                          |
| `DAY OF MONTH`| 1-31           | Trigger on specific DAY of the month                |
| `MONTH`       | 1-12           | Trigger in MONTH month(s)                           |
| `DAY OF WEEK` | 0-6 (Sun-Sat)  | Trigger on specific DAY OF WEEK, where Sunday = 0   |

#### Special Characters in CRON

| Special Character | Description                                       |
|-------------------|---------------------------------------------------|
| `*`               | Represents all possible values for the field     |
| `,`               | Separates items in a list                        |
| `-`               | Specifies a range of values                      |
| `/`               | Specifies increments                              |

#### CRON Expression Examples

| Cron Expression      | Description                                    |
|----------------------|------------------------------------------------|
| `* * * * *`          | Executes every minute                          |
| `0 * * * *`          | Executes on the hour every hour                |
| `0 0 * * *`          | Executes at midnight every day                 |
| `0 0 1 * *`          | Executes at midnight on the first of every month|
| `30 20 * * 6`        | Executes at 8:30 PM every Saturday             |
| `*/5 * * * *`        | Executes every five minutes                    |
| `0 0 8-10 * * *`     | Executes on the hour every hour from 8 AM to 10 AM |

#### Executing a Script and Redirecting Output to a Log File

```bash
0 5 * * * /path/to/script.sh >> /path/to/logfile.log 2>&1
```
This CRON job example runs a script located at /path/to/script.sh every day at 5 AM, appending both standard output and standard error to /path/to/logfile.log.

#### Common CRON Directories and Files

| Location/File           | Description                                           |
|-------------------------|-------------------------------------------------------|
| `/etc/crontab`          | System-wide crontab file where administrators can define CRON jobs. |
| `/etc/cron.d`           | Directory for additional system-wide cron job files. CRON jobs in this directory allow for easier management of individual cron job configurations. |
| `/etc/cron.daily`       | Directory for scripts that need to run daily.         |
| `/etc/cron.hourly`      | Directory for scripts that need to run hourly.        |
| `/etc/cron.weekly`      | Directory for scripts that need to run weekly.        |
| `/etc/cron.monthly`     | Directory for scripts that need to run monthly.       |
| `/var/spool/cron/crontabs` | Directory where individual user crontab files are stored. Users can schedule their personal jobs using the `crontab` command. |
| `/etc/cron.allow`       | File containing usernames that are allowed to use `crontab`. If this file exists, only users listed in it can schedule cron jobs. |
| `/etc/cron.deny`        | File containing usernames that are denied access to `crontab`. If `cron.allow` does not exist, all users except those listed in `cron.deny` can schedule jobs. |

##### Example of Adding a System-Wide CRON Job

To add a system-wide CRON job, you might place a file in `/etc/cron.d/`. Here’s an example of what the contents might look like:

```bash
# Example CRON job in /etc/cron.d/myjob
0 5 * * * root /usr/local/bin/daily-task.sh
```
### MySQL Cheat-Sheet

#### Connect to MySQL

| Command | Description |
| --- | --- |
| `mysql -u root -p` | Connect to MySQL as root user |
| `mysql -u <user> -p` | Connect to MySQL as a specific user |
| `mysql -u root -p -h <host>` | Connect to MySQL on a specific host |

#### Backup and Restore

| Command | Description |
| --- | --- |
| `mysqldump -u root -p <database> > backup.sql` | Backup a database to a file |
| `mysql -u root -p <database> < backup.sql` | Restore a database from a file |

### PostgreSQL Cheat-Sheet

#### Connect to PostgreSQL

| Command | Description |
| --- | --- |
| `psql -U postgres` | Connect to PostgreSQL as the `postgres` user |
| `psql -U <user> -d <database>` | Connect to PostgreSQL as a specific user and database |
| `psql -U <user> -d <database> -h <host>` | Connect to PostgreSQL on a specific host |

#### PostreSQL CLI Commands

| Command | Description |
| --- | --- |
| `\c <database>` | Connect to a specific database |
| `\password <user>` | Change password for a specific user |
| `\l` | List all databases |
| `\d+` | Show detailed information about various database objects |
| `\dt` | List all tables in the current database |
| `\du` | List all users |
| `\df` | List all functions |
| `\dv` | List all views |
| `\dn` | List all schemas |
| `\dp` | List all permissions |
| `\di` | List all indexes |
| `\ds` | List all sequences |
| `\d+` | Show detailed information about various database objects |
| `\q` | Quit psql |
| `\x` | Toggle expanded output |

#### Backup and Restore

| Command | Description |
| --- | --- |
| `pg_dump <database> > backup.sql` | Backup a database to a file |
| `psql <database> < backup.sql` | Restore a database from a file |


## Patterns
### Grep Cheat-Sheet

| Command | Description |
| ------- | ----------- |
| `grep 'pattern' file` | Search for a pattern in a file |
| `grep -i 'pattern' file` | Case insensitive search |
| `grep -r 'pattern' dir` | Recursively search for a pattern in all files under the directory |
| `grep -v 'pattern' file` | Invert match to display lines that do not contain the pattern |
| `grep -n 'pattern' file` | Display the line numbers with the output |
| `grep -c 'pattern' file` | Count the number of lines that match the pattern |
| `grep -l 'pattern' *` | Show only the names of files with matching lines |
| `grep -L 'pattern' *` | Show only the names of files without matching lines |
| `grep -o 'pattern' file` | Show only the part of a line matching the pattern |
| `grep 'pattern1\|pattern2' file` | Search for lines matching pattern1 or pattern2 |
| `grep -A 3 'pattern' file` | Display 3 lines after the matching line |
| `grep -B 3 'pattern' file` | Display 3 lines before the matching line |
| `grep -C 3 'pattern' file` | Display 3 lines before and after the matching line |
| `grep '^pattern' file` | Match lines beginning with 'pattern' |
| `grep 'pattern$' file` | Match lines ending with 'pattern' |
| `grep '^[^#]' file` | Ignore lines starting with '#' (comments) |
| `grep -E 'patt(ern1|ern2)' file` | Extended regex to search patterns with alternation |
| `grep -w 'pattern' file` | Match whole word 'pattern' |
| `grep -f patterns.txt file` | Use patterns from the file, one per line |
| `grep -e 'pattern1' -e 'pattern2' file` | Search for multiple patterns |

### SED Cheat-Sheet

| Command | Description |
| --- | --- |
| `sed 's/pattern/replacement/' file` | Replace the first occurrence of a pattern in each line |
| `sed -i 's/pattern/replacement/' file` | Replace all occurrences of a pattern in the file (in-place editing) |
| `sed '/pattern/d' file` | Delete lines that match the pattern |
| `sed '2d' file` | Delete the second line of the file |
| `sed '2,$d' file` | Delete from the second line to the end of the file |
| `sed 's/pattern/replacement/g' file` | Replace all occurrences of a pattern in each line |
| `sed -n 'p' file` | Print the output (useful with `-n` to suppress other output) |
| `sed '/pattern/p' file` | Print only lines that match the pattern |
| `sed '1,5s/pattern/replacement/' file` | Apply the substitution to lines 1 to 5 only |
| `sed -e 'command1' -e 'command2' file` | Apply multiple editing commands in sequence |
| `sed '5q' file` | Print until the 5th line of the file then quit |
| `sed 's/[a-z]/\U&/g' file` | Convert lowercase letters to uppercase |

### SORT Cheat-Sheet

| Command | Description |
| --- | --- |
| `sort file` | Sort lines of text alphabetically in a file |
| `sort -n file` | Sort numerically (useful for sorting numbers) |
| `sort -r file` | Reverse the results of sorts (descending order) |
| `sort -o output_file file` | Write the result to the output_file instead of standard output |
| `sort -k 2 file` | Sort a file based on the second column of data |
| `sort -u file` | Sort and remove duplicate lines |
| `sort -t':' -k 3n file` | Sort a file using ':' as a delimiter and numerically by the third column |
| `sort -f file` | Ignore case while sorting |
| `sort -m file1 file2` | Merge already sorted files file1 and file2 |
| `sort -c file` | Check whether the file is already sorted; do not sort |

### AWK Cheat-Sheet

| Command | Description |
| --- | --- |
| `awk '/pattern/ {print $1}'` | standard Unix shells |
| `awk '/pattern/ {print "$1"}'` | compiled with DJGPP, Cygwin |
| `awk "/pattern/ {print \"$1\"}"` | GnuWin32, UnxUtils, Mingw |
| `awk '1;{print ""}'` | double space a file |
| `awk 'BEGIN{ORS="\n\n"};1'` | double space a file |
| `awk 'NF{print $0 "\n"}'` | double space a file which already has blank lines |
| `awk '1;{print "\n"}'` | triple space a file |
| `awk '{print FNR "\t" $0}' files*` | precede each line by its line number |
| `awk '{print NR "\t" $0}' files*` | precede each line by its line number for all files together |
| `awk '{printf("%5d : %s\n", NR,$0)}'` | number each line of a file |
| `awk 'NF{$0=++a " :" $0};1'` | number each line of a file, but only print numbers if line is not blank |
| `awk 'END{print NR}'` | count lines (emulates "wc -l") |
| `awk '{s=0; for (i=1; i<=NF; i++) s=s+$i; print s}'` | print the sums of the fields of every line |
| `awk '{for (i=1; i<=NF; i++) s=s+$i}; END{print s}'` | add all fields in all lines and print the sum |
| `awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'` | print every line after replacing each field with its absolute value |
| `awk '{for (i=1; i<=NF; i++) $i = ($i < 0) ? -$i : $i; print }'` | print every line after replacing each field with its absolute value |
| `awk '{ total = total + NF }; END {print total}' file` | print the total number of fields ("words") in all lines |
| `awk '/Beth/{n++}; END {print n+0}' file` | print the total number of lines that contain "Beth" |
| `awk '$1 > max {max=$1; maxline=$0}; END{ print max, maxline}'` | print the largest first field and the line that contains it |
| `awk '{ print NF ":" $0 }'` | print the number of fields in each line, followed by the line |
| `awk '{ print $NF }'` | print the last field of each line |
| `awk '{ field = $NF }; END{ print field }'` | print the last field of the last line |
| `awk 'NF > 4'` | print every line with more than 4 fields |
| `awk '$NF > 4'` | print every line where the value of the last field is > 4 |



## Network
### Ethtool Cheat-Sheet

#### Displaying Information

| Command | Description |
| --- | --- |
| `ethtool <interface>` | Display information about a specific network interface |
| `ethtool -i <interface>` | Display driver information |
| `ethtool -a <interface>` | Display all settings |
| `ethtool -k <interface>` | Display offload settings |
| `ethtool -c <interface>` | Display coalescing settings |
| `ethtool -g <interface>` | Display ring buffer settings |
| `ethtool -l <interface>` | Display large receive offload settings |
| `ethtool -S <interface>` | Display statistics |
| `ethtool -t <interface>` | Test the network interface for offloading capabilities |
| `ethtool -T <interface>` | Display time stamping settings |
| `ethtool -x <interface>` | Display channel settings |
| `ethtool -P <interface>` | Display permanent MAC address |
| `ethtool -N <interface>` | Display offload settings |
| `ethtool -u <interface>` | Display bus information |
| `ethtool -d <interface>` | Display register dump |
| `ethtool -g <interface>` | Display ring buffer settings |

#### Setting Parameters

| Command | Description |
| --- | --- |
| `ethtool -G <interface>` | Set ring buffer settings |
| `ethtool -L <interface>` | Set large receive offload settings |
| `ethtool -A <interface>` | Set pause parameters |
| `ethtool -C <interface>` | Set coalescing settings |
| `ethtool -K <interface>` | Set offload settings |
| `ethtool -N <interface>` | Set offload settings |
| `ethtool -p <interface>` | Blink the LED on the network interface |
| `ethtool -r <interface>` | Reset the network interface |

### ARP in Linux

| Command | Description |
| --- | --- |
| `arp` | View the ARP table |
| `arp -a` | View the ARP table |
| `arp -n` | View the ARP table (don't resolve names) |
| `arp -d <ip>` | Delete an entry from the ARP table |
| `arp -s <ip> <mac_address>` | Add an entry to the ARP table |
| `arp -i <interface> -s <ip> <mac_address>` | Add an entry to the ARP table for a specific interface |
| `arp -i <interface> -d <ip>` | Delete an entry from the ARP table for a specific interface |
| `arp -i <interface> -n` | View the ARP table for a specific interface |
| `arp -i <interface> -a` | View the ARP table for a specific interface |
| `ip neigh show` | View the ARP table |
| `ip neigh show <ip>` | View the ARP table for a specific IP address |
| `ip neigh add <ip> lladdr <mac_address> dev <interface>` | Add an entry to the ARP table |
| `ip neigh change <ip> lladdr <mac_address> dev <interface>` | Change an entry in the ARP table |
| `ip neigh del <ip> dev <interface>` | Delete an entry from the ARP table |
| `ip neigh flush dev <interface>` | Flush the ARP table for a specific interface |
| `ip neigh flush all` | Flush the ARP table |
| `ip -s neigh show` | Show ARP statistics |
| `ip -s neigh flush all` | Flush the ARP cache |


## Linux One-Liners

This table provides useful one-liner commands for Linux users, ideal for system administration and development tasks.

| Command | Description |
|---------|-------------|
| `ps auxf \| sort -nr -k 3 \| head -10` | Display a tree of system processes, sorted by memory usage. |
| `df -h` | Check available disk space on all mounted filesystems in a human-readable format. |
| `top` | Monitor real-time system processes. |
| `lsof -p $$` | List all open files by a specific process (replace `$$` with the process ID). |
| `wc -l filename` | Count the number of lines in a file named `filename`. |
| `sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 file` | Sort a list of IP addresses stored in a file. |
| `sort file \| uniq -c \| sort -nr \| head` | Find the most frequently occurring lines in a file, useful for log analysis. |
| `netstat -tuln` | Check all listening ports on the system. |
| `wget --mirror -p --convert-links -P ./LOCAL-DIR website-url` | Download a website and all of its assets for offline viewing, storing in `LOCAL-DIR`. |
| `tar czf backup.tar.gz /path/to/directory` | Create a compressed backup of a directory. |
| `newuser="xyzuser" && sudo useradd -m $newuser && echo "$newuser ALL=(ALL) NOPASSWD: ALL" \| sudo tee /etc/sudoers.d/$newuser` | Create a new user defined by `newuser`, and add a sudoers file for them with `NOPASSWD` enabled. |
| `ls -lhtr --color=always` | Sort by last writen to reverse |
