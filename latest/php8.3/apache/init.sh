#!/bin/sh

if [ ! -d /var/www/vvveb/public/ ]; then
	export DIR_VVVEB='/var/www/vvveb'
	export DIR_CONFIG=${DIR_VVVEB}'/config'
	export DIR_PUBLIC=${DIR_VVVEB}'/public'
	export DIR_PLUGINS=${DIR_VVVEB}'/plugins'
	export DIR_STORAGE=${DIR_VVVEB}'/storage'
	export DIR_CACHE=${DIR_STORAGE}'/cache'
	export DIR_ADMIN=${DIR_VVVEB}'/admin'
	export DIR_DIGITAL_ASSETS=${DIR_STORAGE}'/digital_assets'
	export DIR_IMAGE_CACHE=${DIR_PUBLIC}'/image-cache'

	curl -Lo /tmp/vvveb.zip https://www.vvveb.com/download.php 
	unzip /tmp/vvveb.zip -d ${DIR_VVVEB}
	rm -rf /tmp/vvveb.zip
	
	chown -R www-data:www-data ${DIR_VVVEB}
	chmod -R 744 ${DIR_VVVEB}
	chmod -R 733 ${DIR_STORAGE}
	#chmod 733 ${DIR_STORAGE}

	chmod -R 733 ${DIR_PUBLIC}
	chmod -R 744 ${DIR_PUBLIC}/index.php
	chmod -R 744 ${DIR_PUBLIC}/admin/index.php
	chmod -R 744 ${DIR_PUBLIC}/vadmin/index.php
	#chmod 733 ${DIR_PUBLIC}
	#chmod -R 733 ${DIR_PUBLIC}/admin
	#chmod -R 733 ${DIR_PUBLIC}/vadmin
	#chmod -R 733 ${DIR_PUBLIC}/themes
	#chmod -R 733 ${DIR_PUBLIC}/install
	#chmod 744 ${DIR_VVVEB}/admin
	#chmod -R 744 ${DIR_VVVEB}/install

	#chmod -R 744 ${DIR_PUBLIC}/media
	#chmod -R 744 ${DIR_PUBLIC}/plugins
	#chmod 733 ${DIR_PUBLIC}/media
	#chmod 733 ${DIR_PUBLIC}/plugins

	chmod -R 733 ${DIR_CONFIG}
	#chmod 733 ${DIR_CONFIG}

	#chmod -R 744 ${DIR_PLUGINS}
	#chmod -R 744 ${DIR_CACHE}
	#chmod -R 744 ${DIR_DIGITAL_ASSETS}
	#chmod -R 744 ${DIR_IMAGE_CACHE}
fi

/usr/bin/supervisord -c /etc/supervisord.conf
