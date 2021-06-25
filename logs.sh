#!/bin/bash


if [[ "$1" = "upaste" ]]; then
    sudo journalctl -fu upaste
elif [[ "$1" = "badge" ]]; then
    sudo journalctl -fu badge
elif [[ "$1" = "homepage" ]]; then
    sudo journalctl -fu homepage
elif [[ "$1" = "all" ]]; then
    sudo journalctl -f -u upaste -u badge -u homepage
else
    sudo tail -f /var/log/nginx/access.log
fi
