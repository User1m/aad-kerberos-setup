FROM ubuntu:16.04
COPY ./ /scripts
WORKDIR /scripts
ENTRYPOINT [ "/scripts/join-domain.sh", "my-domain.onmicrosoft.com","admin", "admin-password", "vm-host-name" ]