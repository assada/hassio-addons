ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN set -ex \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential \
        curl \
        gcc \
	gstreamer1.0-alsa \
	gstreamer1.0-fluendo-mp3 \
	gstreamer1.0-libav \
	libxml2-dev \
	libxslt-dev \
	libz-dev \
	jq \
	python-crypto \
	python-dev \
 && curl -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
 && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
 && apt-key add /tmp/mopidy.gpg \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy mopidy-local-sqlite \
 && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
 && pip install -U six oauth2client pyasn1 \
 && pip install \
	Mopidy-Moped \
    Mopidy-GMusic \
	https://github.com/assada/mopidy-somafm/zipball/develop \
	Mopidy-Scrobbler \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
	build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache \
 && mkdir -p -m 777 /devices

COPY mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 6600 6680
CMD [ "/run.sh" ]
