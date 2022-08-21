FROM golang:bullseye

ENV WEBP_VERSION libwebp-1.2.2-rc1

ENV REPO=$GOPATH/src/github.com/tidbyt/pixlet

RUN apt-get update \
 && apt-get install -y ca-certificates tzdata openssl libwebp-dev bash virtualenv

RUN git clone https://github.com/tidbyt/pixlet.git $REPO && cd $REPO && make build

RUN virtualenv -p /usr/bin/python3 /yacron && \
        /yacron/bin/pip install yacron

COPY /yacrontab.yaml /etc/yacron.d/yacrontab.yaml
COPY /apps/whistle/whistle.star /whistle.star
RUN chown -R 1000:1000 /whistle.star
RUN touch /whistle.webp
RUN chown -R 1000:1000 /whistle.webp

USER 1000


ENTRYPOINT ["/yacron/bin/yacron"]