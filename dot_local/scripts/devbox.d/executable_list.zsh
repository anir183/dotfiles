#!/usr/bin/env zsh

# NOTE : some assumptions are made when making this script
#        this is made for use via the parent script ./devbox.zsh
#
#        $# will be 1 or 2
#        $1 will be the <action> part of the command: devbox <action> [opts...]
#        $2 will be the [opts...] optinal argument(s)

# set up variables and util functions
. ./utils.zsh

# == functions ==

# @param	<nothing>
# @return	<nothing>
# ---
# list containers setup by this script
function list_setup() {
	if [[ -f "$XDG_STATE_HOME/devbox/setup_containers" ]]; then
		if [[ "$(rmv_all_spaces $(cat $XDG_STATE_HOME/devbox/setup_containers))" == "" ]]; then
			echo "no containers setup using devbox yet"
			return
		fi

		local distrobox_list=$(distrobox list)
		echo "ID           | NAME                 | STATUS             | IMAGE"
		while IFS='' read -r LINE || [ -n "${LINE}" ]; do
			if [[ $(rmv_all_spaces ${LINE}) != ""  ]]; then
				echo "$distrobox_list" | grep "${LINE}" --color
			fi
		done < $XDG_STATE_HOME/devbox/setup_containers
	fi
}

# == run functions ==

if [ $# -eq 1 ]; then
	list_setup
elif [ $# -eq 2 ]; then
	case $(rmv_all_spaces $2) in
		all|--all|a )
			distrobox list
			;;
		dev|prefix|--dev|--prefix|pre|--pre )
			echo "ID           | NAME                 | STATUS             | IMAGE"
			distrobox list | grep "| $DEVBOX_PREFIX-" --color
			;;
		file|ids|id|--file|--id|--ids )
			echo "ID"
			cat $XDG_STATE_HOME/devbox/setup_containers
			;;
		* )
			list_setup
			;;
	esac
else
	echo "too many arguments, expected 0 or 1"
	echo "check docs with: devbox help"
fi
