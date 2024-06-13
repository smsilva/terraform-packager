FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

RUN useradd -m dockeruser && echo "dockeruser:dockeruser" | chpasswd && adduser dockeruser sudo

USER dockeruser

WORKDIR /home/dockeruser

COPY entrypoint /home/dockeruser/entrypoint

ENTRYPOINT ["/home/dockeruser/entrypoint"]
