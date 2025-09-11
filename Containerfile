# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-bootc:42

ADD files/usr /usr
ADD files/etc /etc

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    /ctx/firmware.sh && \
    /ctx/cleanup.sh && \
    ostree container commit

# LINTING
## Verify final image and contents are correct.
RUN bootc container lint --fatal-warnings || true
