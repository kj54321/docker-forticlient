FROM alpine:latest

# Install dependency
RUN echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk add --no-cache ca-certificates wget iproute2 ppp ppp-daemon bash expect file libgcc libstdc++ gcompat@testing 
    

WORKDIR /opt

# Install fortivpn client unofficial .deb
RUN wget 'https://tianyublog.com/res/forticlient.tar.gz' -O forticlient-sslvpn.tgz \
    && tar -xzf forticlient-sslvpn.tgz \
    && rm -rf forticlient-sslvpn.tgz \
    && bash forticlient/helper/setup.linux.sh 2 \
    && echo 'debug dump\n\
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
