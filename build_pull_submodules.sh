#!/bin/sh


#build and pull newest frontend
echo "pulling front end submodule"
cd blog-frontend/
git stash
git checkout master
git pull origin master
echo "running npm install on frontend"
npm install

#build and pull newest theme
echo "pulling theme submodule"
cd themes/hexo-theme-cactus
git stash
git checkout master
git pull origin master

cd ../../

echo "running hexo generate"
hexo generate

cd ..

echo "copying compiled frontend to root"
#copy front over
cp -r blog-frontend/public .

#build rdp
echo "pulling and building rdp"
cd reverse-date-parser
git stash
git checkout master
git pull origin master
npm run build

cd ..

#copy rdp over
echo "copying over rdp"
mkdir rdp
cp -r reverse-date-parser/build/* rdp
