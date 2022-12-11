FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    sudo \
    vim

RUN adduser --disabled-password --gecos '' rtfb
RUN adduser rtfb sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /dotfiles
RUN chown -R rtfb:rtfb /dotfiles

USER rtfb

WORKDIR /dotfiles

ENTRYPOINT ["/dotfiles/run-tests.sh"]
