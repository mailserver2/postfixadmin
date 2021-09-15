FROM alpine:3.14

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes"

ARG VERSION=3.3.10
ARG SHA256_HASH="b162cef0968225b33c251d5e7e872ca93ec790f275b874659f34b2ec69b9812c"

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
