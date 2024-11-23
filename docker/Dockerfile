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


# Kimera
RUN apt-get update

RUN apt-get install ros-noetic-image-geometry ros-noetic-pcl-ros ros-noetic-cv-bridge

RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y \
      cmake build-essential unzip pkg-config autoconf \
      libboost-all-dev \
      libjpeg-dev libpng-dev libtiff-dev \
      libvtk7-dev libgtk-3-dev \
      libatlas-base-dev gfortran \
      libparmetis-dev \
      python3-wstool python3-catkin-tools \
      ros-noetic-hector-trajectory-server \
      libeigen3-dev

RUN apt-get install libtbb-dev

# Set working directory
WORKDIR /root

# Clone Pangolin repository
RUN git clone https://github.com/stevenlovegrove/Pangolin.git

# Change to Pangolin directory
WORKDIR /root/Pangolin

# Create build directory and navigate into it
RUN mkdir build
WORKDIR /root/Pangolin/build

# Configure and build Pangolin
RUN cmake .. && make && make install

# make python modules in /root/.local visible to non-root users
RUN find /root -type d -exec chmod 755 {} +

RUN rm -rf /tmp/* /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:borglab/gtsam-release-4.0 -y
RUN apt-get update
RUN apt install libgtsam-dev libgtsam-unstable-dev -y

RUN apt-get install -y libgoogle-glog-dev
RUN apt-get install -y libatlas-base-dev

WORKDIR /root
RUN wget -O ./ceres.zip https://github.com/ceres-solver/ceres-solver/archive/1.14.0.zip
RUN unzip ceres.zip
WORKDIR /root/ceres-solver-1.14.0
RUN mkdir ceres-bin && cd ceres-bin
WORKDIR /root/ceres-solver-1.14.0/ceres-bin
RUN cmake .. && make -j8 && make install