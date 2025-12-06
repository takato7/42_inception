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
#  issues on installing rust "95.94 tar: rust-1.88.0-x86_64-unknown-linux-gnu/rust-docs/share/doc/rust/html/core/arch/x86/fn._mm256_mask_min_epi16.html: Cannot open: No space left on device"
#  && export BUILD_TLS=yes BUILD_WITH_MODULES=yes INSTALL_RUST_TOOLCHAIN=yes DISABLE_WERRORS=yes \
 && make -j $(nproc) all && make install \
 && redis-cli --version \
 && redis-server --version

FROM debian:bookworm AS final

COPY --from=build /usr/src /usr/src
COPY --from=build /usr/local/bin /usr/local/bin
COPY conf/redis.conf /etc

COPY tools/healthcheck.sh /usr/local/bin

EXPOSE 6379

CMD [ "redis-server", "/etc/redis.conf" ]
