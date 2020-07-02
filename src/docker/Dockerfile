FROM alpine AS builder

COPY ingrid-server-*-installer.jar /
RUN unzip ingrid-server-*-installer.jar -d /tmp \
    && export INSTALL_DIR=`ls -d1 /tmp/ingrid-server-*` \
    && mkdir -p $INSTALL_DIR/logs \
    && echo jetty.port=8080 > $INSTALL_DIR/conf/config.override.properties

FROM docker-registry.wemove.com/ingrid-java:jre-8-alpine
ENV INGRID_USER=ingrid
ENV RUN_DIRECTLY=true

# user, group ingrid (1000:1000) is created in base image
COPY --chown=1000:1000 --from=builder /tmp/ingrid-server-* /opt/ingrid/ingrid-server-opensearch/

RUN ln -sf /dev/stdout /opt/ingrid/ingrid-server-opensearch/log.log

USER ingrid

WORKDIR /opt/ingrid/ingrid-server-opensearch
EXPOSE 8080

CMD /bin/sh start.sh start && tail -f /dev/null