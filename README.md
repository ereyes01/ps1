# PS1 Script

This script constructs a PS1 string that does the following:

- Shows the return code of the last command.
- If in a git repository, shows some basic git status.
- Has pretty colors that look good on black terminal backgrounds.
- Pads an empty line between previous command's output and prompt.

The git state presented on the prompt is:

- The branch name in parentheses
- A green * when staged changes are detected
- A red * when unstaged changes are detected
- A white * when untracked files are detected

The * git status output was inspired by https://github.com/vergenzt/git-colored-ps1

Below is a screen shot of what this looks like:

![Screenshot](https://raw.github.com/ereyes01/ps1/master/ps1.png)

To use this PS1, source the ps1.sh script at the end of your .bashrc.

I've tested this on Gnome Terminal 3.6.1 on Ubuntu 13.10.
