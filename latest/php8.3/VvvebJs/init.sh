#!/bin/sh

if [ ! -d /var/www/vvveb/public/demo ]; then
	curl -Lo /tmp/vvveb.zip $(sh -c 'curl -s https://api.github.com/repos/givanz/VvvebJs/releases/latest | grep "browser_download_url" | cut -d : -f 2,3 | tr -d \"') 
	unzip /tmp/vvveb.zip -d /var/www/vvveb/public
	rm -rf /tmp/vvveb.zip
	chown -R www-data:www-data /var/www/vvveb/public
	chmod -R 755 /var/www/vvveb/public/demo
	ln -s /var/www/vvveb/public/editor.php /var/www/vvveb/public/index.php
fi

/usr/bin/supervisord -c /etc/supervisord.conf
