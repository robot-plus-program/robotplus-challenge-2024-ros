#!/bin/bash
set -e

name_ros_version=$ROS_VERSION

echo "[Install ROS $name_ros_version]"

echo "[Update the package lists]"
apt-get update -y

echo "[Install build environment, the chrony, ntpdate and set the ntpdate]"
apt-get install -y chrony curl build-essential

echo "[Add the ROS repository]"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
fi

echo "[Download the ROS keys]"
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

echo "[Update the package lists]"
apt-get update -y

echo "[Install ros-desktop-full version of Noetic"
apt-get install -y ros-$ROS_VERSION-desktop-full

echo "[Install RQT & Gazebo]"
apt-get install -y ros-$ROS_VERSION-rqt-* ros-$ROS_VERSION-gazebo-*

echo "[Environment setup and getting rosinstall]"
source /opt/ros/$name_ros_version/setup.bash
apt-get install -y python3-rosinstall python3-rosinstall-generator python3-wstool build-essential git

echo "[Install rosdep and Update]"
apt-get install python3-rosdep

echo "[Initialize rosdep and Update]"
sh -c "rosdep init"
rosdep update

echo "[Make the catkin workspace and test the catkin_make]"
mkdir -p $HOME/$CATKIN_WS_NAME/src
cd $HOME/$CATKIN_WS_NAME/src
catkin_init_workspace
cd $HOME/$CATKIN_WS_NAME
catkin_make

echo "[Set the ROS evironment]"
sh -c "echo \"alias eb='nano ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias sb='source ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias gs='git status'\" >> ~/.bashrc"
sh -c "echo \"alias gp='git pull'\" >> ~/.bashrc"
sh -c "echo \"alias cw='cd ~/$CATKIN_WS_NAME'\" >> ~/.bashrc"
sh -c "echo \"alias cs='cd ~/$CATKIN_WS_NAME/src'\" >> ~/.bashrc"
sh -c "echo \"alias cm='cd ~/$CATKIN_WS_NAME && catkin_make'\" >> ~/.bashrc"

sh -c "echo \"source /opt/ros/$name_ros_version/setup.bash\" >> ~/.bashrc"
sh -c "echo \"source ~/$CATKIN_WS_NAME/devel/setup.bash\" >> ~/.bashrc"

sh -c "echo \"export ROS_MASTER_URI=http://localhost:11311\" >> ~/.bashrc"
sh -c "echo \"export ROS_HOSTNAME=localhost\" >> ~/.bashrc"

source $HOME/.bashrc

echo "[Complete!!!]"
