#!/bin/bash


if [[ "$1" = "all" ]]; then
    sudo journalctl -f -u upaste -u badge -u homepage -u transfer -u slackat -u soundlog
elif [[ -z "$1" ]]; then
    sudo tail -F -f /var/log/nginx/error.log -f /var/log/nginx/access.log
else
    sudo journalctl -fu $1
fi
