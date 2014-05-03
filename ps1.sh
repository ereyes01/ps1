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

bold_cyan="\033[01;36m"
bold_red="\033[1;31m"
bold_green="\033[1;32m"
bold_blue="\033[1;34m"
red="\033[0;31m"
green="\033[0;32m"
white="\033[0;37m"
default_color="\033[00m"

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

    user_host=${bold_green}'\u@\h'
    working_dir=${bold_blue}'\w'

    echo -e ${bold_cyan}$(ps1_branch)\
            ${green}$(ps1_staged)${red}$(ps1_unstaged)${white}$(ps1_untracked)
    echo -e ${bold_cyan}${prev_rc}'> '${default_color}
}

ps1_prefix()
{
    user_host='\u@\h'
    working_dir='\w'
    echo
    echo -n '\['${bold_green}'\]'${user_host}\
            '\['${bold_blue}'\]'${working_dir}
}

export PS1=$(ps1_prefix)' $(ps1_git_with_rc)'
