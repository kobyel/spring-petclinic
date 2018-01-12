FROM alpine:3.6

MAINTAINER Koby Elmakias <koby.el@gmail.com>

COPY docker-entrypoint.sh /

RUN apk update && apk upgrade \
  && apk add ca-certificates curl \
  && apk add bash \
  && apk add openjdk8-jre \
  && mkdir /tmp/tmprt \
  && cd /tmp/tmprt \
  && apk add zip \
  && unzip -q /usr/lib/jvm/default-jvm/jre/lib/rt.jar \
  && zip -q -r /tmp/rt.zip . \
  && apk del zip \
  && cd /tmp \
  && mv rt.zip /usr/lib/jvm/default-jvm/jre/lib/rt.jar \
  && mkdir -p /opt/petclinic \
  && rm -rf /tmp/tmprt /var/cache/apk/* \
  && echo "alias ll='ls -la'" > /etc/profile.d/alias.sh \
  && chmod +x /etc/profile.d/alias.sh \
  && chmod +x /docker-entrypoint.sh

COPY target/spring-petclinic-1.5.1.jar /opt/petclinic/

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
