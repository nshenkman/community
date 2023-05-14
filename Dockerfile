FROM golang:bullseye

ENV WEBP_VERSION libwebp-1.2.2-rc1

ENV REPO=$GOPATH/src/github.com/tidbyt/pixlet

RUN apt-get update \
 && apt-get install -y ca-certificates tzdata openssl libwebp-dev bash

RUN git clone https://github.com/tidbyt/pixlet.git $REPO && cd $REPO && make build

COPY /apps/whistle/whistle.star /whistle.star
COPY /apps/fi/fi.star /fi.star

COPY entrypoint.sh /entrypoint.sh
RUN chown -R 1000:1000 /whistle.star
RUN touch /whistle.webp
RUN chown -R 1000:1000 /whistle.webp

RUN chown -R 1000:1000 /fi.star
RUN touch /fi.webp
RUN chown -R 1000:1000 /fi.webp

USER 1000


ENTRYPOINT ["/entrypoint.sh"]