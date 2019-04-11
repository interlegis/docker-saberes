#!/bin/sh

#Copia variáveis de ambiente criadas pelo Rancher
#no arquivo que será lido antes de cada task do cron
env > /etc/environment

echo "Initiating cron daemon..."
/usr/sbin/cron -f 
