FROM debian:bookworm

# requirements for installing executable
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
    curl \
	tar \
	gcc \
	libc-dev \
	make \
	# ftpclient
	ftp

ENV VSFTPD_VERSION="3.0.5"
ENV VSFTPD_URL="https://security.appspot.com/downloads/vsftpd-$VSFTPD_VERSION.tar.gz"
ENV	SRC_DIR=/usr/src

RUN	mkdir -p $SRC_DIR \
 && cd $SRC_DIR \
 && curl -fsSL -o vsftpd.tar.gz $VSFTPD_URL \
 && tar -zxf vsftpd.tar.gz --strip-components=1 \
 && make \
 && cp vsftpd /usr/local/sbin/vsftpd \
 && cp vsftpd.conf.5 /usr/local/man/man5 \
 && cp vsftpd.8 /usr/local/man/man8 \
# vsftpd needs the (empty) directory /usr/share/empty in the default
 && mkdir -p /usr/share/empty \
# For anonymous FTP, need the user "ftp" to exist, and have valid home directory (which is NOT owned or writable by the user "ftp")
 && groupadd ftp \
 && useradd -g ftp ftp

COPY conf/vsftpd.conf /etc

COPY tools/docker-entrypoint.sh /usr/local/bin/

EXPOSE 20-21
EXPOSE 1024-1025

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "vsftpd" ]