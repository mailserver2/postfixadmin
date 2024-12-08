FROM alpine:3.21

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes"

ARG VERSION=3.3.14
ARG PHP_VERSION=84
ARG SHA256_HASH="bd48687431472dc1753513bdf38a498f6b913d3c04a8e4d6d2415d190760e5a3"

RUN set -eux; \
    apk update && apk upgrade; \
    apk add --no-cache \
        su-exec \
        dovecot \
        tini \
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-imap \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-pdo_mysql \
        php${PHP_VERSION}-pdo_pgsql \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-phar \
        php${PHP_VERSION}-session \
    ; \
    \
    PFA_TARBALL="postfixadmin-${VERSION}.tar.gz"; \
    wget -q https://github.com/postfixadmin/postfixadmin/archive/${PFA_TARBALL}; \
    echo "${SHA256_HASH} *${PFA_TARBALL}" | sha256sum -c; \
    \
    mkdir /postfixadmin; \
    tar -xzf ${PFA_TARBALL} --strip-components=1 -C /postfixadmin; \
    rm -f ${PFA_TARBALL}; \
    chmod 644 /etc/ssl/dovecot/server.key

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
