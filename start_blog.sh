#!/bin/sh

cargo build --release

nohup PROFILE=release ./target/release/jyb-blog & 
echo $! > .procnum