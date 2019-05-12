FROM debian:stable-slim AS base
LABEL maintainer="UmkaDK <umka.dk@icloud.com>"
COPY ./docker-fs /
RUN apt-get -y update \
    && apt-get -y install \
        bash \
        bc \
        binutils \
        jq \
        libcurl4-openssl-dev \
        libdw1 \
        libiberty-dev \
        python \
        zlib1g \
    && apt-get --purge autoremove \
    && apt-get clean \
    && cp /etc/skel/.??* /root \
    && adduser \
        --quiet \
        --disabled-password \
        --disabled-login \
        --no-create-home \
        --home /home \
        --shell /bin/bash \
        --gecos "" \
        payload \
    && cp /etc/skel/.??* /home \
    && chown -R payload:payload /home /mnt
ENTRYPOINT ["/etc/entrypoint.d/login_shell"]

FROM base AS build
RUN apt-get -y update \
    && apt-get -y install \
        binutils-dev \
        cabal-install \
        cmake \
        curl \
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
RUN git clone --depth 1 --branch v0.6.0 https://github.com/koalaman/shellcheck.git \
    && cd shellcheck \
    && cabal update \
    && cabal install --global
RUN git clone --depth 1 --branch v1.1.0 https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local
RUN git clone --depth 1 --branch v36 https://github.com/SimonKagstrom/kcov.git \
    && mkdir -p kcov/build \
    && cd kcov/build \
    && cmake .. \
    && make \
    && make install
ENTRYPOINT ["/etc/entrypoint.d/login_shell"]

FROM build AS final
WORKDIR /home
COPY --from=build --chown=root /usr/local /usr/local
COPY --chown=payload . .
USER payload
RUN ./bin/test \
    && TZ=UTC git show \
        --pretty=tformat:"%H%+D%+ad%n%+s" \
        --date=format-local:"%c %Z" \
        | head -5 > ./VERSION \
    && rm -Rf \
        ./.git \
        ./docker-fs
WORKDIR /mnt
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/entrypoint.d/test_getopts_long"]
