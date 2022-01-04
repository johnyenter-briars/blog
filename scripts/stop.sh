#!/bin/sh

#move to root of project
cd ..

# kill chrust
cd chrust/release/linux/chrust-0.2.0/
kill -9 $(cat .procnum)

cd ../../../../

# kill blog
kill -9 $(cat .procnum)