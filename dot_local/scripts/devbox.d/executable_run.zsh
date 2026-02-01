#!/usr/bin/env zsh

# NOTE : some assumptions are made when making this script
#        this is made for use via the parent script ./devbox.zsh
#
#        $# will be 1 or 2
#        $1 will be the <action> part of the command: devbox <action> [opts...]
#        $2 will be the [opts...] optinal argument(s)

# set up variables and util functions
. ./utils.zsh

# @param	$1	name to verify devbox setup container for
# @return	0|1
# ---
# verify if provided name is a container setup by this script
function verify_setup_name() {
	local name=$(rmv_all_spaces $1)
	
	if [[ -z $name ]]; then
		return false
	fi

	local devbox_list=$(. ./list.zsh)
	local check="echo \"$devbox_list\" | grep \"| $name \" &> /dev/null"
	local check_w_prefix="echo \"$devbox_list\" | grep \"| $DEVBOX_PREFIX-$name \" &> /dev/null"

	# check with prefix
	if (eval $check_w_prefix); then
		echo "$DEVBOX_PREFIX-$name"
		return 0
	fi

	# check without prefix
	if (eval $check); then
		echo $name
		return 0
	fi

	echo "no container setup with name: $name or $DEVBOX_PREFIX-$name"
	echo "devbox only allows running containers setup using: devbox setup"
	echo "please choose from one of the following:"
	echo
	. ./list.zsh
	echo
	return 1
}

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
if verify_setup_name $container_name; then
	container_name=$(verify_name $container_name)
	container_home="$DEVBOX_DIR/$container_name"
	check_arch="distrobox list | grep \"| $container_name \" | grep archlinux &> /dev/null"
	echo "starting container enter"

	local curr_dir=$(pwd)
	if [[ ! -z $DEVBOX_EXEC_DIR ]]; then
		cd $DEVBOX_EXEC_DIR
	fi

	local run_container_cmd="distrobox enter $container_name --additional-flags \"--env-file=$container_home/.container_envs --env=ZDOTDIR=$container_home/.config/zsh\""
	echo
	echo -E "executing command:  \"$run_container_cmd\""
	sleep 2
	echo
	eval $run_container_cmd
	echo

	cd $curr_dir
fi
