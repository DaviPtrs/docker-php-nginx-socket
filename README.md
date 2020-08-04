# docker-php-nginx-socket
A docker image with nginx and php7.4-fpm using unix socket to listen

## Config PHP-FPM
To config overwrite or set any fpm config, just add use the following method:
```Dockerfile
RUN echo "config = example" >> $FPM_CONFIG
```
