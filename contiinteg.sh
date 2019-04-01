#!/bin/bash

#TODO: add "subtree_name" "subrepo_name" "subrepo_branch_name" "subrepo_link" to this array. And the repo/branch to push into is 
subrepos=(
"subtree0" "subrepo0" "master" "https://github.com/pusto-tauranth/test_1"
"subtree1" "subrepo1" "master" "https://github.com/pusto-tauranth/pusto-mathe-kit"
)

#$1 should be your comment
commit_msg=$1

cur_dir=$(pwd)

for((i=0;i<${#subrepos[@]}/4;i++));do

  if [ -d "$cur_dir/${subrepos[((i*4+0))]}/" ];then
    echo "ContinuousIntegration Info: Subtree ${subrepos[((i*4+0))]} already exists."
  else
    echo "ContinuousIntegration Info: Subtree ${subrepos[((i*4+0))]} does not exist so add it now."
    git remote add ${subrepos[((i*4+1))]} ${subrepos[((i*4+3))]}
    git subtree add -P ${subrepos[((i*4+0))]} ${subrepos[((i*4+1))]} ${subrepos[((i*4+2))]} --squash
  fi

  git fetch ${subrepos[((i*4+1))]} ${subrepos[((i*4+2))]}
  git subtree pull -P ${subrepos[((i*4+0))]} ${subrepos[((i*4+1))]} ${subrepos[((i*4+2))]} --squash -m "subtree_pull_${subrepos[((i*4+0))]}"

  subt_pull_exit=$?
  echo "ContinuousIntegration Info: exit status of subtree_pull is $subt_pull_exit"
  if [ $subt_pull_exit -ne 0 ];then
    #Then `add` and `commit` the modifs in current working tree to avoid subtree pull Error: "Working tree has modifications. Cannot add."
    git add -A
    git commit -a -m "autoCommitToAvoidSubtreePullError:WorkingTreeHasModifi" #--allow-empty

    git fetch ${subrepos[((i*4+1))]} ${subrepos[((i*4+2))]}
    git subtree pull -P ${subrepos[((i*4+0))]} ${subrepos[((i*4+1))]} ${subrepos[((i*4+2))]} --squash -m "subtree_pull_${subrepos[((i*4+0))]}"
  fi

done


#According to https://www.gnu.org/software/make/manual/html_node/Running.html#Running , the exit status is not 0 when make is not fully successful, hence the failure check is as below who will push only when make succeeded. 
#TODO: Uncomment the following lines (from `cmake` to `fi`) to actually activate failure checker. The `git push ...` should also be modified.
# cmake .
# make
# if [ $? -ne 0 ]; then
#   echo "failed"
#   exit (1)
# else
#   echo "succeeded"
  git add -A
  git commit -am "$commit_msg"
  git push origin master
# fi

