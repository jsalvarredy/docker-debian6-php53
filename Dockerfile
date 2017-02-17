FROM debian:6
MAINTAINER Joaquin Salvarredy <joaquin@salvarredy.com.ar>
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.debian.org/debian squeeze main" > /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian squeeze-proposed-updates main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --force-yes locales  libapache2-mod-rpaf apache2 apache2-mpm-prefork \
	libapache2-mod-php5 php5 php-apc php5-cli php5-common php5-pgsql php5-curl php5-gd php5-imagick php5-intl \
	php5-mcrypt php5-mysql php5-xmlrpc php-db php5-xsl php5-suhosin php5-memcache php5-tidy php5-xsl 

RUN apt-get install -y --force-yes postfix mailutils rsyslog


# Configure timezone and locale
RUN echo "America/Argentina/Buenos_Aires" > /etc/timezone && \
        dpkg-reconfigure -f noninteractive tzdata

RUN echo 'es_AR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'es_ES.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN export LANGUAGE=es_ES.UTF-8 && \
        export LANG=es_ES.UTF-8 && \
        export LC_ALL=es_ES.UTF-8 && \
        locale-gen es_ES.UTF-8 && \
        DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales


RUN apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


# Let's set the default timezone in both cli and apache configs
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Argentina\/Buenos_Aires/g' /etc/php5/cli/php.ini && \
	sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Argentina\/Buenos_Aires/g' /etc/php5/apache2/php.ini

# Let's set the upload_max_file
RUN sed -i 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 100M/g' /etc/php5/apache2/php.ini

# Let's set the post_max_size
RUN  sed -i 's/post_max_size\ =\ 8M/post_max_size\ =\ 100M/g' /etc/php5/apache2/php.ini


WORKDIR /var/www
VOLUME ["/var/www"]

# Other Dockerfile directives are still valid
EXPOSE 80
COPY start.sh /start.sh
CMD ["/start.sh"]

