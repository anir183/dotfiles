#!/usr/bin/env zsh

if [[ "$CONTAINER_ID" != "dev-java" ]]; then
	return
fi

export _JAVA_AWT_WM_NONREPARENTING=1

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
