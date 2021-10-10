#!/bin/bash


if [[ "$1" = "all" ]]; then
    sudo journalctl -f -u upaste -u badge -u homepage -u transfer -u slackat -u soundlog -u ritide -u outside
elif [[ -z "$1" ]]; then
    sudo tail -Ff /var/log/nginx/error.log -Ff /var/log/nginx/access.log
else
    sudo journalctl -fu $1
fi
