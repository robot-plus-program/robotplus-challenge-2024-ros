#!/usr/bin/env bash
# Set Build Environment Arguments
ubuntu_release=20.04
cuda_version=11.3.1
cuda_env_version=11.3
cuda_purpose=devel
cudnn_version=""
ros_ver=noetic
name_catkin_ws=catkin_ws
user_name=ros
password=keti

docker build -t robotplus-challenge-ros-cuda:base . \
            --build-arg UBNUTU_RELEASE=$ubuntu_release \
            --build-arg CUDA_VERSION=$cuda_version \
            --build-arg CUDA_ENV_VERSION=$cuda_env_version \
            --build-arg CUDA_PURPOSE=$cuda_purpose \
            --build-arg CUDNN_VERSION=$cudnn_version \
            --build-arg ROS_VER=$ros_ver \
            --build-arg NAME_CATKIN_WS=$name_catkin_ws \
            --build-arg USER_NAME=$user_name \
            --build-arg PASSWORD=$password
