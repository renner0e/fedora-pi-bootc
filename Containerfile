FROM scratch AS ctx

COPY build_files /build
COPY files /files

FROM quay.io/fedora/fedora-bootc:44

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /ctx/build/01-packages.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /ctx/build/02-arm.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/04-misc.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build/10-cleanup.sh && \
    /ctx/build/05-initramfs.sh && \
    /ctx/build/post.sh

RUN bootc container lint --no-truncate --fatal-warnings
