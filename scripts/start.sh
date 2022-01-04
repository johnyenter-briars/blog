#!/bin/bash

# move to root of project
cd ..

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--blog) BLOG_FLAG="$1"; shift ;;
        -c|--chrust) CHRUST_FLAG=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
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
    cd ..
    cargo build --release

    PROFILE=release nohup ./target/release/jyb-blog > jyb-blog.out 2> jyb-blog.err &

    echo $! > .procnum
fi


