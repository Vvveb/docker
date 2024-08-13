FROM php:8.3-apache

#change apache document root to public for better security
RUN sed -ri -e 's!/var/www/html!/var/www/vvveb/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/var/www/vvveb/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get clean \
  && apt-get update \
  && apt-get install -y \
  unzip \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libxml2-dev \
  libwebp-dev \
  libpng-dev \
  libzip-dev \
  libonig-dev \
  libcurl4-openssl-dev \
  && docker-php-ext-configure gd  --with-webp --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-install xml dom curl mbstring intl gettext \
  && docker-php-ext-install zip \
  && pecl bundle -d /usr/src/php/ext apcu \
  && docker-php-ext-install /usr/src/php/ext/apcu \
  && docker-php-ext-install mysqli \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

#RUN usermod -u ${PHP_USER_ID} www-data
RUN usermod -u 1000 www-data

COPY php.ini ${PHP_INI_DIR}

ENV DIR_VVVEB='/var/www/vvveb'
RUN chown -R www-data:www-data ${DIR_VVVEB}

RUN a2enmod rewrite
#RUN a2enmod lbmethod_byrequests

WORKDIR ${DIR_VVVEB}
EXPOSE 80

COPY init.sh /init.sh
RUN chmod +x /init.sh

#CMD ["apachectl", "-D", "FOREGROUND"]
#CMD ["apache2-foreground"]

CMD ["/init.sh"]
