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
local container_home="/tmp/tmp_devbox_cont_home"
local check_arch="return 1"

# == functions ==

# @param	<nothing>
# @return	<nothing>
# ---
# run the distrobox container for the first time so it can do its basic setup
function first_run() {
	local run_cmd="distrobox enter $container_name --additional-flags \"-e XDG_CACHE_HOME=$container_home/.cache -e XDG_DATA_HOME=$container_home/.local/share -e XDG_STATE_HOME=$container_home/.local/state -e XDG_CONFIG_HOME=$container_home/.config\" -- echo \"first run completed\""
	cmd_run $run_cmd 2
}

# @param	<nothing>
# @return	<nothing>
# ---
# copy zsh files to zdot dir
function setup_zsh_rc() {
	# history file
	mkdir $container_home/.local/state/zsh
	touch $container_home/.local/state/zsh/histfile || echo -e "could not create zsh histfile"

	local target_dir="$container_home/.config/zsh"

	# get source directory
	local src_dir="$HOME"
	if [[ -z $ZDOTDIR ]]; then
		echo "zdotdir env var is not set"
		src_dir="$HOME"
	else
		echo "using zdotdir env: $ZDOTDIR"
		src_dir="$ZDOTDIR"
	fi

	mkdir $target_dir
	if [[ -f $src_dir/.zshrc ]]; then
		echo "using .zshrc from $src_dir"
		cp -f $src_dir/.zshrc $target_dir/.zshrc || "could not copy .zshrc"
	else
		echo "no zshrc found in host"
		touch $src_dir/.zshrc || echo -e "could not create .zshrc file"
	fi
	if [[ -f $src_dir/.zshenv ]]; then
		echo "using .zshenv from $src_dir"
		cp -f $src_dir/.zshenv $target_dir/.zshenv || "could not copy .zshenv"
	fi
	if [[ -f $src_dir/.zprofile ]]; then
		echo "using .zprofile from $src_dir"
		cp -f $src_dir/.zprofile $target_dir/.zprofile || "could not copy .zprofile"
	fi
	if [[ -f $src_dir/.zlogin ]]; then
		echo "using .zlogin from $src_dir"
		cp -f $src_dir/.zlogin $target_dir/.zlogin || "could not copy .zlogin"
	fi
	if [[ -f $src_dir/.zlogout ]]; then
		echo "using .zlogout from $src_dir"
		cp -f $src_dir/.zlogout $target_dir/.zlogout || "could not copy .zlogout"
	fi
	if [[ -d $src_dir/.zshrc.d ]]; then
		echo "found .zshrc.d folder in $src_dir"
		ln -sf $src_dir/.zshrc.d $target_dir/.zshrc.d || "could not link .zshrc.d folder"
	fi
	if [[ -d $src_dir/.zshrc.dbox.d ]]; then
		echo "found .zshrc.dbox.d folder in $src_dir"
		ln -sf $src_dir/.zshrc.dbox.d $target_dir/.zshrc.dbox.d || "could not link .zshrc.dbox.d folder"
	fi
}

# @param	<nothing>
# @return	<nothing>
# ---
# set container home by remove bashrc, adding zsh config and creating xdg dirs
function setup_home_dir() {
	# remove bashrc files
	rm -f $container_home/.bashrc || echo "could not remove .bashrc"
	rm -f $container_home/.bash_logout || echo "could not remove .bash_logout"
	rm -f $container_home/.bash_profile || echo "could not remove .bash_profile"

	# creating directories
	local mkdirs_cmd="mkdir -p $container_home/{.config,.cache,.local,.local/share,.local/state,.local/bin,.local/scripts} && echo \"created basic xdg directories\""
	cmd_run $mkdirs_cmd 2
	echo

	# setup zshrc files
	setup_zsh_rc

	# link neovim config and zoxide database
	(ln -s $XDG_DATA_HOME/zoxide/ $container_home/.local/share && echo "linked zoxide database with host") || echo "could not link zoxide database with host"
	(ln -s $XDG_CONFIG_HOME/nvim/ $container_home/.config && echo "linked neovim config with host") || echo "could not link neovim config with host"

	# link scripts
	if [[ -d $HOME/.local/scripts ]]; then
		(cp -r $HOME/.local/scripts/* $container_home/.local/scripts && echo "copied scripts from $HOME/.local/scripts") || echo "could not copy scripts from host"
	fi
}

# @param	$1 binary to link with
# @return	<nothing>
# @source	https://distrobox.it/usage/distrobox-host-exec
# ---
# link a binary from the host to the distrobox container via distrobox-host-exec
function link_cmd_from_host() {
	local bin=$(rmv_all_spaces $1)

	local link_cmd="distrobox enter $container_name -- sudo ln -s /usr/bin/distrobox-host-exec $container_home/.local/bin/$bin"
	cmd_run $link_cmd 1
}


# @param	<nothing>
# @return	<nothing>
# ---
# link some host commands inside of the container
function link_host_cmds() {
	link_cmd_from_host nautilus
	link_cmd_from_host opencode
	link_cmd_from_host git
	link_cmd_from_host lazygit
	link_cmd_from_host gh
}

# @param	<nothing>
# @return	<nothing>
# ---
# enable color for pacman outputs
function enable_pacman_color() {
	((distrobox enter $container_name -- sudo sed -i "s/# Color/Color/I" /etc/pacman.conf) ||
		(distrobox enter $container_name -- sudo sed -i "s/#Color/Color/I" /etc/pacman.conf)) &&
		echo -e "\nenabled pacman color"
	if eval $check_arch; then
		local script_data="#!/bin/bash

sudo sed -i \"s/# Color/Color/I\" /etc/pacman.conf
sudo sed -i \"s/#Color/Color/I\" /etc/pacman.conf
"
		local create_script_cmd="ls $container_home/.local/scripts | grep enable_pacman_color &> /dev/null || ((echo -E '$script_data' > $container_home/.local/scripts/enable_pacman_color) && chmod +x $container_home/.local/scripts/enable_pacman_color)"
		local run_script_cmd="distrobox enter $container_name -- bash $container_home/.local/scripts/enable_pacman_color"

		cmd_run $create_script_cmd 2
		cmd_run $run_script_cmd 2
		echo "enabled pacman color"
	else
		echo "created container is not an arch image"
		echo "skipping enabling pacman output color"
	fi
}

# @param	<nothing>
# @return	<nothing>
# ---
# enable multilib for pacman in archlinux containers
function enable_pacman_multilib() {
	if eval $check_arch; then
		local script_data="#!/bin/bash

echo -e \"
[multilib]
Include=/etc/pacman.d/mirrorlist
\" | sudo tee -a /etc/pacman.conf
"
		local create_script_cmd="ls $container_home/.local/scripts | grep enable_multilib &> /dev/null || ((echo -E '$script_data' > $container_home/.local/scripts/enable_multilib) && chmod +x $container_home/.local/scripts/enable_multilib)"
		local run_script_cmd="distrobox enter $container_name -- bash $container_home/.local/scripts/enable_multilib"

		cmd_run $create_script_cmd 2
		cmd_run $run_script_cmd 2
		echo "enabled pacman multilib"
	else
		echo "created container is not an arch image"
		echo "skipping enable multilib"
	fi
}

# @param	<nothing>
# @return	<nothing>
# ---
# download some extra packages for arch containers
function setup_arch_packages() {
	if eval $check_arch; then
		local pkg_install_cmd="distrobox enter $container_name -- sudo pacman -Syu $DEVBOX_ARCH_PROGRAMS"
		cmd_run $pkg_install_cmd 2
	else
		echo "created container is not an arch image"
		echo "skipping installation of arch specific packages"
	fi
}

# @param	<nothing>
# @return	<nothing>
# ---
# download and setup paru aur handler for arch containers
function setup_paru() {
	if eval $check_arch; then
		local script_data="#!/bin/bash

git clone https://aur.archlinux.org/paru.git $container_home/.local/mkpkg/paru &&
	sleep 3 &&
	cd $container_home/.local/mkpkg/paru &&
	makepkg -si
"
		local create_script_cmd="ls $container_home/.local/scripts | grep install_paru &> /dev/null || ((echo -E '$script_data' > $container_home/.local/scripts/install_paru) && chmod +x $container_home/.local/scripts/install_paru)"
		local run_script_cmd="distrobox enter $container_name -- bash $container_home/.local/scripts/install_paru"
		local paru_wlroots_cmd="distrobox enter $container_name -- paru -S wlroots"

		mkdir $container_home/.local/mkpkg
		cmd_run $create_script_cmd 2
		cmd_run $run_script_cmd 2 &&
			cmd_run $paru_wlroots_cmd 2
		echo "setup paru aur"
	else
		echo "created container is not an arch image"
		echo "skipping paru-aur helper installation"
	fi
}

# @param	<nothing>
# @return	<nothing>
# ---
# setup environment variables file to use in container manager (podman?)
function setup_env_vars() {
	echo "XDG_CONFIG_HOME=$container_home/.config" >> $container_home/.container_envs
	echo "XDG_CACHE_HOME=$container_home/.local/cache" >> $container_home/.container_envs
	echo "XDG_DATA_HOME=$container_home/.local/share" >> $container_home/.container_envs
	echo "XDG_STATE_HOME=$container_home/.local/state" >> $container_home/.container_envs

	# WARN: Does not work for some reason
	# echo "ZDOTDIR=$container_home/.config/zsh" >> $DEVBOX_ENVS_DIR/$__dvb_cont_name/.container_envs
	echo "setup container-run environment variables"
}

# @param	<nothing>
# @return	<nothing>
# ---
# record containers setup up by this script
function record_setup_container() {
	if [[ ! -d "$XDG_STATE_HOME/devbox" ]]; then
		mkdir $HOME/.local/state/devbox
	fi

	if [[ ! -f "$XDG_STATE_HOME/devbox/setup_containers" ]]; then
		touch $HOME/.local/state/devbox/setup_containers
	fi

	local id=$(distrobox list | grep "| $container_name " | cut -d ' ' -f1 | tr ' ' ' ')
	if [[ "$(rmv_all_spaces $(cat "$XDG_STATE_HOME/devbox/setup_containers"))" == "" ]]; then
		echo $id > $XDG_STATE_HOME/devbox/setup_containers
	else
		echo $id >> $XDG_STATE_HOME/devbox/setup_containers
	fi
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
	check_arch="distrobox list | grep \"| $container_name \" | grep archlinux &> /dev/null"
	echo "starting container setup"
	echo
	first_run
	echo
	setup_home_dir
	echo
	setup_env_vars
	# echo
	record_setup_container
	echo
	link_host_cmds
	echo
	enable_pacman_color
	echo
	enable_pacman_multilib
	echo
	setup_arch_packages
	echo
	setup_paru
	echo
	echo "container is created and setup"
	echo "to run container, use: devbox enter $container_name"
fi
