FROM centos:7
MAINTAINER Fran Tsao <tsao@gpul.org>

# Forked from https://github.com/newsdev/docker-varnish

RUN \
  groupadd -g 972 varnish
RUN \
  useradd -u 972 -s /bin/false -g varnish varnish
# Install Varnish source build dependencies.
RUN \
  yum install -y \
    automake \
    make \ 
    gcc \ 
    glibc-devel \
    ca-certificates \
    curl \
    libedit-devel \
    jemalloc-devel \
    jemalloc \
    ncurses-devel \
    pcre-devel \
    pcre \
    libtool \
    pkgconfig \
    file \
    dotconf \
    python-docutils \
  && yum clean all

# Install Varnish from source, so that Varnish modules can be compiled and installed.
ENV VARNISH_VERSION=4.1.11
ENV VARNISH_SHA256SUM=f937a45116f3a7fbb38b2b5d7137658a4846409630bb9eccdbbb240e1a1379bc
RUN \
  mkdir -p /usr/src && \
  cd /usr/src && \
  curl -sfLO https://varnish-cache.org/_downloads/varnish-$VARNISH_VERSION.tgz && \
  echo "${VARNISH_SHA256SUM} varnish-$VARNISH_VERSION.tgz" | sha256sum -c - && \
  tar -xzf varnish-$VARNISH_VERSION.tgz && \
  cd varnish-$VARNISH_VERSION && \
  ./autogen.sh && \
  ./configure && \
  make install && \
  rm ../varnish-$VARNISH_VERSION.tgz

EXPOSE 8080
ENTRYPOINT [ "/usr/local/sbin/varnishd", "-j", "unix,user=varnish", "-F", "-f", "/etc/varnish/default.vcl", "-a", "0.0.0.0:8080" ]

