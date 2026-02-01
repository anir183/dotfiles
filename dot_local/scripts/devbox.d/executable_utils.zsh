#!/usr/bin/env zsh

# == variables ==

export DEVBOX_DIR=${DEVBOX_DIR:-"$HOME/.envs"}
export DEVBOX_PREFIX=${DEVBOX_PREFIX:-"dev"}
export DEVBOX_ISNVIDIA=${DEVBOX_ISNVIDIA:-"true"}
export DEVBOX_INITAL_PROGRAMS=${DEVBOX_INITAL_PROGRAMS:-"zsh fd fzf ripgrep gcc clang npm 7zip make npm yazi vi nano git nvim sudo man-db man-pages"}
export DEVBOX_ARCH_PROGRAMS=${DEVBOX_ARCH_PROGRAMS:-"debugedit fakeroot openssl pkg-config zoxide nvim perl-error perl-mailtools perl-timedate zlib-ng compiler-rt lld rust base-devel eza yazi bat tree-sitter-cli lcms2 wl-clipboard"}

if [[ ! -d $DEVBOX_DIR ]]; then
	mkdir -p $DEVBOX_DIR
fi

# == functions ==

# @param	$1			argument to remove all spaces from
# @return	<nothing>
# ---
# remove all spaces from an argument including in-between ones
function rmv_all_spaces() {
	local str=$1

	echo ${str// }
}

# @param	$1			argument to remvoe surrounding spaces from
# @return	<nothing>
# @source	https://stackoverflow.com/questions/68259691/trimming-whitespace-from-the-ends-of-a-string-in-zsh
# ---
# remove surrounding spaces ie. preceding and trailing
function rmv_surr_spaces() {
	local str=$1

	echo "${(*)str//((#s)[[:space:]]##|[[:space:]]##(#e))}"
}

# @param	<nothing>
# @return	$name
# ---
# take input for container name to perform operations
function input_name() {
	local name=""

	# input new name
	vared -p "name (you can omit \"$DEVBOX_PREFIX\"): " -c name

	# validation
	name=$(rmv_all_spaces $name)
	if [[ -z $name ]]; then
		echo "invalid name"
	fi

	echo $name
}

# @param	$1	name to verify distrobox container for
# @return	0|1
# ---
# verify if provided name is a valid distrobox container
function verify_name() {
	local name=$(rmv_all_spaces $1)
	
	if [[ -z $name ]]; then
		return false
	fi

	local check="distrobox list | grep \"| $name \" &> /dev/null"
	local check_w_prefix="distrobox list | grep \"| $DEVBOX_PREFIX-$name \" &> /dev/null"

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

	echo "no container exists with name: $name or $DEVBOX_PREFIX-$name"
	echo "please choose from one of the following:"
	distrobox list
	echo
	return 1
}

# @param	<nothing>
# @return	<nothing>
# @source	https://stackoverflow.com/questions/5215343/how-can-i-pause-in-zsh
# ---
# pause and wait for keypress before continuing
function press_any_key() {
	read -s -k "?press and key to continue..."
	echo
}

# @param	$1	command to execute
# @param?	$2	time to wait for before executing command
# @return	0|1
# ---
# run a command with option to retry or continue on failure
function cmd_run() {
	local cmd=$1
	local sleep_time=$(rmv_all_spaces $2)

	echo -E "executing command:  \"$cmd\""

	# sleep if sleep time is provided else pause
	if [[ -z $sleep_time ]]; then
		press_any_key
	else
		sleep $sleep_time
	fi

	echo

	while (eval $cmd); [[ $? -ne 0 ]];
	do
		echo

		local choice=""
		vared -p "<enter> or <y> to retry: " -c choice
		case $(rmv_all_spaces $choice) in
			"" )
				;&
			[yY]* )
				;;
			* )
				echo "continuing without retrying"
				echo "you can manually run: $cmd"
				return 1
				;;
		esac

		echo
	done

	return 0
}

# @param	<nothing>
# @return	<nothing>
# ---
# print the help menu
function help_menu() {
	echo "
devbox <action> [opts...]

creates and manages distrobox containers with additional setup for development

	NOTE:
	* this script is sensitive to the order of arguments
	* variables in [] are optional
	* currently accepts a maximum of two arguments - <action> [opt]
	* setting DEVBOX_DIR env var dictates where container homes are created (default: $DEVBOX_DIR)
	* setting DEVBOX_ISNVIDIA env var to \"true\" runs distrobox create with the --nvidia flag  (default: $DEVBOX_ISNVIDIA)
	* setting DEVBOX_PREFIX env var dictates prefix attached before container names (default: $DEVBOX_PREFIX)
	* setting DEVBOX_INITAL_PROGRAMS env var dictates which programs to preinstall in each container
		(default: $DEVBOX_INITAL_PROGRAMS)
	* setting DEVBOX_ARCH_PROGRAMS env var dictates extra programs to install in archlinux containers
		(default: $DEVBOX_ARCH_PROGRAMS)

	AVAILABLE ACTIONS:
		<none>
				same as: devbox create
		create [name]
				creates a new container
				opts:
					uses prefix-[name] to name the container, if provided
		minimal [name]
				creates a new container will minimal additional setup
				opts:
					uses [name] to name the container, if provided
		setup [name]
				starts additional setup for a container
				opts:
					starts setup for container with [name] or prefix-[name] if provided
		run [name]
				runs a container
				opts:
					runs container with [name] or prefix-[name] if provided
		remove [name]:
				stops and removes a container
				opts:
					removes container with [name] or prefix-[name] if provided
		list [opt]
				lists containers with prefix-[name]
				opts:
					if [opt] is all, works same as: distrobox list
					if [opt] is prefix, onyl lists prefix-name containers
					else, only list containers setup by the script: devbox setup
		help
				shows this message
				opts:
					<none>

	EXAMPLES:
	* devbox create
	* devbox create name
	* devbox list
	* devbox list prefix
	* devbox setup name
	* etc...
"
}
