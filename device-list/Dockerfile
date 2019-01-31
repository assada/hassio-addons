ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk update \
 && apk add jq \
 && rm -rf /var/cache/apk/*

RUN mkdir -p -m 777 /devices

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
