FROM raushanraja/jammybase:latest

RUN apt update && apt install -y debhelper-compat  default-libmysqlclient-dev  dh-sequence-dkms  gperf  libavcodec-dev  \ 
libavfilter-dev  libavformat-dev  libavutil-dev libbcg729-dev  libbencode-perl  libcrypt-openssl-rsa-perl \ 
libcrypt-rijndael-perl  libcurl4-openssl-dev  libdigest-crc-perl  libdigest-hmac-perl  libevent-dev  \ 
libhiredis-dev  libio-multiplex-perl  libio-socket-inet6-perl  libiptc-dev  libjson-glib-dev \
libjson-perl  libmosquitto-dev  libnet-interface-perl  libopus-dev  libpcap-dev  libsocket6-perl  \ 
libspandsp-dev  libspeex-dev libspeexdsp-dev  libswresample-dev  libsystemd-dev  libtest2-suite-perl \
libxmlrpc-core-c3-dev  libxtables-dev libip6tc-dev libip4tc-dev  libiptc-dev markdown  python3-websockets netcat \
nfs-common iptables libconfig-tiny-perl libwebsockets-dev pandoc


RUN git clone https://github.com/sipwise/rtpengine.git
RUN cd rtpengine/ dpkg-checkbuilddeps && dpkg-buildpackage


ARG RUNLEVEL
ENV RUNLEVEL=${RUNLEVEL}

RUN dpkg -i \
  ngcp-rtpengine-iptables*.deb ngcp-rtpengine-utils*.deb \
  ngcp-rtpengine-kernel-dkms*.deb \ 
  ngcp-rtpengine-daemon*.deb \ 
  ngcp-rtpengine-recording-daemon*.deb

RUN rm -rf /usr/rtpengine

COPY rtpengine.conf /etc/rtpengine/rtpengine.conf
COPY ./bkp_configs/ /etc/rtpengine/bkp_configs/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
