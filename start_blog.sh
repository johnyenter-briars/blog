#!/bin/sh
cargo build --release

PROFILE=release nohup ./target/release/jyb-blog & > jyb-blog.out 2> jyb-blog.err

echo $! > .procnum