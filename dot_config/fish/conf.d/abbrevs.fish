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
abbr -a gr "git --git-dir=repo.git"
abbr -a grit "git --git-dir=repo.git"

#[[ lazygit ]]
abbr -a lg lazygit
abbr -a lgit lazygit
abbr -a legit lazygit

#[[ custom remember script ]]
abbr -a rem remember
abbr -a remg "remember goto"

#[[ misc ]]
# abbr -a emul "emulator -avd Pixel_36 -no-metrics"
abbr -a chist "mv $XDG_DATA_HOME/fish/fish_history $XDG_DATA_HOME/fish/fish_history.bak"
abbr -a :q exit

#[[ functions ]]
abbr -a sess-zellij sess_zellij
abbr -a sess "sess_zellij --all"

abbr -a update-mirrors update_mirrors

abbr -a git-refspec-fix git_refspec_fix
abbr -a grit-refspec-fix grit_refspec_fix
