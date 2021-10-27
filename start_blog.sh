#!/bin/sh

./build_pull_submodules.sh

cargo build --release

PROFILE=release ./target/release/jyb-blog & 
echo $! > .procnum