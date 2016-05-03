FROM opensuse/amd64:42.1
MAINTAINER Flavio Castelli <fcastelli@suse.com>

RUN zypper ar -f --no-gpgcheck obs://Virtualization:containers:Portus:Release:2.0.4rc1/openSUSE_Leap_42.1 portus && \
    zypper ar -f --no-gpgcheck obs://Virtualization:containers:Portus:Release:2.0.3/openSUSE_Leap_42.1 portus-old && \
zypper ref && \
    zypper -n in portus net-tools && \
    zypper clean -a

# apache configuration
RUN a2enmod ssl
RUN a2enmod passenger
RUN a2enflag SSL
ADD apache.conf /etc/apache2/vhosts.d/portus.conf
RUN ln -sf /dev/stdout /var/log/apache2/access_log
RUN ln -sf /dev/stderr /var/log/apache2/error_log

# secrets
RUN ln -sf /certificates/portus-ca.crt /etc/apache2/ssl.crt/portus-ca.crt
RUN ln -sf /secrets/portus.key /etc/apache2/ssl.key/portus.key

# portus configuration
ADD database.yml /srv/Portus/config/
ADD secrets.yml /srv/Portus/config/

ADD init /init
ADD check_db.rb /check_db.rb

EXPOSE 443

ENTRYPOINT ["/init"]
