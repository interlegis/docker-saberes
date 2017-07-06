#!/bin/sh

if [ ! -f /var/moodledata/placeholder ]; then 
  chown -R apache:apache /var/moodledata
  echo "placeholder" > /var/moodledata/placeholder
fi

exec /usr/sbin/httpd -D FOREGROUND
