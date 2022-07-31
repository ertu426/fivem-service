FROM alpine:latest as build
ENV FIVEM_NUM=5774
ENV FIVEM_VER=5774-7dd991582b990411930c2a452265c9b2144ae576
RUN apk add --no-cache tini
RUN apk add --no-cache libgcc
RUN apk add --no-cache libstdc++
RUN apk add --no-cache libcurl
RUN apk add --no-cache git
RUN apk add --no-cache openssh
WORKDIR /output
RUN wget -O- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_VER}/fx.tar.xz \
    | tar xJ --strip-components=1 \
    --exclude alpine/dev --exclude alpine/proc \
    --exclude alpine/run --exclude alpine/sys
WORKDIR /
RUN cp -R /output/opt/cfx-server /opt/cfx-server
RUN cp -R /output/usr/* /usr/
RUN mkdir /txData
COPY server.cfg /opt/cfx-server-data/server.cfg
COPY logo.png /opt/cfx-server-data/logo.png
EXPOSE 30125
EXPOSE 30125/udp
EXPOSE 40120
VOLUME /txData
ENTRYPOINT ["tini", "--"]
CMD ["opt/cfx-server/FXServer"]
