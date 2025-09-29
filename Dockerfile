FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    ssh \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install ansible

WORKDIR /ansible


CMD ["bash"]
