#!/bin/bash

echo "placeholder" > /var/www/moodledata/placeholder
chown -R www-data:www-data /var/www/moodledata
chmod 777 /var/www/moodledata

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
