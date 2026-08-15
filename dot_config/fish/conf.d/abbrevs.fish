#!/usr/bin/env fish

#[[ neovim and vim ]]
abbr -a mvim "nvim --cmd \"let g:MODE_183='minimal'\""
abbr -a mpvim "nvim --cmd \"let g:MODE_183='minimal-plugin'\""
abbr -a mdvim "nvim --cmd \"let g:MODE_183='minimal-dev'\""
abbr -a npvim "nvim --cmd \"let g:MODE_183='no-plugin'\""
abbr -a leet "nvim leetcode.nvim"

#[[ eza list commands ]]
abbr -a el "eza -F -a"
abbr -a ell "eza -F -l"
abbr -a ela "eza -F -la"
abbr -a etree "eza -F --tree"
abbr -a etrea "eza -F -a --tree"

#[[ git ]]
abbr -a ga "git add"
abbr -a gs "git status"
abbr -a gcom "git commit -m \""

#[[ lazygit ]]
abbr -a lg lazygit
abbr -a lgit lazygit
abbr -a legit lazygit

#[[ custom remember script ]]
abbr -a rem remember
abbr -a r ". remember goto"
abbr -a r1 ". remember 1"
abbr -a r2 ". remember 2"
abbr -a r3 ". remember 3"
abbr -a r4 ". remember 4"
abbr -a r5 ". remember 5"
abbr -a r6 ". remember 6"
abbr -a r7 ". remember 7"
abbr -a r8 ". remember 8"
abbr -a r9 ". remember 9"
abbr -a r0 ". remember 0"

#[[ misc ]]
abbr -a chist "mv $XDG_DATA_HOME/fish/fish_history $XDG_DATA_HOME/fish/fish_history.bak"
abbr -a :q exit

#[[ functions ]]
abbr -a sess-zellij sess_zellij
abbr -a sess "sess_zellij --all"

abbr -a update-mirrors update_mirrors
