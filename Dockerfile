FROM node:4
MAINTAINER Olivier Louvignes <olivier@mg-crea.com>

ARG OPENCV_VERSION
ENV OPENCV_VERSION ${OPENCV_VERSION:-2.4.13}

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    cmake \
    libv4l-dev \
    opencl-headers \
    \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local
RUN curl -SLO "https://github.com/Itseez/opencv/archive/${OPENCV_VERSION}.zip" \
  && unzip ${OPENCV_VERSION}.zip \
  && mv /usr/local/opencv-${OPENCV_VERSION} /usr/local/opencv \
  && rm ${OPENCV_VERSION}.zip

RUN mkdir /usr/local/opencv/build
WORKDIR /usr/local/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_PYTHON_SUPPORT=ON \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_OPENGL=ON \
      -D WITH_TBB=OFF \
      -D BUILD_EXAMPLES=ON \
      -D BUILD_NEW_PYTHON_SUPPORT=ON \
      -D WITH_V4L=ON \
      -D WITH_OPENCL=ON \
      ..

RUN make -j7
RUN make install
