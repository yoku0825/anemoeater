FROM centos:centos6.9
MAINTAINER yoku0825
WORKDIR /root

RUN yum upgrade -y && yum clean all
RUN yum install -y git && yum clean all
RUN test -d /opt/setup || mkdir /opt/setup
RUN git clone https://github.com/yoku0825/init_script.git /opt/setup/init_script.git
RUN bash /opt/setup/init_script.git/docker/docker_basic.sh

RUN yum install -y http://www.percona.com/downloads/percona-release/redhat/latest/percona-release-0.1-6.noarch.rpm && yum clean all
RUN yum install -y Percona-Server-client-56-5.6.42 Percona-Server-shared-56-5.6.42 Percona-Server-server-56-5.6.42 && yum clean all
RUN yum install -y httpd php php-mysql php-bcmath && yum clean all

RUN git clone https://github.com/box/Anemometer.git /var/www/html/anemometer
RUN chown -R mysql. /var/lib/mysql && \
    /etc/init.d/mysql start && \
    mysql -uroot < /var/www/html/anemometer/install.sql && \
    mysql -uroot < /var/www/html/anemometer/mysql56-install.sql && \
    (echo "GRANT ALL ON *.* TO anemometer" | mysql -uroot) && \
    /etc/init.d/mysql stop
RUN ln -sf /var/www/html/anemometer/conf/sample.config.inc.php /var/www/html/anemometer/conf/config.inc.php

COPY . /opt/setup
RUN patch /etc/php.ini /opt/setup/php.ini.patch
RUN patch /var/www/html/anemometer/lib/Anemometer.php /opt/setup/Anemometer.patch

EXPOSE 80
CMD chown -R mysql. /var/lib/mysql && \
    /etc/init.d/mysql start && \
    /etc/init.d/httpd start && \
    tail -f /dev/null

