#!/bin/sh

/usr/bin/php /var/www/localhost/htdocs/admin/cli/install.php --lang=pt_BR --wwwroot="$MOODLE_URL" --dataroot=/var/moodledata --dbtype=pgsql --dbhost="$MOODLE_DB_HOST" --dbname="$MOODLE_DB_NAME" --dbuser="$MOODLE_DB_USER" --dbpass="$MOODLE_DB_PASS" --fullname="Saberes" --shortname="Saberes" --adminuser=admin --adminpass="$MOODLE_ADMIN_PASS" --adminemail="suporte@interlegis.leg.br" --non-interactive --agree-license;

