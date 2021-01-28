FROM alpine:3.13

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes" \
    maintainer="Hardware <contact@meshup.net>"

ARG VERSION=3.3.5
ARG SHA256_HASH="675c6278b14db4efa35d264c4c28abc9b5f131f31f2d52f74c46a1d3dcaff97d"

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
    rm -f ${PFA_TARBALL}; \
    chmod 644 /etc/ssl/dovecot/server.key

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
