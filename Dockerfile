FROM php:7.4-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    zip \
    git \
    tar \
    nano \
    sed \
    unzip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Install multirun
RUN wget --no-check-certificate https://github.com/nicolas-van/multirun/releases/download/1.0.0/multirun-glibc-1.0.0.tar.gz && \
    tar -zxvf multirun-glibc-1.0.0.tar.gz && \
    mv multirun /bin && \
    rm multirun-glibc-1.0.0.tar.gz

# Install nginx
RUN apt-get update && apt-get -y install nginx && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/sites-enabled/*

# Configure PHP
ENV FPM_CONFIG=/usr/local/etc/php-fpm.d/zz-docker.conf
RUN mkdir -p /run/php && \
    sed -i -e "s/listen = .*/listen = \/run\/php\/php7.4-fpm.sock/g" $FPM_CONFIG && \
    echo "listen.owner = www-data" >> $FPM_CONFIG && \
    echo "listen.group = www-data" >> $FPM_CONFIG && \
    echo "listen.mode = 0660" >> $FPM_CONFIG

COPY nginx.conf /etc/nginx/

EXPOSE 80 443

ENTRYPOINT ["multirun"]

CMD ["php-fpm -F", "nginx", "-v"]