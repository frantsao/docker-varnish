# Varnish

## Supported tags and respective `Dockerfile` links

-	[`4.1.8`, `latest` (*4.1.8/Dockerfile*)](https://github.com/frantsao/docker-varnish/blob/4.1.8/Dockerfile)

## What is Varnish?

[Varnish Cache](https://www.varnish-cache.org/) is a web application accelerator also known as a caching HTTP reverse proxy. You install it in front of any server that speaks HTTP and configure it to cache the contents. Varnish Cache is really, really fast. It typically speeds up delivery with a factor of 300 - 1000x, depending on your architecture.

> [wikipedia.org/wiki/Varnish_(software)](https://en.wikipedia.org/wiki/Varnish_(software))

## How to use this image

This image is intended as a base image for other images to built on.

### Create a `Dockerfile` in your Varnish project

```dockerfile
FROM frantsao/varnish:4.1.8
```

### Create a `default.vcl` in your Varnish project and copy to the directory config (i.e. /var/lib/docker/etc-varnish)

```vcl
vcl 4.0;

backend default {
    .host = "www.nytimes.com";
    .port = "80";
}
```

Then, run the commands to build and run the Docker image:

```console
$ docker build -t my-varnish .
$ docker run -it --rm -d -p 80:8080 -v /var/lib/docker/etc-varnish:/etc/varnish -v /var/lib/docker/log-varnish:/var/log/varnish --name my-running-varnish my-varnish -s malloc,1024m 
```

So you can activate and store the logs if you want (i.e in order to debug):

```console
docker exec -it my-running-varnish varnishncsa -c -a -w /var/log/varnish/varnish.log
```

### Customize configuration

You can override the port Varnish serves in your Dockerfile.

```dockerfile
FROM frantsao/varnish:4.1.8

ENV VARNISH_PORT 80
EXPOSE 80
```

For valid varnish daemon opts to add at docker run, see the [varnish options documentation](https://www.varnish-cache.org/docs/4.1/reference/varnishd.html#options).


## How to install VMODs (Varnish Modules)

[Varnish Modules](https://www.varnish-cache.org/vmods) are extensions written for Varnish Cache.

To install Varnish Modules, you will need the Varnish source to compile against. This is why we install Varnish from source in this image rather than using a package manager.

Install VMODs in your Varnish project's Dockerfile. For example, to install the Querystring module:

```dockerfile
FROM frantsao/varnish:4.1.8

# Install Querystring Varnish module
ENV QUERYSTRING_VERSION=0.3
RUN \
  cd /usr/local/src/ && \
  curl -sfL https://github.com/Dridi/libvmod-querystring/archive/v$QUERYSTRING_VERSION.tar.gz -o libvmod-querystring-$QUERYSTRING_VERSION.tar.gz && \
  tar -xzf libvmod-querystring-$QUERYSTRING_VERSION.tar.gz && \
  cd libvmod-querystring-$QUERYSTRING_VERSION && \
  ./autogen.sh && \
  ./configure VARNISHSRC=/usr/local/src/varnish-$VARNISH_VERSION && \
  make install && \
  rm -r ../libvmod-querystring-$QUERYSTRING_VERSION*
```

# License

View [license information](https://www.apache.org/licenses/LICENSE-2.0) for the software contained in this image.

# Supported Docker versions

This image is supported on Docker version 1.12.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

## Issues

If you have any problems with or questions about this image, please contact me through a [GitHub issue](https://github.com/frantsao/docker-varnish/issues).

