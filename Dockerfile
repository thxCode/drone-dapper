FROM --platform=$TARGETPLATFORM docker:19.03.5
RUN apk add -U --no-cache make curl bash
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ go=1.13.8-r0

# NB(thxCode): automatic platform ARGs, ref to:
# - https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

MAINTAINER Frank Mai <frank@rancher.com>
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
    io.github.thxcode.vendor="Rancher Labs, Inc" \
    io.github.thxcode.version=$VERSION \
    io.github.thxcode.schema-version="1.0" \
    io.github.thxcode.license="Apache 2.0" \
    io.github.thxcode.docker.dockerfile="/Dockerfile"

ENV ARCH=$TARGETARCH
RUN if [ "${ARCH}" = "amd64" ]; then \
        export ARCH="x86_64"; \
    elif [ "${ARCH}" = "arm64" ]; then \
        export ARCH="aarch64"; \
    fi; \
    curl -fL "https://github.com/rancher/dapper/releases/download/v0.4.2/dapper-$(uname -s)-${ARCH}" -o /usr/local/bin/dapper; \
    chmod +x /usr/local/bin/dapper && dapper -v

ENTRYPOINT ["/bin/bash"]
