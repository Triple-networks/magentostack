################################################################################
# Base image
################################################################################

FROM php:5.5-apache

################################################################################
# Build instructions
################################################################################

RUN a2enmod rewrite expires setenvif

# Install modules we need
RUN apt-get update && apt-get install -y \
        wget \
        vim \
        curl \
        cron \
        supervisor \
        mysql-client \
        git \
        locales \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libbz2-dev \
        libmhash-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        libsasl2-dev \
        libtidy-dev \
        libxml2-dev \
        libxslt1-dev \
        libxpm-dev \
        libcurl4-gnutls-dev \
        libicu-dev \
        libxslt-dev \
    && docker-php-ext-install mbstring pdo_mysql iconv mcrypt zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr \
    && docker-php-ext-install intl gd mysqli opcache xsl xmlrpc

RUN pecl install xdebug-beta
# && docker-php-ext-enable xdebug

RUN apt-get autoremove -y \
    && apt-get clean \
    && apt-get autoclean

RUN rm -rf /var/lib/apt/lists

# supervisord
RUN mkdir -p /var/log/supervisor
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# PHP

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
} > "$PHP_INI_DIR/conf.d/opcache-recommended.ini"

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
COPY conf/php/magento1.ini "$PHP_INI_DIR/conf.d/magento1.ini"
COPY conf/php/xdebug-custom.ini "$PHP_INI_DIR/conf.d/xdebug-custom.ini"


# Cron
RUN chmod 600 /etc/crontab

################################################################################
# WORKDIR
################################################################################

WORKDIR /var/run

################################################################################
# Volumes
################################################################################

# VOLUME ["/var/www"]

################################################################################
# Ports
################################################################################


################################################################################
# Entrypoint
################################################################################

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 80 443

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

