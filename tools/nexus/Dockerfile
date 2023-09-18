FROM alpine:latest

LABEL org.opencontainers.image.authors="Khadim MBACKE"

RUN apk add --no-cache curl jq

ARG NEXUS_DNS=$NEXUS_DNS
ARG NEXUS_PORT=$NEXUS_PORT
ARG REPO=$REPO
ARG FORMAT=$FORMAT
ARG KEYWORD=$KEYWORD
ARG EXTRA_SEARCH=$EXTRA_SEARCH
ARG DRY_RUN
ARG DELETE

COPY delete-component.sh /
COPY common.sh /
CMD /delete-component.sh