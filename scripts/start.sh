#!/bin/bash

# move to root of project
cd ..

while getopts b:c:g:a: flag
do
    case "${flag}" in
        b) BLOG_FLAG=${OPTARG};;
        c) CHRUST_FLAG=${OPTARG};;
        g) GROVE_FLAG=${OPTARG};;
        a) CAL_FLAG=${OPTARG};;
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

if [[ $GROVE_FLAG ]]; then 
    cd Grove

    nohup ./runGrove.sh &

    cd ..
fi

if [[ $CAL_FLAG ]]; then 
    cd cal-server

    ./run.sh

    cd ..
fi
