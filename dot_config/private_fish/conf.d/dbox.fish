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

# env vars
set -gx CHROME_EXECUTABLE /run/host/var/lib/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/export/bin/io.github.ungoogled_software.ungoogled_chromium

# node
fnm env --use-on-cd --shell fish | source

# java
javm init fish | source
set -gx _JAVA_AWT_WM_NONREPARENTING 1

# zig
fish_add_path --prepend $XDG_DATA_HOME/zvm/bin

# go
if test -s "$HOME/.g/env.fish"; and source "$HOME/.g/env.fish"; end

# flutter
# alias flutter "fvm flutter"
# alias dart "fvm dart"

# android
set -x ANDROID_HOME $HOME/.local/share/android-sdk
set -x ANDROID_SDK_ROOT $ANDROID_HOME
set -x ANDROID_AVD_HOME $XDG_CONFIG_HOME/.android/avd

fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator

abbr -a emul "emulator -avd Pixel_36 -no-metrics"

# has to be near the end (zellij is the only exception)
zoxide init fish --cmd chd | source
