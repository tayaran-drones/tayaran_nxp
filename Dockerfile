FROM px4io/px4-dev-ros2-foxy:latest

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
ENV PYTHONPATH="/opt/ros/foxy/lib/python3.8/site-packages:/src/app"
ENV AMENT_PREFIX_PATH=/opt/ros/foxy
ENV ROS_VERSION=2
ENV ROS_PYTHON_VERSION=3
ENV SHLVL=1
ENV LD_LIBRARY_PATH=/opt/ros/foxy/opt/yaml_cpp_vendor/lib:/opt/ros/foxy/opt/rviz_ogre_vendor/lib:/opt/ros/foxy/lib/x86_64-linux-gnu:/opt/ros/foxy/lib
ENV ROS_LOCALHOST_ONLY=0
ENV LC_ALL=C.UTF-8
ENV PATH=/opt/ros/foxy/bin:/usr/lib/ccache:/opt/gradle/gradle-6.3-rc-4/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CCACHE_UMASK=000
ENV ROS_DISTRO=foxy

SHELL ["/bin/bash", "-c"]
