#!/bin/sh

#build frontend
cd blog-frontend
npm install
hexo generate

cd ..

#copy front over
cp -r blog-frontend/public .

#build rdp
cd reverse-date-parser
npm run build

cd ..

#copy rdp over
mkdir rdp
cp -r reverse-date-parser/build/* rdp
