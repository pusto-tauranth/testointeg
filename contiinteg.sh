#!/bin/bash

#sub="subtree0 subrepo0 master https://github.com/pusto-tauranth/test_1""subtree1 subrepo1 master https://github.com/pusto-tauranth/pusto-mathe-kit"
sub1=(
"subtree0" "subrepo0" "master" "https://github.com/pusto-tauranth/test_1"
"subtree1" "subrepo1" "master" "https://github.com/pusto-tauranth/pusto-mathe-kit"
)
((count=${#sub1[@]}/4+1))

## $1 should be your comment
commit_msg=$1

## Following 2 lines are to avoid subtree pull Error: "Working tree has modifications. Cannot add."
git add -A
git commit -a -m "toAvoidSubtreePullError:WorkingTreeHasModifi" --allow-empty

cur_dir=$(pwd)

for((i=0;i<${#sub1[@]}/4;i++));do
if [ -d "$cur_dir/${sub1[((i*4+0))]}/" ];then
  echo "Subtree ${sub1[((i*4+0))]} already exists."
else
  echo "Subtree ${sub1[((i*4+0))]} does not exist so add it now."
  git remote add ${sub1[((i*4+1))]} ${sub1[((i*4+3))]}
  git subtree add -P ${sub1[((i*4+0))]} ${sub1[((i*4+1))]} ${sub1[((i*4+2))]} --squash
fi

git fetch ${sub1[((i*4+1))]} ${sub1[((i*4+2))]}
git subtree pull -P ${sub1[((i*4+0))]} ${sub1[((i*4+1))]} ${sub1[((i*4+2))]} --squash
echo "la exit status'est $?"
done
#if [ -d "$cur_dir/subtree0/" ];then
#  echo "Subtree already exists."
#else
#  echo "Subtree does not exist so add it now."
#  git remote add subrepo0 https://github.com/pusto-tauranth/test_1
#  git subtree add -P subtree0 subrepo0 master --squash
#fi

#git fetch subrepo0 master
#git subtree pull -P subtree0 subrepo0 master --squash

## Following 1 line is to prevent the aforementioned "git mommit" and "git subtree pull" from adding commits to repo, which make the commit record of the repo ungraceful.
#git reset --soft HEAD~3


## According to https://www.gnu.org/software/make/manual/html_node/Running.html#Running , the exit status is not 0 when make is not fully successful, hence the failure check is as below who will push only when make succeeded. 
## Uncomment the following 10 lines (from `cmake` to `fi` to actually activate failure checker.
# cmake .
# make
# if [ $? -ne 0 ]; then
#   echo "failed"
# else
#   echo "succeeded"
git add -A
git commit -am "$commit_msg"
git push origin master
# fi

