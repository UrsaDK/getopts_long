FROM debian:stable-slim AS base
LABEL org.opencontainers.image.vendor="Dmytro Konstantinov" \
    org.opencontainers.image.source="https://github.com/UrsaDK/getopts_long" \
    org.opencontainers.image.revision="${BUILD_SHA}" \
    org.opencontainers.image.created="${BUILD_DATE}"
COPY ./dockerfs /
RUN cp -a /etc/skel/.??* /root \
    && adduser --quiet --uid 1000 --disabled-password --disabled-login \
        --no-create-home --home /home --shell /bin/bash --gecos "" guest \
    && cp /etc/skel/.??* /home \
    && chown -R guest:guest /home /mnt
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
        python3 \
        zlib1g \
    && apt-get --purge autoremove \
    && apt-get clean
VOLUME ["/mnt"]
ENV ENV="/etc/init.d/login_shell"
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM base AS tools
RUN apt-get -y update \
    && apt-get -y install \
        apt-utils \
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
RUN ln -sf /mnt getopts_long
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM tools AS shellcheck
WORKDIR /home
ADD https://api.github.com/repos/koalaman/shellcheck/releases/latest \
    shellcheck-latest.json
RUN JQ_FILTER='.assets[]|select( \
                   .name|endswith(".linux.x86_64.tar.xz") \
               ).browser_download_url' \
    TXZ_URL="$(jq -r "${JQ_FILTER}" shellcheck-latest.json)" \
    SRC_DIR="shellcheck-$(jq -r '.tag_name' shellcheck-latest.json)" \
    && mkdir -p "${SRC_DIR}" \
    && curl -L "${TXZ_URL}" | tar -C "${SRC_DIR}" --strip-components=1 -xJ \
    && install -m 0755 -o root -g root "${SRC_DIR}/shellcheck" /usr/local/bin
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM tools AS bats-core
WORKDIR /home
ADD https://api.github.com/repos/bats-core/bats-core/releases/latest \
    bats-core-latest.json
RUN TGZ_URL="$(jq -r '.tarball_url' bats-core-latest.json)" \
    SRC_DIR="bats-core-$(jq -r '.tag_name' bats-core-latest.json)" \
    && mkdir -p "${SRC_DIR}" \
    && curl -L "${TGZ_URL}" | tar -C "${SRC_DIR}" --strip-components=1 -xz \
    && cd "${SRC_DIR}" \
    && ./install.sh /usr/local
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM tools AS kcov
WORKDIR /home
ADD https://api.github.com/repos/SimonKagstrom/kcov/releases/latest \
    kcov-latest.json
RUN TGZ_URL="$(jq -r '.tarball_url' kcov-latest.json)" \
    SRC_DIR="kcov-$(jq -r '.tag_name' kcov-latest.json)" \
    && mkdir -p "${SRC_DIR}/build" \
    && curl -L "${TGZ_URL}" | tar -C "${SRC_DIR}" --strip-components=1 -xz \
    && cd "${SRC_DIR}/build" \
    && cmake .. \
    && make \
    && make install
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM base AS latest
WORKDIR /home
COPY --from=shellcheck --chown=root /usr/local /usr/local
COPY --from=bats-core --chown=root /usr/local /usr/local
COPY --from=kcov --chown=root /usr/local /usr/local
COPY --chown=guest . .
RUN ln -sf /home/bin /root/bin
USER guest
RUN TZ=UTC git show --pretty="%H%+ad" | head -2 > ./VERSION \
    && rm -Rf \
        ./.git \
        ./dockerfs \
    && ./bin/kcov
WORKDIR /mnt
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/init.d/login_shell"]
