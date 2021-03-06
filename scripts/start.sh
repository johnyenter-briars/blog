#!/bin/bash

# move to root of project
cd ..

while getopts b:r:c: flag
do
    case "${flag}" in
        b) BLOG_FLAG=${OPTARG};;
        c) CHRUST_FLAG=${OPTARG};;
    esac
done

if [[ $CHRUST_FLAG ]]; then 
    cd chrust

    ./build_linux.sh

    cd release/linux/chrust-0.2.0/

    nohup ./chrust > chrust.out 2> chrust.err &

    echo $! > .procnum

    cd ../../../../ # move back to root
fi

if [[ $BLOG_FLAG ]]; then 
    cargo build --release

    PROFILE=release nohup ./target/release/jyb-blog > jyb-blog.out 2> jyb-blog.err &

    echo $! > .procnum
fi


