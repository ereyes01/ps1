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

# To use in your .bashrc, source this file in that script and add:
#
# PS1=$(ps1_output)

parse_git_branch()
{
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

ps1_rc_git()
{
	old_rc=$?
	echo -e '\e[0;96m'"$(parse_git_branch)"
	echo $old_rc"> "
	return $old_rc
}

ps1_output()
{
    echo '
\[\033[01;32m\]\u@\h\[\033[01;34m\] \w $(ps1_rc_git)\[\033[00m\]'
}
