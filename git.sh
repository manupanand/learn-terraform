echo adding files to staging
git add .
echo what is this commit for ?
read commit
git commit -m "${commit}"
echo staged, pushing to main $commit
#git commit -m $1
git push origin main
git status
