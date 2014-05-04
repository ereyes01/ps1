#!/bin/sh

# This script constructs a PS1 string so that your terminal prompt
# appears as follows, with pretty colors that look nice on a black
# background. Previous output is also padded from the prompt with an
# empty line.

#
# user@host ~/my/working/dir (git branch)
# 0> type command here

# The 0 in the second line is the return value of the previous command.
# If you're not in a git repository, you won't see the (git branch)

# To use in your .bashrc, source this file.

red='1'
green='2'
blue='4'
cyan='6'
white='7'

ps1_branch()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

ps1_unstaged()
{
    git branch &>/dev/null || return
    git diff --quiet &> /dev/null || echo -n "*"
}

ps1_staged()
{
    git branch &>/dev/null || return
    git diff --quiet --cached &> /dev/null || echo -n "*"
}

ps1_untracked()
{
    git branch &>/dev/null || return
    git status --porcelain 2> /dev/null | grep -q ^?? && echo -n '*'
}

ps1_git_with_rc()
{
    prev_rc=$?

    # branch
    echo -n $(tput bold)$(tput setaf $cyan)$(ps1_branch)$(tput sgr0)' '

    # any staged files?
    echo -n $(tput setaf $green)$(ps1_staged)$(tput sgr0)

    # any modified unstaged files?
    echo -n $(tput setaf $red)$(ps1_unstaged)$(tput sgr0)

    # any new untracked files?
    echo -n $(tput setaf $white)$(ps1_untracked)$(tput sgr0)

    # on next line, show previous command's return value
    echo
    echo $(tput bold)$(tput setaf $cyan)${prev_rc}'> '$(tput sgr0)
}

ps1_prefix()
{
    user_host='\u@\h'
    working_dir='\w'
    echo
    echo -n $(tput sgr0)$(tput bold)$(tput setaf $green)${user_host}$(tput sgr0)' '
    echo $(tput bold)$(tput setaf $blue)${working_dir}$(tput sgr0)
}

export PS1=$(ps1_prefix)' $(ps1_git_with_rc)'
