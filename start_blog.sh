#!/bin/sh

cargo build --release

PROFILE=release ./target/release/jyb-blog & 
echo $! > .procnum