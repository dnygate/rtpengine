# Hudl production rtpengine image — built from THIS checkout (the
# feature/ssrc-force-egress fork), not a git clone. Mirrors the proven
# opensips-edge/rtpengine/Dockerfile build (Debian bookworm, userspace-only,
# transcoding on) so the c2 rtpengine role can swap image sources without any
# job-spec change. Config is baked at /etc/rtpengine/rtpengine.conf (the tuned
# Hudl conf — table=-1, audio-player=on-demand); runtime knobs (interface,
# port range, ng-listen, log-level) are overridden by CLI args in the Nomad
# job spec, which always win over the file.

FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        pkg-config \
        libglib2.0-dev \
        libssl-dev \
        libpcre3-dev \
        libxmlrpc-core-c3-dev \
        libcurl4-openssl-dev \
        libevent-dev \
        libjson-glib-dev \
        libpcap-dev \
        libavcodec-dev \
        libavfilter-dev \
        libavformat-dev \
        libavutil-dev \
        libswresample-dev \
        libswscale-dev \
        libspandsp-dev \
        libhiredis-dev \
        libopus-dev \
        libbcg729-dev \
        libwebsockets-dev \
        libnftnl-dev \
        libmnl-dev \
        libmosquitto-dev \
        default-libmysqlclient-dev \
        libxtables-dev \
        libncursesw5-dev \
        libjwt-dev \
        gperf \
        markdown \
        pandoc \
        zlib1g-dev \
        && rm -rf /var/lib/apt/lists/*

COPY . /build/rtpengine

WORKDIR /build/rtpengine
RUN make -C daemon -j"$(nproc)" \
        with_iptables_option=no \
        with_nftables_option=no \
        with_transcoding=yes

# -----------------------------------------------------------------
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libglib2.0-0 \
        libssl3 \
        libpcre3 \
        libxmlrpc-core-c3 \
        libcurl4 \
        libevent-2.1-7 \
        libjson-glib-1.0-0 \
        libpcap0.8 \
        libevent-pthreads-2.1-7 \
        libevent-openssl-2.1-7 \
        libavcodec59 \
        libavfilter8 \
        libavformat59 \
        libavutil57 \
        libswresample4 \
        libswscale6 \
        libspandsp2 \
        libhiredis0.14 \
        libopus0 \
        libbcg729-0 \
        libwebsockets17 \
        libnftnl11 \
        libmnl0 \
        libmosquitto1 \
        libmariadb3 \
        libncursesw6 \
        libjwt0 \
        zlib1g \
        && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/rtpengine/daemon/rtpengine /usr/local/bin/rtpengine
COPY docker/hudl.rtpengine.conf /etc/rtpengine/rtpengine.conf

ENTRYPOINT ["/usr/local/bin/rtpengine"]
CMD ["--config-file=/etc/rtpengine/rtpengine.conf", "--foreground", "--log-stderr"]
