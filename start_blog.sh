#!/bin/sh

PROFILE=release ./target/release/jyb-blog & 
echo $! > .procnum