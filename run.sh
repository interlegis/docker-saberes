#!/bin/sh

# Se não existe moodledata, então é instalação inicial
if [ ! -d /var/moodledata ]; then
  mkdir /var/moodledata
fi


if [ ! -f /var/moodledata/placeholder ]; then 
  echo "placeholder" > /var/moodledata/placeholder
  # instala o moodle, criando objetos no BD e gerando arquivo config.php
  /usr/local/bin/install.sh
fi

# Sobrescreve config.php gerado, uma vez que faltam configurações de proxy, dentre outras. Isso deve ser feito sempre que for gerada nova imagem, uma vez que o código do github não contém o config.php
cp /var/www/localhost/htdocs/moodle-config.php /var/www/localhost/htdocs/config.php

# Executa comando de upgrade, caso haja atualizações a serem realizadas
#/usr/bin/php /var/www/localhost/htdocs/admin/cli/upgrade.php --non-interactive

# Atribui proprietário do moodledata e config.php
#chown apache:apache /var/www/localhost/htdocs -R
chown apache:apache /var/moodledata -R

# Inicializa o servidor web
exec /usr/sbin/httpd -D FOREGROUND
