#!/bin/sh

# Se não existe moodledata, então é instalação inicial
if [ ! -d /var/moodledata ]; then
  mkdir /var/moodledata
fi


if [ ! -f /var/moodledata/placeholder ]; then 
  echo "placeholder" > /var/moodledata/placeholder
  # instala o moodle, criando objetos no BD e gerando arquivo config.php
  /usr/local/bin/install.sh
  # sobrescreve config.php gerado, uma vez que faltam configurações de proxy, dentre outras
  cp /var/www/localhost/htdocs/moodle-config.php /var/www/localhost/htdocs/config.php
fi

# Atribui proprietário do moodledata e config.php
chown apache:apache /var/www/localhost/htdocs -R
chown apache:apache /var/moodledata -R

# Inicializa o servidor web
exec /usr/sbin/httpd -D FOREGROUND
