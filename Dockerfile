FROM alpine:3.13

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes" \
    maintainer="Hardware <contact@meshup.net>"

ARG VERSION=3.3.2
ARG SHA256_HASH="9d9ed67405bb717d41024e2c0e7ba3acecd3f1b977b4d95ab7211bbfc623908d"

RUN set -eux; \
    apk add --no-cache \
        su-exec \
        dovecot \
        tini \
        \
        php8 \
        php8-fpm \
        php8-imap \
        php8-mbstring \
        php8-mysqli \
        php8-pdo \
        php8-pdo_mysql \
        php8-pdo_pgsql \
        php8-pgsql \
        php8-phar \
        php8-session \
    ; \
    \
    PFA_TARBALL="postfixadmin-${VERSION}.tar.gz"; \
    wget -q https://github.com/postfixadmin/postfixadmin/archive/${PFA_TARBALL}; \
    echo "${SHA256_HASH} *${PFA_TARBALL}" | sha256sum -c; \
    \
    mkdir /postfixadmin; \
    tar -xzf ${PFA_TARBALL} --strip-components=1 -C /postfixadmin; \
    rm -f ${PFA_TARBALL}

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
