FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt update &&\
    apt install git curl python3 python3-pip nodejs npm dnsmasq -y

RUN rm /usr/bin/python ; ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --upgrade pip virtualenv virtualenvwrapper

ENV APP_DIR /home/ubuntu

RUN mkdir $APP_DIR &&\ 
    useradd -d $APP_DIR ubuntu &&\
    chown -R ubuntu $APP_DIR
WORKDIR $APP_DIR
RUN rm /bin/sh &&\
    ln -s /bin/bash /bin/sh
USER ubuntu

RUN mkdir WMAS && cd WMAS && git init && git remote add origin https://github.com/cta-wave/WMAS.git
WORKDIR WMAS

USER root
RUN npm install --global https://github.com/cta-wave/wptreport.git#main
USER ubuntu

ARG commit
ARG runner-rev

RUN git fetch origin $commit
RUN git reset --hard FETCH_HEAD

ARG tests-rev
RUN ./wmas2021-subset.sh
RUN ./wpt manifest --no-download --rebuild
#RUN ./download-reference-results.sh
#RUN mv results reference-results

ENV TEST_RUNNER_IP 127.0.0.1

COPY run-dns.sh .

CMD cp -r ./reference-results/* results ;\
  ./run-dns.sh &&\
  ./wpt serve-wave --report
