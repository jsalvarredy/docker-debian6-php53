# docker-debian6-php53

Contenedor que esta en basado en un Debian 6 que tiene instalado php 5.3 con el modulo de mysql
Además tiene un servidor de correo postfix para el envio de mail.
Si se esta atras de un nginx-proxy utilizando una variable se puede ver la dirección IP origen

## Uso
```
	docker run -d -e MAIL_DOMAIN=ejemplo.com.ar \
	-e USER_ID=`id -u`-v `pwd`:/var/www \
	jsalvarredy/debian6-php53
```

## Uso detras de un nginx-proxy
```
	docker run -d -e MAIL_DOMAIN=ejemplo.com.ar \
	-e USER_ID=`id -u`-v `pwd`:/var/www \
	-e IP_NGINXPROXY=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' nginxproxy` \
	jsalvarredy/debian6-php53
```

