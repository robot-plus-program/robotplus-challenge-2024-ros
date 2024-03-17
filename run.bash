#!/usr/bin/env bash
# Set SSH Port Number
ssh_port_num=4000

docker run -d \
  --gpus all \
  -p $ssh_port_num:22 \
  robotplus-challenge-ros-cuda:base
