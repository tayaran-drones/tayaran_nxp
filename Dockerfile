FROM px4io/px4-dev-ros2-foxy:latest

ENV ENV=/opt/ros/foxy/setup.bash
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Acquire::Check-Date false;' | tee -a /etc/apt/apt.conf.d/10-nocheckvalid \
    && apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    python3-opencv \
    xmlstarlet \
    build-essential \
    iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

WORKDIR /src/app

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/src/app

SHELL ["/bin/bash", "-c"]
