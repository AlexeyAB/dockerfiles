FROM nvidia/cuda:11.2.1-cudnn8-devel

## Install OpenCV 4.5.1 last stable commit
RUN apt-get -y update
RUN apt-get -y install git wget python3-pip

ENV TZ=Europe/Moscow
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt-get -y install curl mc libeigen3-dev
RUN apt-get -y install nano tmux htop
RUN apt-get install -y build-essential cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev ocl-icd-opencl-dev libcanberra-gtk3-module
RUN pip install matplotlib

RUN git clone https://github.com/opencv/opencv.git /opt/opencv && \
    cd /opt/opencv && git checkout 4.5.1
RUN git clone https://github.com/opencv/opencv_contrib /opt/opencv_contrib && \
    cd /opt/opencv_contrib && git checkout 4.5.1

WORKDIR /opt/opencv/

RUN mkdir /opt/opencv/build
WORKDIR /opt/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
      -D WITH_OPENGL=ON \
      -D WITH_TBB=OFF \
      -D BUILD_opencv_world=OFF \
      -D BUILD_opencv_python2=ON \
      -D BUILD_opencv_python3=OFF \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D WITH_V4L=ON \
      ..
RUN make -j
RUN make install
RUN ldconfig

WORKDIR /workspace
