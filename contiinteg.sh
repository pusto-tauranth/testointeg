#!/bin/sh

## $1 should be your comment
commit_msg=$1

## Following 2 lines are to Avoid Subtree Pull Error: "Working Tree Has Modifications. Cannot Add."
git add -A
git commit -a -m "toAvoidSubtreePullError:WorkingTreeHasModifi" --allow-empty

cur_dir=$(pwd)

if [ -d "$cur_dir/subtree0/" ];then
  echo "subtree already exists"
else
  echo "exists nicht"
  git remote add subrepo0 https://github.com/pusto-tauranth/test_1
  git subtree add -P subtree0 subrepo0 master --squash
fi

git fetch subrepo0 master
git subtree pull -P subtree0 subrepo0 master --squash

## Following 1 line is to prevent the aforementioned "git mommit" and "git subtree pull" from adding commits to repo, which make the commit record of the repo ungraceful.
git reset --soft HEAD~2


## According to https://www.gnu.org/software/make/manual/html_node/Running.html#Running , the exit status is not 0 when make is not fully successful, hence the failure check is as below who will push only when make succeeded. 
## Uncomment the following 10 lines (from `cmake` to `fi` to actually activate failure checker.
# cmake .
# make
# if [ $? -ne 0 ]; then
#   echo "failed"
# else
#   echo "succeeded"
git add -A
git commit -am "$1"
git push origin master
# fi

