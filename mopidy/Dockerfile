ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

#Install mopidy
RUN apk update && apk add --no-cache --virtual .build-deps \
 	build-base \
	git \
 && apk add --no-cache \
        ca-certificates \
        gst-plugins-bad \
        gst-plugins-good \
        gst-plugins-ugly \
        libxml2-dev \
        libxslt-dev \
        zlib-dev \
	    jq \
        py-gst \
        py-pip \
        python \
	    python-dev \
	    libressl-dev \
        make \
        ntfs-3g \
        fuse \
        libffi \
        libffi-dev \
        ffmpeg \
        py-cffi \
        bash \
 && pip install -U pip \
 && pip install \
        cffi \
        mopidy \
        pycrypto \
 		oauth2client \
    	pyasn1 \
        Mopidy-Moped \
        Mopidy-GMusic \
        Mopidy-Scrobbler \
        Mopidy-SomaFM \
	    Mopidy-Local-SQLite \
 && git clone https://github.com/assada/tg-music-downloader.git \
 && pip install -r /tg-music-downloader/requirements.txt \
 && mkdir -p -m 777 /devices \
 && apk update && apk upgrade \
 && apk del .build-deps

COPY mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

COPY run.sh /
COPY run-bot.sh /
RUN chmod a+x /run.sh \
&& chmod a+x /run-bot.sh

EXPOSE 6600 6680
CMD [ "/run.sh" ]
