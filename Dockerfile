FROM hypriot/rpi-python
MAINTAINER mastermindg@gmail.com

ENV DATA_DIR=/data \
    BIND_USER=bind \
    WEBMIN_VERSION=1.881

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget bind9 perl libnet-ssleay-perl openssl \
      libauthen-pam-perl libpam-runtime libio-pty-perl dnsutils \
      apt-show-versions python 

RUN wget -O webmin https://svwh.dl.sourceforge.net/project/webadmin/webmin/1.881/webmin_1.881_all.deb

COPY webmin_${WEBMIN_VERSION}_all.deb /tmp/

RUN dpkg -i /tmp/webmin_${WEBMIN_VERSION}_all.deb \
 && rm -rf /tmp/webmin_${WEBMIN_VERSION}_all.deb \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 10000/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
