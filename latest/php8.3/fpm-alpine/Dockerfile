FROM php:8.3-fpm-alpine

ARG DOWNLOAD_URL

ENV DIR_VVVEB='/var/www/vvveb/'
ENV DIR_CONFIG=${DIR_VVVEB}'/config'
ENV DIR_PUBLIC=${DIR_VVVEB}'/public'
ENV DIR_PLUGINS=${DIR_VVVEB}'/plugins'
ENV DIR_STORAGE=${DIR_VVVEB}'/storage'
ENV DIR_CACHE=${DIR_STORAGE}'/cache'
ENV DIR_ADMIN=${DIR_VVVEB}'/admin'
ENV DIR_DIGITAL_ASSETS=${DIR_STORAGE}'/digital_assets'
ENV DIR_IMAGE_CACHE=${DIR_PUBLIC}'/image-cache'


RUN apk update && \
	apk add --no-cache \
	nginx \
	supervisor \
	unzip \
	;

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		freetype-dev \
		icu-dev \
		imagemagick-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libwebp-dev \
		libzip-dev \
		icu-dev \
		gettext-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	; \
	docker-php-ext-install -j "$(nproc)" \
		bcmath \
		exif \
		gd \
		gettext \
		intl \
		mysqli \
		zip \
	; \
	extDir="$(php -r 'echo ini_get("extension_dir");')"; \
	[ -d "$extDir" ]; \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive "$extDir" \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-network --virtual .phpexts-rundeps $runDeps; \
	apk del --no-network .build-deps \
		$PHPIZE_DEPS \
		gcc \
	; \
	! { ldd "$extDir"/*.so | grep 'not found'; }; \
	err="$(php --version 3>&1 1>&2 2>&3)"; \
	[ -z "$err" ]

RUN if [ -z "$DOWNLOAD_URL" ]; then \
  curl -Lo /tmp/vvveb.zip https://www.vvveb.com/download.php; \
  else \
  curl -Lo /tmp/vvveb.zip ${DOWNLOAD_URL}; \
  fi

RUN unzip /tmp/vvveb.zip -d ${DIR_VVVEB} && rm -rf /tmp/vvveb.zip

RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data || true
#RUN mkdir /var/lib/nginx/tmp/client_body
#RUN chown -R www-data:www-data /var/lib/nginx
#RUN chmod -R 755 /var/lib/nginx

RUN sed -ri -e 's!user nginx;!user www-data;!g' /etc/nginx/nginx.conf

WORKDIR ${DIR_VVVEB}

RUN chown -R www-data:www-data ${DIR_VVVEB}
RUN chmod -R 555 ${DIR_VVVEB}
RUN chmod -R 744 ${DIR_STORAGE}
RUN chmod 555 ${DIR_STORAGE}

RUN chmod -R 744 ${DIR_PUBLIC}
RUN chmod 555 ${DIR_PUBLIC}
#RUN chmod -R 644 ${DIR_PUBLIC}/admin
#RUN chmod -R 744 ${DIR_PUBLIC}/themes
RUN chmod -R 744 ${DIR_VVVEB}/admin
RUN chmod -R 744 ${DIR_VVVEB}/public/vadmin
RUN chmod 555 ${DIR_VVVEB}/admin
#RUN chmod -R 644 ${DIR_PUBLIC}/install
RUN chmod -R 755 ${DIR_VVVEB}/install
RUN chmod 555 ${DIR_VVVEB}/install

#RUN chmod -R 744 ${DIR_PUBLIC}/media
#RUN chmod -R 744 ${DIR_PUBLIC}/plugins
RUN chmod 555 ${DIR_PUBLIC}/media
RUN chmod 555 ${DIR_PUBLIC}/plugins

RUN chmod -R 744 ${DIR_CONFIG}
RUN chmod 555 ${DIR_CONFIG}

RUN chmod -R 755 ${DIR_PLUGINS}
RUN chmod -R 755 ${DIR_CACHE}
RUN chmod -R 755 ${DIR_DIGITAL_ASSETS}
RUN chmod -R 755 ${DIR_IMAGE_CACHE}

COPY nginx-docker.conf /etc/nginx/http.d/vvveb.conf
RUN rm /etc/nginx/http.d/default.conf

COPY supervisord.conf /etc/

EXPOSE 80

#CMD ["php-fpm", "-F"]
#CMD ["nginx", "-g", "daemon off;"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
