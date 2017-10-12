FROM openjdk:8u121-alpine
MAINTAINER Jakub Kwiatkowski <jakub@ajbisoft.pl>

ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

ENV BAMBOO_HOME          /var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL_DIR   /opt/atlassian/bamboo

VOLUME ["${BAMBOO_HOME}"]

# Expose HTTP
EXPOSE 8085

WORKDIR $BAMBOO_HOME

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]

RUN apk update -qq \
    && update-ca-certificates \
    && apk add ca-certificates wget curl bash tini \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

#COPY entrypoint.sh              /entrypoint.sh

ARG BAMBOO_VERSION=6.2.1
ARG DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz
#COPY . /tmp

RUN mkdir -p                             ${BAMBOO_INSTALL_DIR} \
    && curl -L --silent                  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BAMBOO_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_INSTALL_DIR}/
