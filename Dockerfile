FROM python:3.10-alpine

EXPOSE 5900

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
COPY ./scripts /scripts

# Установка временных зависимостей
RUN apk update && apk upgrade && \
    apk add --no-cache --virtual .build-deps \
    alpine-sdk \
    curl \
    wget \
    unzip \
    gnupg 

# Установка постоянных зависимостей
RUN apk add --no-cache \
    xvfb \
    x11vnc \
    fluxbox \
    xterm \
    libffi-dev \
    openssl-dev \
    zlib-dev \
    bzip2-dev \
    readline-dev \
    sqlite-dev \
    git \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    chromium \
    chromium-chromedriver

# Установка x11vnc
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

# Установка зависимостей Python
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

WORKDIR /app

RUN chmod -R +x /scripts

ENV PATH="/scripts:$PATH"
ENV DISPLAY=:0

# Удаление временных зависимостей
RUN apk del .build-deps

CMD startup.sh
