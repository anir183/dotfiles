#!/usr/bin/env fish

function git_refspec_fix --description "fix git refspec to default expected value"
	git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
end

function grit_refspec_fix --description "fix repo.git refspec to default expected value"
	git --git-dir=repo.git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
end
