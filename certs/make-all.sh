#!/bin/bash

set -ex

cmd="$1"
domain="$2"

if [ "$cmd" = "new" ]; then
    if [[ -z "$domain" ]]; then
        DOMAIN=kominick.com ./certs/make-cert.sh new
        DOMAIN=kominick.org ./certs/make-cert.sh new
        DOMAIN=kominick.dev ./certs/make-cert.sh new
        DOMAIN=slackat.com ./certs/make-cert.sh new
        DOMAIN=soundlog.co ./certs/make-cert.sh new
        DOMAIN=feelsgut.com ./certs/make-cert.sh new
        DOMAIN=didpoop.com ./certs/make-cert.sh new
    else
        DOMAIN="$domain" ./certs/make-cert.sh new
    fi
elif [ "$cmd" = "renew" ]; then
    if [[ -z "$domain" ]]; then
        DOMAIN=kominick.com ./certs/make-cert.sh renew
        DOMAIN=kominick.org ./certs/make-cert.sh renew
        DOMAIN=kominick.dev ./certs/make-cert.sh renew
        DOMAIN=slackat.com ./certs/make-cert.sh renew
        DOMAIN=soundlog.co ./certs/make-cert.sh renew
        DOMAIN=feelsgut.com ./certs/make-cert.sh renew
        DOMAIN=didpoop.com ./certs/make-cert.sh renew
    else
        DOMAIN="$domain" ./certs/make-cert.sh renew
    fi
else
    echo "command required"
    echo "  $0 new"
    echo "  $0 renew"
    exit 1
fi
