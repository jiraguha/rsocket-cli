ARG RSOCKET_VESION=1.30.3

FROM buildpack-deps:20.04-curl AS download

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*
ARG RSOCKET_VESION
RUN curl -fsSL https://github.com/jiraguha/rsocket-cli/releases/download/v${RSOCKET_VESION}/rsocket-cli_linux_amd64.zip \
    --output rsocket-cli.zip \
  && unzip rsocket-cli.zip \
  && rm rsocket-cli.zip \
  && mkdir -p ./rsocket-cli-d/bin && mv rsocket-cli rsocket-cli-d/bin/rsocket-cli  \
  && chmod 755 rsocket-cli-d/bin/rsocket-cli

FROM ubuntu:22.04

ENV RSOCKET_VESION=${RSOCKET_VESION}
COPY --from=download /rsocket-cli-d /rsocket-cli
ENV RSOCKET_PATH /rsocket-cli
ENV PATH $RSOCKET_PATH/bin:$PATH
