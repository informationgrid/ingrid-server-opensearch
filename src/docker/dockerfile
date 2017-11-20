FROM openjdk:8-jre-alpine
ENV INGRID_USER=root
ENV RUN_DIRECTLY=true

ADD ingrid-server-*-installer.jar /

RUN unzip ingrid-server-*-installer.jar -d /tmp \
    && mkdir -p /opt/ingrid/ingrid-server-opensearch \
    && cp -R /tmp/ingrid-server-opensearch-*/* /opt/ingrid/ingrid-server-opensearch/ \
    && rm -Rf /tmp/* \
    && rm ingrid-*.jar

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /opt/ingrid/ingrid-server-opensearch/log.log
  # && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /opt/ingrid/ingrid-server-opensearch/logs
WORKDIR /opt/ingrid/ingrid-server-opensearch
EXPOSE 80

CMD /bin/sh start.sh start
