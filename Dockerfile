FROM alpine:latest

# Install dependency
RUN apk add --no-cache ca-certificates wget iproute2 ppp ppp-daemon bash expect file libgcc libstdc++ \
    &&  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    &&  wget 'https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-2.26-r0.apk' \
    &&  apk add glibc-2.26-r0.apk \
    &&  rm -rf glibc-2.26-r0.apk
    

WORKDIR /opt

# Install fortivpn client unofficial .deb
RUN wget 'https://tianyublog.com/res/forticlient.tar.gz' -O forticlient-sslvpn.tgz \
    && tar -xzf forticlient-sslvpn.tgz \
    && rm -rf forticlient-sslvpn.tgz \
    && bash forticlient/helper/setup.linux.sh 2 \
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
