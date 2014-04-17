#!/bin/bash
set -e
source /build/buildconfig
set -x

mkdir /etc/service/unicorn
cp /build/runit/unicorn /etc/service/unicorn/run

touch /etc/service/unicorn/down
