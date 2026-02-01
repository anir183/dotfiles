#!/usr/bin/env zsh

local dir=$(pwd)

if [[ $dir == /run/host* ]]; then
	cd ${dir#"/run/host"}
fi
