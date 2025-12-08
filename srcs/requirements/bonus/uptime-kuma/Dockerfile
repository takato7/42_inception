FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl \
	ca-certificates \
	git \
 && rm -rf /var/lib/apt/lists/*

# https://github.com/louislam/uptime-kuma
# install Node.js to run the uptime-kuma server.js script 
# following the instruction to install Node.js via nvm (node version manager) in https://nodejs.org/en/download instead of the one written in https://uptimekuma.org/install-uptime-kuma-linux/
# caution when using nvm in Docker (https://github.com/nvm-sh/nvm#installing-in-docker)
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV=/.bash_env
RUN touch "${BASH_ENV}" \
 && echo '. "${BASH_ENV}"' >> ~/.bashrc

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE="${BASH_ENV}" bash \
 && export NVM_DIR="$HOME/.nvm" \
 && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
 && echo node > .nvmrc \
 && nvm install 24 \
 && node -v \
 && npm -v

# clone the Uptime Kuma GitHub repository
ENV SRC_DIR=/usr/src

# run the setup script along with the PM2 process manager which will keep Uptime Kuma running
# https://pm2.keymetrics.io/
RUN mkdir -p $SRC_DIR \
 && cd $SRC_DIR \
 && git clone https://github.com/louislam/uptime-kuma.git . \
 && npm run setup \
 && npm install pm2 -g \
 && pm2 install pm2-logrotate \
 && pm2 startup

COPY tools/docker-entrypoint.sh /usr/local/bin/

EXPOSE 3001

ENTRYPOINT [ "docker-entrypoint.sh" ]

# https://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/
CMD [ "pm2-runtime", "start", "server/server.js" ]
