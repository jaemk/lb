#!/bin/bash

set -ex

cmd="$1"

if [ "$cmd" = "new" ]; then
    DOMAIN=kominick.com ./certs/make-cert.sh new
    DOMAIN=kominick.org ./certs/make-cert.sh new
    DOMAIN=kominick.dev ./certs/make-cert.sh new

elif [ "$cmd" = "renew" ]; then
    DOMAIN=kominick.com ./certs/make-cert.sh renew
    DOMAIN=kominick.org ./certs/make-cert.sh renew
    DOMAIN=kominick.dev ./certs/make-cert.sh renew
else
    echo "command required"
    echo "  $0 new"
    echo "  $0 renew"
    exit 1
fi
