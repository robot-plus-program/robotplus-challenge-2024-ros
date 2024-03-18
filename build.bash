#!/usr/bin/env bash
# Set Build Environment Arguments
ubuntu_release=20.04
ros_ver=noetic
name_catkin_ws=catkin_ws
user_name=ros
password=keti

docker build -t robotplus-challenge-2024-ros:base . \
            --build-arg UBNUTU_RELEASE=$ubuntu_release \
            --build-arg ROS_VER=$ros_ver \
            --build-arg NAME_CATKIN_WS=$name_catkin_ws \
            --build-arg USER_NAME=$user_name \
            --build-arg PASSWORD=$password
