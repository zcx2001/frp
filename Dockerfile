FROM ubuntu:22.04

ARG RUNNER=local

ENV DEBIAN_FRONTEND=noninteractive

# 修正中文显示
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# 添加frp
ENV PATH=/opt/frp${PATH:+:${PATH}}
ADD files/frp_0.54.0_linux_amd64.tar.gz /opt

RUN if [ "${RUNNER}" != "github" ]; then \
        sed -i -E 's/(archive|security|ports).ubuntu.(org|com)/mirrors.aliyun.com/g' /etc/apt/sources.list; \
    fi  \
    && apt-get update &&  apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
      ca-certificates locales tzdata dumb-init \
    && locale-gen en_US.UTF-8  \  
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /opt/frp_0.54.0_linux_amd64 /opt/frp 

ENTRYPOINT ["/usr/bin/dumb-init", "--"]