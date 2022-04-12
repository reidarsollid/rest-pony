FROM ponylang/shared-docker-ci-x86-64-unknown-linux-builder-with-libressl-3.4.1:release AS build

WORKDIR /src/rest-pony

COPY corral.json lock.json /src/rest-pony/
COPY main.pony /src/rest-pony/

WORKDIR /src/rest-pony/

RUN corral fetch
RUN corral run -- ponyc -Dopenssl_0.9.0 --static

FROM debian:bookworm-slim

RUN apt-get update && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/rest-pony/rest-pony /usr/local/bin/rest-pony

CMD ["rest-pony"]
EXPOSE 8080
