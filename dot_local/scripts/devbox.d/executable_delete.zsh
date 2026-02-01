#!/usr/bin/env zsh

# NOTE : some assumptions are made when making this script
#        this is made for use via the parent script ./devbox.zsh
#
#        $# will be 1 or 2
#        $1 will be the <action> part of the command: devbox <action> [opts...]
#        $2 will be the [opts...] optinal argument(s)

# set up variables and util functions
. ./utils.zsh

# == variables ==

local container_name=""
local container_home=""

# == functions ==

# @param	<nothing>
# @return	<nothing>
# ---
# delete a container and optionally remove home directory
function delete_container() {
	# remove id from records
	local id=$(distrobox list | grep "| $container_name " | cut -d ' ' -f1 | tr ' ' ' ')
	echo "deleting container: $container_name with id: $id"
	local delete_cmd="distrobox rm $container_name"
	cmd_run $delete_cmd 2 || return
	local updated_list=$(cat $XDG_STATE_HOME/devbox/setup_containers | grep -v "$id")
	echo $updated_list > $XDG_STATE_HOME/devbox/setup_containers
	echo
	
	local choice=""
	local remove_cont_home_cmd="rm -rf $container_home || sudo rm -rf $container_home"
	vared -p "<enter> or <y> to remove container home directory: " -c choice
	case $(rmv_all_spaces $choice) in
		"" )
			;&
		[yY]* )
			cmd_run $remove_cont_home_cmd 2
			echo "removed home directory: $container_home"
			;;
		* )
			echo "continuing without removing container home"
			break
			;;
	esac
}

# == run functions ==

if [ $# -eq 1 ]; then
	container_name=$(input_name)
elif [ $# -eq 2 ]; then
	container_name=$(rmv_all_spaces $2)
else
	echo "too many arguments, expected 0 or 1"
	echo "check docs with: devbox help"
	return
fi

echo
if verify_name $container_name; then
	container_name=$(verify_name $container_name)
	container_home="$DEVBOX_DIR/$container_name"
	echo "starting container deletion"
	echo
	delete_container
fi
