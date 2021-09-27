FROM --platform=$TARGETPLATFORM golang:1.16.8-alpine3.14
RUN set -eux; \
        apk add -U --no-cache \
            make \
            curl \
            jq \
            bash \
            docker-cli \
            git \
            openssl \
            gcc 

# NB(thxCode): automatic platform ARGs, ref to:
# - https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

MAINTAINER Frank Mai <thxcode0824@gmail.com>
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL \
    io.github.thxcode.build-date=$BUILD_DATE \
    io.github.thxcode.name="drone-dapper" \
    io.github.thxcode.description="Drone plugin for using dapper." \
    io.github.thxcode.url="https://github.com/thxcode/drone-dapper" \
    io.github.thxcode.vcs-type="Git" \
    io.github.thxcode.vcs-ref=$VCS_REF \
    io.github.thxcode.vcs-url="https://github.com/thxcode/drone-dapper.git" \
    io.github.thxcode.vendor="thxcode" \
    io.github.thxcode.version=$VERSION \
    io.github.thxcode.schema-version="1.0" \
    io.github.thxcode.license="Apache 2.0" \
    io.github.thxcode.docker.dockerfile="/Dockerfile"

ENV DAPPER_VERSION=v0.5.6
ENV ARCH=$TARGETARCH
RUN if [ "${ARCH}" = "amd64" ]; then \
        export ARCH="x86_64"; \
    elif [ "${ARCH}" = "arm64" ]; then \
        export ARCH="aarch64"; \
    elif [ "${ARCH}" = "arm/v6" ]; then \
        export ARCH="armv6l"; \
    elif [ "${ARCH}" = "arm/v7" ]; then \
        export ARCH="armv7l"; \
    fi; \
    curl -fL "https://github.com/rancher/dapper/releases/download/${DAPPER_VERSION}/dapper-$(uname -s)-${ARCH}" -o /usr/local/bin/dapper; \
    chmod +x /usr/local/bin/dapper && dapper -v

ENTRYPOINT ["/bin/bash"]
