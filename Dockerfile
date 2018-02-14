FROM ubuntu:16.04
COPY ./join-domain.sh /scripts/join-domain.sh
WORKDIR /workdir
ENTRYPOINT [ "/scripts/join-domain.sh" ]