ARG LARADOCK_PHP_VERSION

FROM laradock/workspace:2.6.1-${LARADOCK_PHP_VERSION}

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}
RUN groupadd -g ${PGID} laradock && \
    useradd -u ${PUID} -g laradock -m laradock -G docker_env && \
    usermod -p "*" laradock -s /bin/bash
USER laradock

RUN mkdir -p /home/laradock/.ssh && \
    chmod 0700 /home/laradock/.ssh && \
    ssh-keyscan gitlab.com > /home/laradock/.ssh/known_hosts

USER root

COPY authentication/id_rsa_docker_gitlab /home/laradock/.ssh/id_rsa 
RUN chmod 666 /home/laradock/.ssh/id_rsa
COPY authentication/id_rsa_docker_gitlab.pub /home/laradock/.ssh/id_rsa.pub
RUN chmod 666 /home/laradock/.ssh/id_rsa.pub 

USER laradock

RUN mkdir -p /home/laradock/app
RUN git clone git@gitlab.com:smgMusicDisplay/smgmusicdisplay.com.git /home/laradock/app

USER laradock
WORKDIR /home/laradock/app/server
RUN composer global require hirak/prestissimo
RUN composer install --prefer-dist --no-scripts --no-progress --no-suggest --no-interaction --no-dev
RUN composer dump-autoload --optimize --no-dev
RUN rm -rf storage bootstrap/cache public/downloads public/uploads

ARG LARADOCK_PHP_VERSION

FROM laradock/workspace:2.6.1-${LARADOCK_PHP_VERSION}
WORKDIR /var/www

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}
RUN groupadd -g ${PGID} laradock && \
    useradd -u ${PUID} -g laradock -m laradock -G docker_env && \
    usermod -p "*" laradock -s /bin/bash

COPY --from=0 /home/laradock/app/server /var/wwww
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
