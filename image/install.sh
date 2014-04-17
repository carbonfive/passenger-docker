#!/bin/bash
set -e
source /build/buildconfig
set -x

/build/enable_repos.sh
/build/prepare.sh
/build/pups.sh
/build/utilities.sh

if [[ "$ruby21" = 1 ]]; then /build/ruby2.1.sh; fi
if [[ "$python" = 1 ]]; then /build/python.sh; fi
if [[ "$nodejs" = 1 ]]; then /build/nodejs.sh; fi
if [[ "$redis" = 1 ]]; then /build/redis.sh; fi
if [[ "$memcached" = 1 ]]; then /build/memcached.sh; fi
if [[ "$postgresql" = 1 ]]; then /build/postgresql.sh; fi
if [[ "$unicorn" = 1 ]]; then /build/unicorn.sh; fi

/build/finalize.sh
