#!/bin/sh

# $1 should be your comment
commit_msg=$1
cur_dir=$(pwd)

git add -A
git commit -a -m $1

if [ -d "$cur_dir/subtree0/" ];then
  echo "subtree already exists"
else
  echo "exists nicht"
  #git remote add subrepo0 https://github.com/pusto-tauranth/test_1
  #git subtree add -P subtree0 subrepo0 master --squash
fi

git fetch subrepo0 master
git subtree pull -P subtree0 subrepo0 master --squash
git add -A
git commit -am "$1"
git push origin master

