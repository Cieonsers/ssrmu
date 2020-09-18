FROM alpine:3
MAINTAINER Guccen<6201170@gmail.com>

ENV NODE_ID=0                     \
    DNS_1=1.1.1.1                 \
    DNS_2=8.8.8.8                 \
    SPEEDTEST=0                   \
    CLOUDSAFE=1                   \
    AUTOEXEC=0                    \
    ANTISSATTACK=0                \
    MU_SUFFIX=microsoft.com       \
    MU_REGEX=%5m%id.%suffix       \
    API_INTERFACE=modwebapi       \
    WEBAPI_URL=https://zhaoj.in   \
    WEBAPI_TOKEN=glzjin           \
    MYSQL_HOST=127.0.0.1          \
    MYSQL_PORT=3306               \
    MYSQL_USER=ss                 \
    MYSQL_PASS=ss                 \
    MYSQL_DB=shadowsocks          \
    REDIRECT=github.com           \
    CONNECT_VERBOSE_INFO=0        \
    FAST_OPEN=false

COPY . /root/shadowsocks
WORKDIR /root/shadowsocks

RUN  apk --no-cache add \
                        curl \
                        gcc \
                        g++  \
                        libintl \
                        python3-dev \
                        libsodium-dev \
                        openssl-dev \
                        udns-dev \
                        mbedtls-dev \
                        pcre-dev \
                        libev-dev \
                        libtool \
                        libffi-dev 
RUN  apk --no-cache add --virtual .build-deps \
                        tar \
                        make \
                        gettext \
                        py3-pip \
                        autoconf \
                        automake \
                        build-base \
                        linux-headers
RUN  ln -sf /usr/bin/python3 /usr/bin/python
RUN  ln -sf /usr/bin/pip3    /usr/bin/pip
RUN  cp  /usr/bin/envsubst  /usr/local/bin/
RUN  pip install --user --upgrade pip 
RUN  pip install -r requirements-docker.txt
RUN  rm -rf ~/.cache && touch /etc/hosts.deny && \
     apk del --purge .build-deps

CMD envsubst < apiconfig.py > userapiconfig.py && \
    envsubst < config.json > user-config.json  && \
    echo -e "${DNS_1}\n${DNS_2}\n" > dns.conf  && \
    python server.py
