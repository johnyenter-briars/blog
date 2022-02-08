#!/bin/bash

# move to root of project
cd ..

bold=$(tput bold)
normal=$(tput sgr0)

while getopts b:r:c: flag
do
    case "${flag}" in
        b) BLOG_FLAG=${OPTARG};;
        r) RDP_FLAG=${OPTARG};;
        c) CHRUST_FLAG=${OPTARG};;
    esac
done

if [[ $BLOG_FLAG ]]; then 
	# build and pull newest frontend
	echo "${bold}pulling front end submodule"
	cd blog-frontend/
	git stash
	git checkout master
	git pull origin master
	echo "${bold}running npm install on frontend"
	npm install

	# build and pull newest theme
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
	# copy front over
	cp -r blog-frontend/public .
fi

if [[ $RDP_FLAG ]]; then 
	export NODE_OPTIONS=--openssl-legacy-provider
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

if [[ $CHRUST_FLAG ]]; then 
    cd chrust

	git stash
	git checkout master
	git pull origin master

	cd ..
fi