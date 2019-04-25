FROM debian:stable-slim AS base
LABEL maintainer="UmkaDK <umka.dk@icloud.com>"
RUN apt-get -y update \
    && apt-get -y install \
        bash \
        binutils \
        libcurl4-openssl-dev \
        libdw1 \
        libiberty-dev \
        python \
        zlib1g \
    && apt-get --purge autoremove \
    && apt-get clean
COPY ./docker-fs /
ENTRYPOINT ["/etc/entrypoints/login_shell"]

FROM base AS build
RUN apt-get -y update \
    && apt-get -y install \
        binutils-dev \
        cmake \
        gcc \
        g++ \
        git \
        libcurl4-openssl-dev \
        libdw-dev \
        libiberty-dev \
        zlib1g-dev \
    && apt-get --purge autoremove \
    && apt-get clean
WORKDIR /home
RUN git clone --depth 1 --branch v1.1.0 https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local
RUN git clone --depth 1 --branch v36 https://github.com/SimonKagstrom/kcov.git \
    && mkdir -p kcov/build \
    && cd kcov/build \
    && cmake .. \
    && make \
    && make install
ENTRYPOINT ["/etc/entrypoints/login_shell"]

FROM base AS latest
RUN adduser --disabled-password --no-create-home --home /home --shell /bin/bash --gecos "" payload \
    && chown -R payload:payload /home /mnt \
    && install --mode 0644 --owner=payload --group=payload /etc/skel/.??* /home
COPY --from=build /usr/local /usr/local
COPY --chown=payload . /home
RUN rm -Rf /home/docker-fs
USER payload
WORKDIR /mnt
ENTRYPOINT ["/etc/entrypoints/test_or_exec"]
