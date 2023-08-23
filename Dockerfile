FROM ubuntu:18.04

# install packages
RUN apt update &&\
    apt install git curl python3 nodejs npm virtualenv dnsmasq -y

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

ARG runner-rev
ARG commit

RUN git fetch origin $commit
RUN git reset --hard FETCH_HEAD

ARG tests-rev
RUN ./wmas2018-subset.sh
RUN ./download-reference-results.sh
RUN mv results reference-results

ENV TEST_RUNNER_IP 127.0.0.1

CMD cp -r ./reference-results/* results ;\
  dnsmasq \
  --no-hosts \
  --server=1.1.1.1 \
  --server=1.0.0.1 \
  --address=/xn--lve-6lad.not.web-platform.test/$TEST_RUNNER_IP \
  --address=/xn--lve-6lad.web-platform.test/$TEST_RUNNER_IP \
  --address=/xn--n8j6ds53lwwkrqhv28a.not.web-platform.test/$TEST_RUNNER_IP \
  --address=/www1.web-platform.test/$TEST_RUNNER_IP \
  --address=/www2.web-platform.test/$TEST_RUNNER_IP \
  --address=/not.web-platform.test/$TEST_RUNNER_IP \
  --address=/web-platform.test/$TEST_RUNNER_IP \
  --address=/www2.not.web-platform.test/$TEST_RUNNER_IP \
  --address=/www1.not.web-platform.test/$TEST_RUNNER_IP \
  --address=/www.not.web-platform.test/$TEST_RUNNER_IP \
  --address=/www.web-platform.test/$TEST_RUNNER_IP \
  --address=/xn--n8j6ds53lwwkrqhv28a.web-platform.test/$TEST_RUNNER_IP \
  && ./wpt serve-wave --report
