FROM ubuntu:latest
WORKDIR /job

RUN apt update
RUN apt install -y curl wget git jq

COPY entrypoint.sh .
COPY gitconfig /root/.gitconfig

ENTRYPOINT ["/job/entrypoint.sh"]