#!/usr/bin/env zsh

if [[ "$CONTAINER_ID" != "dev-flutter" ]]; then
	return
fi

export CHROME_EXECUTABLE="/usr/bin/chromium"
export ANDROID_HOME="$HOME/Android/Sdk"
# export ANDROID_AVD_HOME=$XDG_CONFIG_HOME/.android/avd
export PATH="/home/anir183/.envs/dev-flutter/fvm/default/bin:$PATH"
export PATH="/home/anir183/.envs/dev-flutter/fvm/bin:$PATH"
export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/build-tools/36.1.0:$PATH"
export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/cmdline-tools/latest/bin:$PATH"
export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/emulator:$PATH"
export PATH="/home/anir183/.envs/dev-flutter/Android/Sdk/platform-tools:$PATH"
alias flutter="fvm flutter"
alias dart="fvm dart"
# alias run-emul="emulator -avd \"pixel8-andr36.0.0-googleapis-x86_64\" -netdelay none -netspeed full -gpu on -memory 4096 -cores 4"
# alias emul="emulator -avd \"pixel8-andr36.0.0-googleapis-x86_64\" -netdelay none -netspeed full -gpu on -memory 4096 -cores 4"
