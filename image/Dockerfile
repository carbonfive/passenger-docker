FROM phusion/baseimage:0.9.9
MAINTAINER Carbon Five <info@carbonfive.com>

ENV HOME /root
RUN mkdir /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]

RUN /usr/sbin/enable_insecure_key