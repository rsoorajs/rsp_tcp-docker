FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive

ADD files.tar.gz /

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates cmake git g++ make \
    && ln -s /usr/local/lib/libsdrplay_api.so.3.07 /usr/local/lib/libsdrplay_api.so.3 \
    && ln -s /usr/local/lib/libsdrplay_api.so.3 /usr/local/lib/libsdrplay_api.so \
    && ldconfig \
    && git clone https://github.com/SDRplay/RSPTCPServer /tmp/RSPTCPServer \
    && mkdir -p /tmp/RSPTCPServer/build; cd /tmp/RSPTCPServer/build \
    && cmake .. \
    && make -j$(nproc) \
    && make install \
    && apt-get autoremove --purge -y ca-certificates cmake git g++ make \
    && rm -rf /tmp/RSPTCPServer \
              /var/lib/apt/lists/* \
    && chmod 755 /opt/entrypoint.sh \
                 /usr/local/bin/sdrplay_apiService

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
