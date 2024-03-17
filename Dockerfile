ARG UBUNTU_RELEASE=20.04
ARG CUDA_VERSION=11.3.1
ARG CUDA_PURPOSE=devel
# If you need cuDNN, write "cudnn(version)-"
# ARG CUDNN_VERSION=cudnn8-
ARG CUDNN_VERSION=""

FROM nvcr.io/nvidia/cuda:${CUDA_VERSION}-${CUDNN_VERSION}${CUDA_PURPOSE}-ubuntu${UBUNTU_RELEASE}

LABEL maintainer "Jung YoHan"
LABEL maintainer "https://github.com/neoplanetz"
ENV REFRESHED_AT 2024-03-17

ARG ROS_VER=noetic
ARG NAME_CATKIN_WS=catkin_ws
ARG DEBIAN_FRONTEND=noninteractive
ARG CUDA_ENV_VERSION=11.3
ENV CUDA_ENV_VER=${CUDA_ENV_VERSION}
ENV ROS_VERSION=${ROS_VER}
ENV CATKIN_WS_NAME=${NAME_CATKIN_WS}
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# Install fundamental packages
RUN apt-get clean && apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
        apt-transport-https \
        apt-utils \
        build-essential \
        ca-certificates \
        curl \
        locales \
        software-properties-common \
        openssh-server \
        nano \
        sudo \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8
# Set locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Configure user
ARG USER_NAME=ros
ARG PASSWORD=keti
ARG uid=1000
ARG gid=1000
ENV USER=$USER_NAME
ENV PASSWD=$PASSWORD
ENV UID=$uid
ENV GID=$gid
RUN groupadd $USER && \
    useradd --create-home --no-log-init -g $USER $USER && \
    usermod -aG sudo $USER && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown $USER_NAME:$USER_NAME /home/$USER_NAME && \
    echo "$USER:$PASSWD" | chpasswd && \
    chsh -s /bin/bash $USER && \
    # Replace 1000 with your user/group id
    usermod  --uid $UID $USER && \
    groupmod --gid $GID $USER

# Configure SSH
RUN mkdir /var/run/sshd &&  \
    echo 'root:${PASSWD}' | chpasswd && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

EXPOSE 22 4000

# Install ROS Noetic
RUN apt-get update && apt-get install --no-install-recommends -y \
        chrony \
        curl && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 

RUN apt-get update && apt-get install --no-install-recommends -y \
        ros-${ROS_VERSION}-desktop-full \
        ros-${ROS_VERSION}-rqt-* \
        ros-${ROS_VERSION}-gazebo-*

RUN apt-get install --no-install-recommends -y \
        python3-rosinstall \
        python3-rosinstall-generator \
        python3-wstool \
        build-essential \
        git

RUN apt-get install --no-install-recommends -y \
        python3-rosdep && \
    sh -c "rosdep init"
    
USER $USER
WORKDIR /home/$USER
RUN rosdep update

# setup entrypoint
USER root
COPY ./ros_entrypoint.sh /
RUN chmod 755 /ros_entrypoint.sh

USER $USER
ENV SHELL /bin/bash
WORKDIR /home/$USER

ENTRYPOINT ["/ros_entrypoint.sh"]