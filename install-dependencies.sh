#!/bin/bash
#
# Authors:
#   Francisco Suarez <fsuarez6.github.io>
#
# Description:
#   OpenRAVE Installation Script: Dependencies

# Check ubuntu version
UBUNTU_VER=$(lsb_release -sr)
if [ ${UBUNTU_VER} != '14.04' ] && [ ${UBUNTU_VER} != '16.04' ] && [ ${UBUNTU_VER} != '18.04' ] && [ ${UBUNTU_VER} != '20.04' ]; then
    echo "ERROR: Unsupported Ubuntu version: ${UBUNTU_VER}"
    echo "  Supported versions are: 14.04, 16.04, 18.04 and 20.04"
    exit 1
fi

# Install dependencies
echo ""
echo "Installing OpenRAVE dependencies..."
echo ""
echo "Requires root privileges:"
# Update
if [ ${UBUNTU_VER} = '14.04' ]; then
  # ROS Indigo repository
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
  # Additional PPAs
  sudo apt-add-repository -y ppa:imnmfotmal/libccd
fi
sudo apt-get update

# Programs
if [ ${UBUNTU_VER} = '20.04' ]; then
  sudo apt-get install -y --no-install-recommends build-essential cmake doxygen \
  g++ git octave wget mlocate python2-pip python-dev-is-python2
  # install python 2 libraries using pip
  pip install --user numpy scipy matplotlib ipython jupyter pandas sympy nose \
  h5py setuptools wheel
else
  sudo apt-get install -y --no-install-recommends build-essential cmake doxygen   \
  g++ git ipython octave python-dev python-h5py python-numpy python-pip           \
  python-scipy python-setuptools python-wheel wget mlocate
fi

if [ ${UBUNTU_VER} = '14.04' ]; then
  sudo apt-get install -y --no-install-recommends qt4-dev-tools zlib-bin
elif [ ${UBUNTU_VER} = '16.04' ] || [ ${UBUNTU_VER} = '18.04' ] || [ ${UBUNTU_VER} = '20.04' ]; then
  sudo apt-get install -y --no-install-recommends qt5-default minizip
fi
# Libraries
sudo apt-get install -y --no-install-recommends ann-tools libann-dev            \
libassimp-dev libavcodec-dev libavformat-dev libeigen3-dev libfaac-dev          \
libflann-dev libfreetype6-dev liblapack-dev libglew-dev libgsm1-dev             \
libmpfi-dev  libmpfr-dev liboctave-dev libode-dev libogg-dev libpcre3-dev       \
libqhull-dev libswscale-dev libtinyxml-dev      \
libvorbis-dev libx264-dev libxml2-dev libxvidcore-dev libbz2-dev
if [ ${UBUNTU_VER} = '14.04' ]; then
  sudo apt-get install -y --no-install-recommends collada-dom-dev libccd      \
  libpcrecpp0 liblog4cxx10-dev libqt4-dev libsoqt-dev-common libsoqt4-dev
elif [ ${UBUNTU_VER} = '16.04' ] || [ ${UBUNTU_VER} = '18.04' ]; then
  sudo apt-get install -y --no-install-recommends libccd-dev                  \
  libcollada-dom2.4-dp-dev liblog4cxx-dev libminizip-dev octomap-tools libsoqt-dev-common libsoqt4-dev
elif [ ${UBUNTU_VER} = '20.04' ]; then
  sudo apt-get install -y --no-install-recommends libccd-dev                  \
  libcollada-dom2.4-dp-dev liblog4cxx-dev libminizip-dev octomap-tools libsoqt520
fi

# Install boost
if [ ${UBUNTU_VER} = '14.04' ] || [ ${UBUNTU_VER} = '16.04' ]; then
    sudo apt-get install -y --no-install-recommends libboost-all-dev libboost-python-dev
elif [ ${UBUNTU_VER} = '18.04' ] || [ ${UBUNTU_VER} = '20.04' ]; then
    # Install boost 1.58 from source
    BOOST_SRC_DIR=~/git/boost_1_58_0
    mkdir -p ~/git; cd ~/git
    wget http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz -O ${BOOST_SRC_DIR}.tar.gz
    tar -xzf ${BOOST_SRC_DIR}.tar.gz
    cd ${BOOST_SRC_DIR}
    ./bootstrap.sh --exec-prefix=/usr/local
    ./b2 -j `nproc`
    sudo ./b2 -j `nproc` install threading=multi
fi

# updatedb for debugging purposes
sudo updatedb
