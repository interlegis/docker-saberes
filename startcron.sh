#!/bin/sh

echo "Initiating cron daemon..."
crond -f -c /etc/crontabs

