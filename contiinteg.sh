git remote add subrepo0 https://github.com/pusto-tauranth/test_1
git subtree add -P subtree0 subrepo0 master --squash
git fetch subrepo0 master
git subtree pull -P subtree0 subrepo0 master
git add -A
git commit -a -m "test contiinteg sh"
git push origin master
