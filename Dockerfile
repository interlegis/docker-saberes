
FROM debian:stretch-slim

MAINTAINER Matheus Garcia <garcia.figueiredo@gmail.com>
MAINTAINER Fabio Rauber <fabiorauber@gmail.com>

ENV MOODLE_GITHUB=https://github.com/interlegis/moodle.git \
    MOODLE_DATA=/var/moodledata \
    MOODLE_REVERSEPROXY=false \
    MOODLE_SSLPROXY=false \
    SABERES_VERSION=3.4.2-16

EXPOSE 80

VOLUME ["/var/moodledata"]

RUN apt-get update \
 && apt-get install -y \
                       apt-utils \
                       vim \
                       cron \
                       git \
                       apache2 \
                       php7.0 \
                       libapache2-mod-php7.0 \
                       php7.0-iconv \
                       php7.0-pgsql \
#                       php7.0-session \
                       php7.0-json \    
                       php7.0-xml \
                       php7.0-curl \
                       php7.0-zip \
#                       php7.0-zlib \
                       php7.0-gd \
                       php7.0-dom \
                       php7.0-xmlreader \
                       php7.0-mbstring \
#                       php7.0-openssl \
                       php7.0-xmlrpc \
                       php7.0-soap \
                       php7.0-intl \
                       php7.0-opcache \
                       php7.0-tokenizer \
                       php7.0-simplexml \
                       php7.0-ctype \
                       php7.0-fileinfo \ 
                       locales \
 && apt-get clean

ENV LC_ALL pt_BR.UTF-8
ENV LANG pt_BR.UTF-8

RUN cd /tmp \
 && git clone ${MOODLE_GITHUB} --depth=1 --branch SAB_${SABERES_VERSION} \
 && rm -rf /var/www/html \
 && cd moodle \
 && git submodule init \
 && git submodule update \ 
 && cd .. \
 && mv /tmp/moodle /var/www/html \
 && mkdir -p /run/apache2 \
 && mkdir -p /opt/apache2

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
 && ln -sf /proc/self/fd/1 /var/log/apache2/error.log

RUN locale-gen pt_BR.UTF-8 \
    && sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

COPY 00_limits.ini /etc/php/7.2/apache2/conf.d/00_limits.ini
COPY 00_opcache.ini /etc/php/7.2/apache2/conf.d/00_opcache.ini
COPY install.sh /usr/local/bin
COPY run.sh /opt/apache2/run.sh
COPY crontab /etc/cron.d
COPY startcron.sh /usr/local/bin

COPY moodle-config.php /var/www/html/config.php

CMD ["/opt/apache2/run.sh"]
