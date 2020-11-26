# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM php:7.4-fpm

WORKDIR /usr/local/apache2/htdocs/

RUN apt-get update && apt-get install -y subversion \
  unzip git wget vim-tiny apt-transport-https \
  libfreetype6-dev libjpeg62-turbo-dev \
  libmagickwand-dev  \
  libgmp-dev \
  libgeoip-dev \
  libxslt-dev \
  libmcrypt-dev \
  libyaml-dev \
  gearman-job-server \
  libcurl3-openssl-dev \
  libevent-dev libicu-dev \
  libgearman-dev \
  libzip-dev \
  && apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Install yarn, Node.js
RUN apt-get update && apt-get install -my wget gnupg
RUN curl -sS https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y \
    yarn \
    nodejs

#libav-tools -> ffmpeg
#libgearman-dev -> GearmanClient

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
 && docker-php-ext-install -j$(nproc) gd iconv \
 && pecl install propro-2.1.0 raphf-2.0.0 \
    imagick geoip-1.1.1 \
    mcrypt-1.0.3 yaml-2.0.4 \
 && docker-php-ext-enable propro raphf imagick geoip mcrypt yaml

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap mysqli bz2 exif \
                              gettext intl \
                              pcntl pdo_mysql \
                              shmop soap sockets sysvmsg \
                              sysvsem sysvshm xmlrpc \
                              zip xsl opcache \
    && docker-php-ext-install -j$(nproc) gmp bcmath

#RUN apt-get update && apt-get install -y libevent-dev
#RUN apt-get update && apt-get install -y libicu-dev
#pecl_http has to run after raphf & propro & co got installed and activated :(
RUN yes "" | pecl install pecl_http-3.2.0
RUN docker-php-ext-enable http

RUN wget https://github.com/wcgallego/pecl-gearman/archive/master.zip ; \
    unzip master.zip ; \
    cd pecl-gearman-master ; \
    phpize ; \
    ./configure ; \
    make install  ; \
    echo "extension=gearman.so" > /usr/local/etc/php/conf.d/gearman.ini  ; \
    cd .. ; \
    rm -r pecl-gearman-master ; \
    rm master.zip ; \
    mkdir -p /usr/local/etc/php/extra/ ; \
    wget "https://browscap.org/stream?q=BrowsCapINI" -q -O /usr/local/etc/php/extra/full_php_browscap.ini ; \
    echo "browscap = /usr/local/etc/php/extra/full_php_browscap.ini" > /usr/local/etc/php/conf.d/browscap.ini


RUN gearmand -d
# install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "upload_max_filesize = 200M" >> /usr/local/etc/php/conf.d/upload-size.ini
RUN echo "post_max_size = 200M" >> /usr/local/etc/php/conf.d/upload-size.ini

RUN echo "memory_limit = 4096M" >> /usr/local/etc/php/conf.d/php.ini

RUN echo "max_execution_time = -1" >> /usr/local/etc/php/conf.d/php.ini

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

WORKDIR /var/www/symfony

