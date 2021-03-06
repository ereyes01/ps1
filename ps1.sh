#!/bin/sh

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
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

ps1_unstaged()
{
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git diff --quiet >/dev/null 2>&1 || echo -n '*'
}

ps1_staged()
{
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git diff --quiet --cached >/dev/null 2>&1 || echo -n '*'
}

ps1_untracked()
{
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git status --porcelain 2>/dev/null | grep -q ^?? && echo -n '*'
}

ps1_git()
{
    # branch
    echo -n $(esc_tput bold)$(esc_tput setaf $cyan)'$(ps1_branch)'$(esc_tput sgr0)' '

    # any staged files?
    echo -n $(esc_tput setaf $green)'$(ps1_staged)'$(esc_tput sgr0)

    # any modified unstaged files?
    echo -n $(esc_tput setaf $red)'$(ps1_unstaged)'$(esc_tput sgr0)

    # any new untracked files?
    echo -n $(esc_tput setaf $white)'$(ps1_untracked)'$(esc_tput sgr0)
}

ps1_rc()
{
    echo
    echo -n $(esc_tput bold)$(esc_tput setaf $white)'$?'$(esc_tput sgr0)
}

ps1_host_pwd()
{
    user_host='\u@\h'
    working_dir='\w'

    echo -n $(esc_tput bold)$(esc_tput setaf $green)${user_host}$(esc_tput sgr0)' '
    echo -n $(esc_tput bold)$(esc_tput setaf $blue)${working_dir}$(esc_tput sgr0)
}

ps1_prompt()
{
    echo
    echo -n $(esc_tput bold)$(esc_tput setaf $cyan)'> '
}

export PS1=$(ps1_rc)' '$(ps1_host_pwd)' '$(ps1_git)$(ps1_prompt)$(esc_tput sgr0)
