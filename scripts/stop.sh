#!/bin/bash

#move to root of project
cd ..

# kill chrust
cd chrust/release/linux/chrust-0.2.0/
kill -9 $(cat .procnum)

cd ../../../../

# kill blog
kill -9 $(cat .procnum)

# kill grove
kill -9 $(pgrep -f runGrove.sh)
kill -9 $(pgrep -f "flask run")

