#!/bin/sh

cd blog-frontend
hexo generate

cd ..

cp -r blog-frontend/public .


cd reverse-date-parser
npm run build
cd ..
mkdir rdp
cp -r reverse-date-parser/build/* rdp



# cp -r ~/reverse-date-parser/build/* reverse-date-parser
# cp -r reverse-date-parser/static .

