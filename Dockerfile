FROM centos:latest
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
ENV VARNISH_VERSION=4.1.6
ENV VARNISH_SHA256SUM=c7ac460b521bebf772868b2f5aefc2f2508a1e133809cd52d3ba1b312226e849
RUN \
  mkdir -p /usr/src && \
  cd /usr/src && \
  curl -sfLO https://repo.varnish-cache.org/source/varnish-$VARNISH_VERSION.tar.gz && \
  echo "${VARNISH_SHA256SUM} varnish-$VARNISH_VERSION.tar.gz" | sha256sum -c - && \
  tar -xzf varnish-$VARNISH_VERSION.tar.gz && \
  cd varnish-$VARNISH_VERSION && \
  ./autogen.sh && \
  ./configure && \
  make install && \
  rm ../varnish-$VARNISH_VERSION.tar.gz

EXPOSE 8080
ENTRYPOINT [ "/usr/local/sbin/varnishd", "-j", "unix,user=varnish", "-F", "-f", "/etc/varnish/default.vcl", "-a", "0.0.0.0:8080" ]

