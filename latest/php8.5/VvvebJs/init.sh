#!/bin/sh

if [ ! -d /var/www/html/public/demo ]; then
	curl -Lo /tmp/vvveb.zip $(sh -c 'curl -s https://api.github.com/repos/givanz/VvvebJs/releases/latest | grep "browser_download_url" | cut -d : -f 2,3 | tr -d \"') 
	unzip /tmp/vvveb.zip -d /var/www/html/public
	rm -rf /tmp/vvveb.zip
	chown -R www-data:www-data /var/www/html/public
	chmod -R 755 /var/www/html/public/demo
	ln -s /var/www/html/public/editor.php /var/www/html/public/index.php
fi

/usr/bin/supervisord -c /etc/supervisord.conf
