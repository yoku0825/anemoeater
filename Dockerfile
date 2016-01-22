FROM centos:centos6.6
MAINTAINER yoku0825
WORKDIR /root

RUN yum install -y git
RUN test -d /tmp/setup || mkdir /tmp/setup
RUN git clone https://github.com/yoku0825/init_script.git /tmp/setup/init_script.git
RUN bash /tmp/setup/init_script.git/docker/docker_basic.sh

RUN yum install -y http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
RUN yum install -y Percona-Server-client-56 Percona-Server-shared-56 Percona-Server-server-56 percona-toolkit
RUN yum install -y httpd php php-mysql php-bcmath

RUN git clone https://github.com/box/Anemometer.git /var/www/html/anemometer
RUN /etc/init.d/mysql start && mysql -uroot < /var/www/html/anemometer/install.sql && mysql -uroot < /var/www/html/anemometer/mysql56-install.sql && (echo "GRANT ALL ON *.* TO anemometer" | mysql -uroot)
RUN ln -sf /var/www/html/anemometer/conf/sample.config.inc.php /var/www/html/anemometer/conf/config.inc.php

COPY . /tmp/setup
RUN patch /etc/php.ini /tmp/setup/php.ini.patch

EXPOSE 80
CMD /etc/init.d/mysql start && /etc/init.d/httpd start && tail -f /dev/null

