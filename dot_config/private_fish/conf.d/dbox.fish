#!/usr/bin/env fish

if not is_distrobox
	return
end

# fix /run/host/* pwd
set dir (pwd)
if string match -q '/run/host/*' "$dir"
	set realdir (string replace '/run/host' '' "$dir")

	if test -d "$realdir"
		cd "$realdir"
	end
end

# fast node verison manager
# fnm env --use-on-cd --shell fish | source

# has to be near the end (zellij is the only exception)
# zoxide init fish --cmd chd | source

# if [[ "$CONTAINER_ID" != "dev-flutter" ]]; then
# 	return
# fi
#
# export CHROME_EXECUTABLE="/usr/bin/chromium"
# export ANDROID_HOME="$HOME/Android/Sdk"
# # export ANDROID_AVD_HOME=$XDG_CONFIG_HOME/.android/avd
# export PATH="/home/anir183/.envs/dev-flutter/fvm/default/bin:$PATH"
# export PATH="/home/anir183/.envs/dev-flutter/fvm/bin:$PATH"
# export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/build-tools/36.1.0:$PATH"
# export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/cmdline-tools/latest/bin:$PATH"
# export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/emulator:$PATH"
# export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/platform-tools:$PATH"
# alias flutter="fvm flutter"
# alias dart="fvm dart"
# # alias run-emul="emulator -avd \"pixel8-andr36.0.0-googleapis-x86_64\" -netdelay none -netspeed full -gpu on -memory 4096 -cores 4"
# # alias emul="emulator -avd \"pixel8-andr36.0.0-googleapis-x86_64\" -netdelay none -netspeed full -gpu on -memory 4096 -cores 4"


# if [[ "$CONTAINER_ID" != "dev-golang" ]]; then
# 	return
# fi
#
# source "/home/anir183/.envs/dev-golang/.g/env"


# if [[ "$CONTAINER_ID" != "dev-java" ]]; then
# 	return
# fi
#
# export _JAVA_AWT_WM_NONREPARENTING=1
#
# export CHROME_EXECUTABLE="/usr/bin/chromium"
# export ANDROID_HOME="$HOME/Android/Sdk"
# # export ANDROID_AVD_HOME=$XDG_CONFIG_HOME/.android/avd
# export PATH="/home/anir183/.envs/dev-java/Android/Sdk/build-tools/36.1.0:$PATH"
# export PATH="/home/anir183/.envs/dev-java/Android/Sdk/cmdline-tools/latest/bin:$PATH"
# export PATH="/home/anir183/.envs/dev-java/Android/Sdk/emulator:$PATH"
# export PATH="/home/anir183/.envs/dev-java/Android/Sdk/platform-tools:$PATH"
# export PATH="/home/anir183/.envs/dev-java/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/:$PATH"
# export SDKMAN_DIR="$HOME/.sdkman"
# export PATH="$HOME/.pgenv/bin:$HOME/.pgenv/pgsql/bin:$PATH"
# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# if [[ "$CONTAINER_ID" != "dev-nodejs" ]]; then
# 	return
# fi
#
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# if [[ "$CONTAINER_ID" != "dev-rust" ]]; then
# 	return
# fi
#
# export CHROME_EXECUTABLE="/usr/bin/chromium"
# export ANDROID_HOME="$HOME/Android/Sdk"
# export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
# export PATH="/home/anir183/.envs/dev-rust/Android/Sdk/build-tools/36.1.0:$PATH"
# export PATH="/home/anir183/.envs/dev-rust/Android/Sdk/emulator:$PATH"
# export PATH="/home/anir183/.envs/dev-rust/Android/Sdk/cmdline-tools/latest/bin:$PATH"
# export PATH="/home/anir183/.envs/dev-rust/Android/Sdk/platform-tools:$PATH"
#
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
