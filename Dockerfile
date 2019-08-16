
FROM debian:stretch-slim

MAINTAINER Matheus Garcia <garcia.figueiredo@gmail.com>
MAINTAINER Fabio Rauber <fabiorauber@gmail.com>

ENV MOODLE_GITHUB=https://github.com/interlegis/moodle.git \
    MOODLE_DATA=/var/moodledata \
    MOODLE_REVERSEPROXY=false \
    MOODLE_SSLPROXY=false \
    SABERES_VERSION=3.7.0-20

EXPOSE 80

VOLUME ["/var/moodledata"]

RUN apt-get update \
 && apt-get install -y \
	ca-certificates \
	apt-transport-https \
	wget \
	gnupg \
 && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
 && echo "deb https://packages.sury.org/php/ stretch main" |  tee /etc/apt/sources.list.d/php.list

RUN apt-get update \
	&& apt-get install -y \
                       apt-utils \
                       vim \
                       cron \
                       git \
                       apache2 \
                       php7.3 \
                       libapache2-mod-php7.3 \
                       php7.3-iconv \
                       php7.3-pgsql \
                       php7.3-json \    
                       php7.3-xml \
                       php7.3-curl \
                       php7.3-zip \
                       php7.3-gd \
                       php7.3-dom \
                       php7.3-xmlreader \
                       php7.3-mbstring \
                       php7.3-xmlrpc \
                       php7.3-soap \
                       php7.3-intl \
                       php7.3-opcache \
                       php7.3-tokenizer \
                       php7.3-simplexml \
                       php7.3-ctype \
                       php7.3-fileinfo \
                       php7.3-ldap \		 
                       locales \
 && apt-get clean

ENV LC_ALL pt_BR.UTF-8
ENV LANG pt_BR.UTF-8

RUN cd /tmp \
 && git clone ${MOODLE_GITHUB} --depth=1 --branch SAB_${SABERES_VERSION} \
 && rm -rf /var/www/html \
 && cd moodle \
 && git submodule update --init \ 
 && git submodule update --init --recursive \
 && cd .. \
 && mv /tmp/moodle /var/www/html \
 && mkdir -p /run/apache2 \
 && mkdir -p /opt/apache2

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log 
# && ln -sf /proc/self/fd/1 /var/log/apache2/error.log

RUN locale-gen pt_BR.UTF-8 \
    && sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

COPY 00_limits.ini /etc/php/7.3/apache2/conf.d/00_limits.ini
COPY 00_opcache.ini /etc/php/7.3/apache2/conf.d/00_opcache.ini
COPY install.sh /usr/local/bin
COPY run.sh /opt/apache2/run.sh
COPY crontab /etc/cron.d
COPY startcron.sh /usr/local/bin

COPY moodle-config.php /var/www/html/config.php

CMD ["/opt/apache2/run.sh"]
