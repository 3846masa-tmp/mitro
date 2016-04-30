#!/bin/bash

WORKDIR=/srv/emailer

# check environment variables
[ -z "${DB_PORT_5432_TCP_ADDR}" ] && echo "The Postgres container is not correctly linked! Add --link postgres:db to the docker run parameters!" && exit 1
[ -z "${DB_ENV_POSTGRES_PASSWORD}" ] && echo "Undefined postgres password! Add --link postgres:db to the docker run parameters!" && exit 1
[ -z "${MAILGUN_API_KEY}" ] && echo "Undefined Mailgun API KEY! Add -e MAILGUN_API_KEY=\"apikey\" to the docker run parameters!" && exit 1
[ -z "${MAILGUN_DOMAIN}" ] && echo "Undefined Mailgun Domain! Add -e MAILGUN_DOMAIN=\"domain\" to the docker run parameters!" && exit 1
[ -z "${DOMAIN}" ] && echo "Domain undefined! Add -e DOMAIN=\"ip or domain name\" to the docker run parameters!" && exit 1

cp $WORKDIR/config.ini.example $WORKDIR/config.ini
sed -i "s/provider = smtp/provider = mailgun/" $WORKDIR/config.ini
sed -i "/\[database\]/{n;s/.*/hostname = ${DB_PORT_5432_TCP_ADDR}/}" $WORKDIR/config.ini
sed -i "s/username = mitro/username = postgres/" $WORKDIR/config.ini
sed -i "s/password = mitro/password = ${DB_ENV_POSTGRES_PASSWORD}/" $WORKDIR/config.ini
sed -i "s/issues@mitro.co/developers@example.com/" $WORKDIR/config.ini
sed -i "s/no-reply@mitro.co/no-reply@example.com/" $WORKDIR/config.ini
sed -i "s/mitro.co/${DOMAIN}/" $WORKDIR/config.ini
sed -i "/\[mailgun\]/{n;s/.*/domain = ${MAILGUN_DOMAIN}/}" $WORKDIR/config.ini
sed -i "/\[mailgun\]/{n;n;s/.*/api_key = ${MAILGUN_API_KEY}/}" $WORKDIR/config.ini

sed -i "s/logging.INFO/logging.DEBUG/" $WORKDIR/emailer.py

exec "$@"
