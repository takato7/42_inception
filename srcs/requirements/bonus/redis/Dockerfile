FROM debian:bookworm AS build

# https://github.com/redis/redis?tab=readme-ov-file#what-is-redis

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	wget \
	dpkg-dev \
	gcc \
	g++ \
	libc6-dev \
	libssl-dev \
	make \
	git \
	cmake \
	python3 \
	python3-pip \
	python3-venv \
	python3-dev \
	unzip \
	rsync \
	clang \
	automake \
	autoconf \
	libtool \
 && rm -rf /var/lib/apt/list/*

ENV REDIS_VERSION="8.2.3"
ENV REDIS_URL="https://github.com/redis/redis/archive/refs/tags/$REDIS_VERSION.tar.gz"
ENV	SRC_DIR=/usr/src

RUN mkdir -p $SRC_DIR \
 && cd $SRC_DIR \
 && wget -O redis.tar.gz $REDIS_URL \
 && tar -xzf redis.tar.gz --strip-components=1 \
 && rm -rf redis.tar.gz \
 && make -j $(nproc) all && make install \
 && redis-cli --version \
 && redis-server --version

FROM debian:bookworm AS final

COPY --from=build /usr/local/bin /usr/local/bin

EXPOSE 6379

CMD [ "redis-server" ]
