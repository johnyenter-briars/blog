#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)


#build and pull newest frontend
echo "${bold}pulling front end submodule"
cd blog-frontend/
git stash
git checkout master
git pull origin master
echo "${bold}running npm install on frontend"
npm install

#build and pull newest theme
echo "${bold}pulling theme submodule"
cd themes/hexo-theme-cactus
git stash
git checkout master
git pull origin master

cd ../../

echo "${bold}running hexo clean + generate"
hexo clean
hexo generate

cd ..

echo "${bold}copying compiled frontend to root"
#copy front over
cp -r blog-frontend/public .

#only build rdp if we have to
VAR="rdp"

if [[ $1 == "$VAR" ]]; then 
	#build rdp
	echo "${bold}pulling and building rdp"
	cd reverse-date-parser
	git stash
	git checkout master
	git pull origin master
	npm install
	npm run build

	cd ..

	#copy rdp over
	echo "${bold}copying over rdp"
	mkdir rdp
	cp -r reverse-date-parser/build/* rdp
fi