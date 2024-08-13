FROM php:8.3-fpm-alpine

RUN apk update && \
	apk add --no-cache \
	nginx \
	supervisor


RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data || true
RUN mkdir /var/lib/nginx/tmp/client_body
RUN chown -R www-data:www-data /var/lib/nginx
RUN chmod -R 755 /var/lib/nginx

RUN sed -ri -e 's!user nginx;!user www-data;!g' /etc/nginx/nginx.conf
RUN sed -ri -e 's!client_max_body_size 1m;!client_max_body_size 50m;!g' /etc/nginx/nginx.conf

ENV DIR_VVVEB='/var/www/vvveb/public'

WORKDIR ${DIR_VVVEB}

RUN chown -R www-data:www-data ${DIR_VVVEB}
#RUN chmod -R 755 ${DIR_VVVEB}

COPY nginx-docker.conf /etc/nginx/http.d/vvveb.conf
RUN rm /etc/nginx/http.d/default.conf

COPY www.conf /usr/local/etc/php-fpm.d/
COPY php.ini /usr/local/etc/php/
COPY supervisord.conf /etc/

COPY init.sh /init.sh
RUN chmod +x /init.sh

WORKDIR ${DIR_VVVEB}
VOLUME ${DIR_VVVEB}

EXPOSE 80

#CMD ["php-fpm", "-F"]
#CMD ["nginx", "-g", "daemon off;"]
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

CMD ["/init.sh"]
