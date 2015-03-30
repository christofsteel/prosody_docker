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

RUN git clone https://github.com/christofsteel/prosody_docker

RUN mkdir /etc/start.d/
RUN cp prosody /etc/start.d/
RUN chmod a+x /etc/start.d/prosody
RUN cp copy_certs /usr/bin/
RUN chmod a+x /usr/bin/copy_certs
RUN cp copy_modules /usr/bin/
RUN chmod a+x /usr/bin/copy_modules
RUN cp create_config_prosody /usr/bin/
RUN chmod a+x /usr/bin/create_config_prosody

WORKDIR /usr/share
RUN hg clone https://code.google.com/p/prosody-modules/
WORKDIR /usr/lib/prosody

EXPOSE 5222
EXPOSE 5269

ADD init.sh /bin/
ADD startd /bin/
RUN chmod a+x /bin/init.sh
RUN chmod a+x /bin/startd

ENTRYPOINT ["/bin/init.sh"]

RUN apt-get --no-install-recommends -y install nano
RUN apt-get --no-install-recommends -y install vim