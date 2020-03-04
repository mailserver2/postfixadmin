FROM alpine:3.11.3

LABEL description "PostfixAdmin is a web based interface used to manage mailboxes" \
      maintainer="Hardware <contact@meshup.net>"

ARG VERSION=3.2.3
ARG SHA256_HASH="dae88f8166804997386bdf2454a62afc9bc768f0e4b53f46003d2766cebf31c0"

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    ca-certificates \
    gnupg \
 && apk add \
    su-exec \
    dovecot \
    tini@community \
    php7@community \
    php7-phar \
    php7-fpm@community \
    php7-imap@community \
    php7-pgsql@community \
    php7-mysqli@community \
    php7-session@community \
    php7-mbstring@community \
 && cd /tmp \
 && PFA_TARBALL="postfixadmin-${VERSION}.tar.gz" \
 && wget -q https://github.com/postfixadmin/postfixadmin/archive/${PFA_TARBALL} \
 && CHECKSUM=$(sha256sum ${PFA_TARBALL} | awk '{print $1}') \
 && if [ "${CHECKSUM}" != "${SHA256_HASH}" ]; then echo "ERROR: Checksum does not match!" && exit 1; fi \
 && mkdir /postfixadmin && tar xzf ${PFA_TARBALL} -C /postfixadmin && mv /postfixadmin/postfixadmin-postfixadmin-$VERSION/* /postfixadmin \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg /postfixadmin/postfixadmin-$VERSION*

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
