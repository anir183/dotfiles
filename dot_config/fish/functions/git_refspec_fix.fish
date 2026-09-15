#!/usr/bin/env fish

function git_refspec_fix --description "fix git refspec to default expected value"
	git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
end
