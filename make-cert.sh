#!/bin/bash

set -e

cmd="$1"

ok=true
if [ -z "$DOMAIN" ]; then
    echo "DOMAIN must be defined"
    ok=false
fi
if [ -z "$PROJECT_ROOT" ]; then
    echo "PROJECT_ROOT must be defined"
    ok=false
fi
if [ -z "$AUTH_HOOK" ]; then
    echo "AUTH_HOOK must be defined"
    ok=false
fi
if [ -z "$CLEANUP_HOOK" ]; then
    echo "CLEANUP_HOOK must be defined"
    ok=false
fi

if [ -z "$DRY_RUN" ]; then
    echo "DRY_RUN must be defined"
    ok=false
fi

dryrun="--dry-run"
if [[ "$DRY_RUN" = "false" ]]; then
    dryrun=""
fi

function check {
    if [[ ! "$1" = "true" ]]; then
        echo "invalid parameters..."
        exit 1
    fi
}


if [ "$cmd" = "new" ]; then
    if [ -z "$EMAIL" ]; then
        echo "EMAIL must be defined"
        ok=false
    fi

    check $ok
    set -x
    sudo certbot certonly \
        --manual \
        --email $EMAIL \
        --preferred-challenges=dns \
        --manual-auth-hook $PROJECT_ROOT/$AUTH_HOOK \
        --manual-cleanup-hook $PROJECT_ROOT/$CLEANUP_HOOK \
        --cert-name $DOMAIN \
        -d *.$DOMAIN \
        -d $DOMAIN \
        $dryrun
    set +x

elif [ "$cmd" = "renew" ]; then
    check $ok
    $0 new
    exit 0
else
    echo "command required"
    echo "  $0 new"
    echo "  $0 renew"
    exit 1
fi
