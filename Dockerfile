FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

RUN useradd -m dockeruser && echo "dockeruser:dockeruser" | chpasswd && adduser dockeruser sudo

USER dockeruser

WORKDIR /home/dockeruser

COPY scripts/stackrun-entrypoint /home/dockeruser/entrypoint

ADD . /home/dockeruser/terraform-packager

ENV PATH="/home/dockeruser/terraform-packager/scripts:${PATH}"

ENTRYPOINT ["/home/dockeruser/entrypoint"]
