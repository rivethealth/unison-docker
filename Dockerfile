FROM alpine AS build

ARG UNISON_VERSION=2.51.2

RUN apk add build-base curl bash inotify-tools ocaml

RUN curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz | tar zxv -C /root

WORKDIR /root/unison-${UNISON_VERSION}

RUN sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c

RUN make UISTYLE=text NATIVE=true STATIC=true

RUN mv src/unison src/unison-fsmonitor /usr/local/bin/

FROM alpine

COPY --from=build /usr/local/bin/unison /usr/local/bin/unison-fsmonitor /usr/local/bin/

ENTRYPOINT ["unison"]
