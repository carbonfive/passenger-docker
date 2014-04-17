#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install Postgres.
apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 libpq-dev

# UTF-8 encoding by default
rm -rf /var/lib/postgresql/9.3/main
sudo -u postgres /usr/lib/postgresql/9.3/bin/initdb -E 'UTF-8' -D /var/lib/postgresql/9.3/main

mkdir /etc/service/postgresql
cp /build/runit/postgresql /etc/service/postgresql/run
cp /build/config/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

touch /etc/service/postgresql/down
