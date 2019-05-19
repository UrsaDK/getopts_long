FROM debian:stable-slim AS base
LABEL maintainer="UmkaDK <umka.dk@icloud.com>"
COPY ./docker-fs /
RUN apt-get -y update \
    && apt-get -y install \
        bash \
        bc \
        binutils \
        curl \
        git \
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
        cmake \
        gcc \
        g++ \
        libcurl4-openssl-dev \
        libdw-dev \
        libiberty-dev \
        xz-utils \
        zlib1g-dev \
    && apt-get --purge autoremove \
    && apt-get clean
WORKDIR /home
RUN SHELLCHECK_VERSION='v0.6.0' \
    && SHELLCHECK_DIR="shellcheck-${SHELLCHECK_VERSION}" \
    && SHELLCHECK_URL="https://storage.googleapis.com/shellcheck/${SHELLCHECK_DIR}.linux.x86_64.tar.xz" \
    && curl -s "${SHELLCHECK_URL}" | tar -xJv \
    && install "${SHELLCHECK_DIR}/shellcheck" /usr/local/bin
RUN git clone --depth 1 --branch v1.1.0 https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local
RUN git clone --depth 1 --branch v36 https://github.com/SimonKagstrom/kcov.git \
    && mkdir -p kcov/build \
    && cd kcov/build \
    && cmake .. \
    && make \
    && make install
COPY --chown=payload . ./getopts_long
RUN cd ./getopts_long \
    && TZ=UTC git show \
        --pretty=tformat:"%H%+D%+ad%n%+s" \
        --date=format-local:"%c %Z" \
        | head -5 > ./VERSION \
    && rm -Rf \
        ./.git \
        ./docker-fs
WORKDIR /home/getopts_long
ENTRYPOINT ["/etc/entrypoint.d/login_shell"]

FROM base AS final
WORKDIR /home
COPY --from=build --chown=root /usr/local /usr/local
COPY --from=build --chown=payload /home/getopts_long /home
USER payload
RUN ./bin/test
WORKDIR /mnt
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/entrypoint.d/test_payload"]
