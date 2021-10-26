#!/bin/sh

./build_pull_submodules.sh

PROFILE=release ./target/release/jyb-blog & 
echo $! > .procnum