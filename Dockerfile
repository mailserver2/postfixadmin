FROM alpine:3.12

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes" \
    maintainer="Hardware <contact@meshup.net>"

ARG VERSION=3.3.1
ARG SHA256_HASH="5dff072ce6e00558281809c1abeb4000a9d32bd5b4751fd55cb966b003cbcaf3"

RUN set -eux; \
    apk add --no-cache \
        su-exec \
        dovecot \
        tini \
        \
        php7 \
        php7-fpm \
        php7-imap \
        php7-mbstring \
        php7-mysqli \
        php7-pgsql \
        php7-phar \
        php7-session \
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
