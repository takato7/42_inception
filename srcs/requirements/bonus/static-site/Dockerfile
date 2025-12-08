FROM alpine:3.21

RUN apk add --update-cache \
	python3 \
	py3-pip \
	curl \
 	&& rm -rf /var/cache/apk/*

ENV	SRC_DIR="/var/app"

WORKDIR	$SRC_DIR

COPY tools/requirements.txt .

RUN python3 -m venv .venv \
 && . .venv/bin/activate \
 && python3 -m pip install -r requirements.txt

ENV	VIRTUAL_ENV="$SRC_DIR/.venv/bin"
ENV	PATH="$VIRTUAL_ENV:$PATH"

RUN adduser -u 82 -D -S -G www-data www-data \
 && chown -R www-data:www-data $SRC_DIR

COPY --chown=www-data:www-data tools .

USER www-data

EXPOSE 8000

CMD [ "gunicorn", \
	  "app:app", \
	  "--workers", "4", \
	  "--bind", "0.0.0.0" ]
