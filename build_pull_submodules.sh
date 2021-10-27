#!/bin/sh

#build and pull newest theme
cd blog-frontend/themes/hexo-theme-cactus
git stash
git checkout master
git pull origin master


cd ../..


#build and pull newest frontend
git stash
git checkout master
git pull origin master
npm install
hexo generate

cd ..

#copy front over
cp -r blog-frontend/public .

#build rdp
cd reverse-date-parser
git stash
git checkout master
git pull origin master
npm run build

cd ..

#copy rdp over
mkdir rdp
cp -r reverse-date-parser/build/* rdp
