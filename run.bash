#!/usr/bin/env bash
# Set SSH Port Number
ssh_port_num=4000

xhost +

docker run -d \
  -it \
  --privileged \
  --gpus all \
  -p $ssh_port_num:22 \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  robotplus-challenge-2024-ros-cuda:base
