# Docker Vvveb CMS Official Image

https://github.com/Vvveb/docker

https://github.com/givanz/Vvveb

# What is Vvveb?

## Powerful and easy to use CMS to build websites, blogs or ecommerce stores.

![logo](https://www.vvveb.com/admin/default/img/logom.png)

### [Live Demo](https://demo.vvveb.com) / [Admin Demo](https://demo.vvveb.com/admin) / [Page Builder Demo](https://demo.vvveb.com/admin/?module=/editor/editor&template=index.html&url=/)

[![](https://www.vvveb.com/img/dark-theme.png)](https://www.vvveb.com/img/dark-theme.png)

# How to use this image

With SQLite

```console
docker run -p 8080:80 vvveb/vvvebcms:php8.3-fpm-alpine
```
With MySQL

```console
docker run --name some-vvveb --link some-mysql:mysql -d vvveb/vvvebcms:php8.3-fpm-alpine
```

With PosgreSQL

```console
docker run --name some-vvveb --link some-pgsql:pgsql -d vvveb/vvvebcms:php8.3-fpm-alpine
```

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.

The following environment variables are also honored for configuring your Vvveb CMS instance:

- `-e DB_ENGINE=...` (valid values are `mysqli`, `sqlite`, `pgsql` defaults to `mysqli` )
- `-e DB_HOST=...` (defaults to the IP and port of the linked `mysql` container, eg: `db`)
- `-e DB_USER=...` (defaults to "root")
- `-e DB_PASS=...` (defaults to the value of the `MYSQL_ROOT_PASSWORD` environment variable from the linked `mysql` container)
- `-e DB_NAME=...` (defaults to "vvveb")
- `-e DB_PORT=...` (defaults to 3306)

The `DB_NAME` database **must already exist** on the given MySQL server. Check out the [official mysql image](https://hub.docker.com/_/mysql/) for more info.

If you'd like to use an external database instead of a linked `mysql` container, specify the hostname and port with `DB_HOST`:`DB_PORT` along with the password in `DB_PASSWORD` and the username in `DB_USER`:

```console
docker run --name vvveb \
  -e DB_HOST=10.1.2.3 \
  -e DB_PORT=10432 \
  -e DB_USER=... \
  -e DB_PASSWORD=... \
  -d vvveb/vvvebcms:php8.3-fpm-alpine
```

## Via [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml` for `Vvveb`:

```yaml
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: vvveb
      MYSQL_DATABASE: vvveb
      MYSQL_USER: vvveb
      MYSQL_PASSWORD: vvveb
    volumes:
      - db:/var/lib/mysql
    networks:
      - internal

  php:
    image: vvveb/vvvebcms:php8.3-fpm-alpine
    environment:
      DB_HOST: db
      DB_DATABASE: vvveb
      DB_USER: vvveb
      DB_PASSWORD: vvveb
      DB_ENGINE: mysqli #sqlite,pgsql
    volumes:
      - vvveb-volume:/var/www/html
      - db:/var/lib/mysql
    ports:
      - "8080:80"
    links:
      - db:mysql
    depends_on:
      - db
    networks:
      - internal


volumes:
  vvveb-volume:
  db:

networks:
  internal:
    driver: bridge
```

Run `docker-compose up` and visit `http://localhost:8080` or `http://host-ip:8080`.

# License

View [license information](https://github.com/givanz/Vvveb?tab=AGPL-3.0-1-ov-file#readme) for the software contained in this image.

# User Feedback

## Documentation
- [Vvveb CMS Documentation](https://docs.vvveb.com/)

## Issues
- [Vvveb CMS Issue Queue](https://github.com/givanz/Vvveb/issues)

## Forum
- [Vvveb CMS Forum](https://github.com/givanz/Vvveb/discussions)

## Contributing
- [Contribute to the Vvveb CMS Open Source Project](http://www.vvveb.com/page/contribute)

# Building images from Dockerfile

## PHP 8.3 Fpm Alpine

```console
cd latest/php8.3/fpm-alpine
sudo docker buildx build --push -t vvveb/vvvebcms:php8.3-fpm-alpine \
	--platform=linux/amd64,linux/amd64/v2,linux/amd64/v3,linux/386,linux/arm64,linux/arm/v8,linux/arm/v7,linux/arm/v6 .
```
## PHP 8.3 Apache

```console
cd latest/php8.3/apache
sudo docker buildx build --push -t vvveb/vvvebcms:php8.3-apache \
	--platform=linux/amd64,linux/amd64/v2,linux/amd64/v3,linux/386,linux/arm64,linux/arm/v8,linux/arm/v7,linux/arm/v6 .
```

