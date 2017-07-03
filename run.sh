#!/bin/sh

echo "placeholder" > /var/moodledata/placeholder
chown -R apache:apache /var/moodledata

exec /usr/sbin/httpd -D FOREGROUND
