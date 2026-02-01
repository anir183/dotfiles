#!/usr/bin/env zsh

local exec_dir=$(pwd)
local script_dir=${0:a:h}

cd $script_dir

# set up variables and util functions
. ./utils.zsh

# == validate number of arguments ==
if [ $# -eq 0 ]; then
	. ./create.zsh create
	echo
	echo "script completed"
	return
elif [ $# -gt 2 ]; then
	echo "too many arguments"
	echo "check docs with: devbox help"
	echo
	return
fi

# == handle arguments ==

local arg_2=$(rmv_all_spaces $2)

# NOTE : these if-else statements are important
#
#        for example, if we execute: devbox setup
#
#        if arguments are passed to the scripts without these if-else
#        statements, then inside the script -
#            $# always returns 1
#            $1 returns "setup" if no arguement is provided
#            $1 returns $arg_2 if argument is provided
#
#        but if these if-else statements are in place, then -
#            $# returns 1 or 2
#            $1 always returns "setup"
#            $2 returns $arg_2 or <nothing> if argument not provided
#
#       this is same for all other cases
case $(rmv_all_spaces $1) in
	enter|start|run )
		if [[ $# -gt 2 ]]; then
			. ./run.zsh $arg_2
		else
			. ./run.zsh
		fi
		cd $exec_dir
		return
		;;
	new|create|make )
		if [[ $# -gt 2 ]]; then
			. ./create.zsh $arg_2
		else
			. ./create.zsh
		fi
		;;
	init|initiate|setup|config|configure )
		if [[ $# -gt 2 ]]; then
			. ./setup.zsh $arg_2
		else
			. ./setup.zsh
		fi
		;; 
	list|ls|ll|show )
		if [[ $# -gt 2 ]]; then
			. ./list.zsh $arg_2
		fi
			. ./list.zsh
		;;
	remove|delete|rm )
		if [[ $# -gt 2 ]]; then
			. ./delete.zsh $arg_2
		else
			. ./delete.zsh
		fi
		;;
	min|minimal )
		if [[ $# -gt 2 ]]; then
			. ./create_min.zsh $arg_2
		else
			. ./create_min.zsh
		fi
		;;
	help|h|--help )
		if [ $# -gt 1 ]; then
			echo "ignoring extra arguments: $arg_2"
		fi
		help_menu
		;;
	* )
		echo "invalid <action> argument"
		echo "check docs with: devbox help"
		;;
esac

echo
echo "script completed"
cd $exec_dir
