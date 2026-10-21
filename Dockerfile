FROM alpine:3.24

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes"

ARG VERSION=4.0.5
ARG SHA256_HASH="ec22169bad150bebbf35f76c124e42c2f3ae5c8e7ec6d8a21039b688cdef6f90"

RUN set -eux; \
    apk update && apk upgrade; \
    apk add --no-cache \
        bash \
        su-exec \
        dovecot \
        tini \
        \
        php \
        php-curl \
        php-dom \
        php-fpm \
        php-iconv \
        php-imap \
        php-intl \
        php-mbstring \
        php-mysqli \
        php-pdo \
        php-pdo_mysql \
        php-pdo_pgsql \
        php-pgsql \
        php-phar \
        php-session \
        php-simplexml \
        php-sqlite3 \
        php-tokenizer \
        php-xml \
        php-xmlwriter \
    ; \
    \
    PFA_TARBALL="v${VERSION}.tar.gz"; \
    wget -q https://github.com/postfixadmin/postfixadmin/archive/${PFA_TARBALL}; \
    echo "${SHA256_HASH} *${PFA_TARBALL}" | sha256sum -c; \
    \
    mkdir /postfixadmin; \
    tar -xzf ${PFA_TARBALL} --strip-components=1 -C /postfixadmin; \
    rm -f ${PFA_TARBALL}; \
    /bin/bash /postfixadmin/install.sh; \
    ver="$(dovecot --version | awk '{print $1}')"; \
    printf "dovecot_config_version = %s\ndovecot_storage_version = %s\n" "$ver" "$ver" > /etc/dovecot/dovecot.conf

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
