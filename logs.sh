#!/bin/bash

if [[ "$1" = "upaste" ]]; then
    sudo journalctl -fu upaste
else
    sudo tail -f /var/log/nginx/access.log
fi
