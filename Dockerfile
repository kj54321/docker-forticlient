FROM alpine:latest

RUN apk add --no-cache iproute2 ppp ppp-daemon bash \
    && apk add --update openssl

WORKDIR /opt

# Install fortivpn client unofficial .deb
RUN wget 'https://tianyublog.com/res/forticlient.tar.gz' -O forticlient-sslvpn.tgz \
    && tar -xzf forticlient-sslvpn.tgz \
    && rm -rf forticlient-sslvpn.tgz


# Run setup
RUN forticlient/helper/setup.linux.sh 2 \
    && echo -n 'debug dump\n\
lock\n\
noauth\n\
proxyarp\n\
nodefaultroute\n\
modem\n\
noipdefault\n\
lcp-echo-interval 60\n\
lcp-echo-failure 4\n\
' > /etc/ppp/options

# Copy runfiles
COPY forticlient /usr/bin/forticlient
COPY start.sh /start.sh

CMD [ "/start.sh" ]
