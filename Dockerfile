FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
	apt -y install wget \
	nginx \
	mariadb-server \
	mariadb-client \
	php-cgi \
	php-common \
	php-fpm \
	php-pear \
	php-mbstring \
	php-zip \
	php-net-socket \
	php-gd \
	php-xml-util \
	php-mysql \
	php-bcmath \
	openssl

WORKDIR /etc/nginx/ssl

RUN openssl genrsa -out server.key 2048 \
	&& openssl req -new -key server.key -out server.csr -subj "/CN=localhost" \
	&& openssl x509 -days 3650 -req -signkey server.key -in server.csr -out server.crt

COPY ./srcs/default /etc/nginx/sites-available/default
COPY ./srcs/wordpress.conf /etc/nginx/sites-available/wordpress.conf
RUN ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz \
	&& tar xvzf latest.tar.gz

COPY ./srcs/wp-config.php ./wordpress

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvzf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& chown -R www-data:www-data ./

RUN service mysql restart \
	&& mysql -e "CREATE DATABASE dbname;" \
	&& mysql -e "CREATE USER 'user'@'localhost' identified by 'password';" \
	&& mysql -e "GRANT ALL PRIVILEGES ON dbname. * TO 'user'@'localhost';" \
	&& mysql -e "FLUSH PRIVILEGES;" \
	&& mysql -e "EXIT"

CMD service nginx start \
	&& service php7.4-fpm start \
	&& service mysql start \
	&& tail -f /dev/null
