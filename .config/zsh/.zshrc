#!/bin/zsh

if [[ ! -z $container ]] && [[ ! -z $CONTAINER_ID ]] && [[ ! -z $DISTROBOX_ENTER_PATH ]]; then
	for file in $XDG_CONFIG_HOME/zsh/.zshrc.dbox.d/*.zsh;
	do
		source $file
	done
	return
fi

# source all rc files
for file in $XDG_CONFIG_HOME/zsh/.zshrc.d/*.zsh;
do
	source $file
done

# dont go ahead for auto-appended stuff
return

