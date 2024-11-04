FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/root/.local/lib/python3.10/site-packages:$PYTHONPATH
ENV NVIDIA_DRIVER_CAPABILITIES=all

# add libglvnd support (More info: https://hub.docker.com/r/nvidia/opengl)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \ 
        unzip \
        ffmpeg \
        libsm6 \
        libxext6 \
        tmux \
        curl \
        gedit



# python base
RUN apt-get install -y --no-install-recommends \
        wget \
        ca-certificates

# from https://stackoverflow.com/questions/78148051/dockerfile-or-image-for-running-ros-noetic-with-nvidia-gpu
ENV UBUNTU_RELEASE=focal
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget --output-document - \
        https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Install ROS.
RUN apt-get update && apt-get install -y \
        ros-noetic-desktop-full \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential\
        && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init
RUN rosdep update

# make python modules in /root/.local visible to non-root users
RUN find /root -type d -exec chmod 755 {} +

RUN rm -rf /tmp/* /var/lib/apt/lists/*