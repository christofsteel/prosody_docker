FROM debian:wheezy
MAINTAINER Christoph Stahl <christoph.stahl@uni-dortmund.de>

ENV DOMAIN example.com

RUN apt-get update && apt-get --no-install-recommends -y install apt-transport-https wget
RUN echo "deb http://packages.prosody.im/debian wheezy main" >> /etc/apt/sources.list
RUN apt-get update && apt-get --no-install-recommends -y install mercurial
RUN wget http://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y prosody-0.10 lua-dbi-sqlite3 lua-event
RUN apt-get install --no-install-recommends -y lua-sec-prosody
RUN apt-get install --no-install-recommends -y lua-bitop
RUN apt-get install --no-install-recommends -y git

RUN apt-get install --no-install-recommends -y ca-certificates

RUN apt-get install --no-install-recommends -y nano
RUN apt-get install --no-install-recommends -y vim

WORKDIR /usr/share
RUN hg clone https://code.google.com/p/prosody-modules/
WORKDIR /usr/lib/prosody

EXPOSE 5222
EXPOSE 5269
EXPOSE 5347
EXPOSE 5280
EXPOSE 5281

ADD init.sh /bin/
ADD startd /bin/
RUN chmod a+x /bin/init.sh
RUN chmod a+x /bin/startd

ENTRYPOINT ["/bin/init.sh"]

RUN rm -rf /var/log/prosody
RUN ln -s /var/lib/prosody/log /var/log/prosody
RUN rm -rf /etc/prosody/certs
RUN ln -s /var/lib/prosody/certs /etc/prosody

WORKDIR /tmp

RUN git clone https://github.com/christofsteel/prosody_docker

RUN mkdir /etc/start.d/
RUN cp /tmp/prosody_docker/prosody /etc/start.d/
RUN chmod a+x /etc/start.d/prosody
RUN cp /tmp/prosody_docker/create_folders /usr/bin/
RUN chmod a+x /usr/bin/create_folders
RUN cp /tmp/prosody_docker/copy_modules /usr/bin/
RUN chmod a+x /usr/bin/copy_modules
RUN cp /tmp/prosody_docker/create_config_prosody /usr/bin/
RUN chmod a+x /usr/bin/create_config_prosody
