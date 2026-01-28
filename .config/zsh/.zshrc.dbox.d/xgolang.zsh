#!/usr/bin/env zsh

if [[ "$CONTAINER_ID" != "dev-golang" ]]; then
	return
fi

source "/home/anir183/.envs/dev-golang/.g/env"
