FROM alpine:3.10 as base
MAINTAINER jmimick@gmail.com

RUN apk add --update \
    bash \
    openjdk8-jre \
  && rm -rf /var/cache/apk/*
RUN apk add --update \
    python \
    py-pip 


FROM base as app

ENV YCSB_VERSION=0.17.0 \
    PATH=${PATH}:/usr/bin

#RUN apk --update --no-cache add python3.7 mksh 
#RUN pip3 install --upgrade pip

COPY ycsb-mongodb-binding-${YCSB_VERSION}.tar.gz /
RUN tar -xvf ycsb-mongodb-binding-${YCSB_VERSION}.tar.gz

COPY requirements.txt /requirements.txt
COPY test.secrets.env /test.secrets.env
COPY connstring-helper*.py /
RUN pip install -r /requirements.txt
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV ACTION='' DBTYPE='' WORKLETTER='' DBARGS='' RECNUM='' OPNUM=''

FROM app as runtime

WORKDIR "/opt/ycsb-${YCSB_VERSION}"

ENTRYPOINT ["/start.sh"]
