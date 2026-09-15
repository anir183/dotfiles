#!/usr/bin/env fish

function grit_refspec_fix --description "fix repo.git refspec to default expected value"
	git --git-dir=repo.git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
end
