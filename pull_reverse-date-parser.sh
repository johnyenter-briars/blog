#!/bin/sh

cd blog-frontend
hexo generate

cd ..

cp -r blog-frontend/public .



# cp -r ~/reverse-date-parser/build/* reverse-date-parser
# cp -r reverse-date-parser/static .

