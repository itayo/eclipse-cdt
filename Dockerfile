FROM ubuntu:16.04
MAINTAINER Ivan Kostov "ikostov@gmail.com"

RUN apt-get update && apt-get upgrade -y && apt-get install -y software-properties-common default-jre libxext-dev libxrender-dev libxtst-dev wget libgtk2.0-0 libcanberra-gtk-module g++ libboost-all-dev build-essential gdb && \
    apt-get -y autoremove 

RUN wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/neon/3/eclipse-cpp-neon-3-linux-gtk-x86_64.tar.gz  -O /tmp/eclipse.tar.gz -q && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

ADD run /usr/local/bin/eclipse

RUN chmod +x /usr/local/bin/eclipse && \
    useradd -ms /bin/bash  developer
ADD cmake-3.12.4.tar.gz /tmp
ADD openssl-1.0.0t.tar.gz /tmp 

WORKDIR /tmp/
RUN echo "/usr/local/openssl/lib" >  /etc/ld.so.conf.d/openssl.conf
RUN cd openssl-1.0.0t && ./config && make && make install  && ldconfig && cd .. && cd cmake-3.12.4 && ./bootstrap && make && make install && cd .. && rm -rf cmake-3.12.4 && rm -rf openssl-1.0.0t
WORKDIR /home/developer
USER developer
ENV HOME /home/developer
CMD /usr/local/bin/eclipse
