FROM ubuntu:20.04

ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Acquire::Check-Date false;' | tee -a /etc/apt/apt.conf.d/10-nocheckvalid \
    && apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    python3-opencv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

FROM px4io/px4-dev-ros2-foxy:latest
