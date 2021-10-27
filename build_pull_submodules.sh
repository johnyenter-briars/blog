#!/bin/sh

#build and pull newest frontend
cd blog-frontend/
git stash
git checkout master
git pull origin master
npm install

#build and pull newest theme
cd themes/hexo-theme-cactus
git stash
git checkout master
git pull origin master

cd ../../

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
