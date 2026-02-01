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
local image_name=""

# == functions ==

# @param	<nothing>
# @return	<nothing>
# ---
# get and validate input or generate random name for creating new container
function get_name() {
	local name=""

	# input new name
	vared -p "name (<enter> for random): " -c name

	# validation and assignment
	name=$(rmv_all_spaces $name)
	if [[ -z $name ]]; then
		name=$(cat /dev/urandom | tr -cd "a-z0-9" | head -c 7)
	fi

	container_name="$DEVBOX_PREFIX-$name"
}

# @param	$1			name to check image for
# @return	<nothing>
# ---
# check if an image with given name exists in the container shortnames registry
function check_image_exists() {
	local img_name=$(rmv_surr_spaces $1)

	local img_names_file="/etc/containers/registries.conf.d/00-shortnames.conf"
	cat $img_names_file | grep \"$img_name\" &> /dev/null && return 0 || return 1
}

# @param	<nothing>
# @return	<nothing>
# ---
# input and validate image name from user
function get_image_name() {
	local img_name=""

	# loop until valid input is received
	while check_image_exists $img_name; [[ $? -ne 0 ]];
	do
		# input image name
		vared -p "image name (<enter> for arch): " -c img_name

		# validation and assignment
		img_name=$(rmv_surr_spaces $img_name)
		if [[ -z $img_name ]]; then
			img_name="archlinux"
		fi

		# final verification
		if check_image_exists $img_name; then
			echo "using image: $img_name"
		else
			echo "no image found with name: $img_name"
		fi
	done

	image_name=$img_name
}

# @param	<nothing>
# @return	<nothing>
# ---
# create distrobox container
function create_container() {
	local nvidia="--nvidia "
	if [[ "$DEVBOX_ISNVIDIA" == "false" ]]; then
		nvidia=""
	fi

	local create_cmd="distrobox create --name $container_name --image $image_name --hostname $container_name --home $DEVBOX_DIR/$container_name --additional-packages \"$DEVBOX_INITAL_PROGRAMS\" $nvidia"
	cmd_run $create_cmd
}

# @param	<nothing>
# @return	<nothing>
# ---
# forward to setup script
function forward_to_setup() {
	local choice=""

	vared -p "<enter> or <y> to auto-setup container: " -c choice
	case $(rmv_all_spaces $choice) in
		"" )
			;&
		[yY]* )
			. ./setup.zsh create $container_name
			;;
		* )
			echo "exiting without setting up"
			echo "you can setup later with: devbox setup"
			;;
	esac
}

# == run functions ==

if [ $# -eq 1 ]; then
	get_name
elif [ $# -eq 2 ]; then
	container_name=$DEVBOX_PREFIX-$(rmv_all_spaces $2)
else
	echo "too many arguments, expected 0 or 1"
	echo "check docs with: devbox help"
	return
fi

echo "using container name: $container_name"
echo
get_image_name
echo
create_container
# echo
forward_to_setup
