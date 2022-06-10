FROM php:7.1-fpm

RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
&& apt-get clean \
&& apt-get update \
&& apt-get install -y curl \
&& docker-php-ext-install -j$(nproc) iconv && docker-php-ext-install bcmath sockets pdo_mysql \
&& mkdir -p /usr/src/php/ext   
WORKDIR /tmp   

# wget https://pecl.php.net/get/redis-4.0.0.tgz
COPY ./redis-4.0.0.tgz /tmp/redis-4.0.0.tgz     
RUN tar -xf redis-4.0.0.tgz && rm redis-4.0.0.tgz \
&& rm package.xml \
&& mv redis-4.0.0 /usr/src/php/ext/redis \
&& docker-php-ext-install redis

# wget http://xdebug.org/files/xdebug-2.8.0.tgz
COPY ./xdebug-2.8.0.tgz /tmp/xdebug-2.8.0.tgz
RUN tar -xf xdebug-2.8.0.tgz && rm xdebug-2.8.0.tgz \
&& mv xdebug-2.8.0 /usr/src/php/ext/xdebug \
&& docker-php-ext-install xdebug 
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
