#!/usr/bin/env fish

function podman-docker --description "docker cli which talks to podman"
	systemctl --user start podman.socket
	env DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock docker $argv
end
