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

esc_tput()
{
    echo -n '\['$(tput $*)'\]'
}

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
    echo -n $(esc_tput bold)$(esc_tput setaf $cyan)'$(ps1_branch)'$(esc_tput sgr0)' '

    # any staged files?
    echo -n $(esc_tput setaf $green)'$(ps1_staged)'$(esc_tput sgr0)

    # any modified unstaged files?
    echo -n $(esc_tput setaf $red)'$(ps1_unstaged)'$(esc_tput sgr0)

    # any new untracked files?
    echo -n $(esc_tput setaf $white)'$(ps1_untracked)'$(esc_tput sgr0)

    # on next line, show previous command's return value
    echo
    echo $(esc_tput bold)$(esc_tput setaf $cyan)'${prev_rc}> '$(esc_tput sgr0)
}

ps1_host_pwd()
{
    user_host='\u@\h'
    working_dir='\w'
    echo
    echo -n $(esc_tput bold)$(esc_tput setaf $green)${user_host}$(esc_tput sgr0)' '
    echo $(esc_tput bold)$(esc_tput setaf $blue)${working_dir}$(esc_tput sgr0)
}

export PS1=$(ps1_host_pwd)' '$(ps1_git_with_rc)$(esc_tput sgr0)
