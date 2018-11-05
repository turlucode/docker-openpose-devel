FROM turlucode/openpose:cuda10

MAINTAINER Athanasios Tasoglou <athanasios@tasoglou.net>
LABEL Description="OpenPose Image with CUDA 10 and cuDNN 7 support" Vendor="TurluCode" Version="1.0"

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

## CUDNN Runtime-packages
ENV CUDNN_VERSION 7.3.1.20
LABEL com.turlucode.openpose.cudnn="${CUDNN_VERSION}"

## CUDNN Devel-packages
RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

# Launch terminator
CMD ["terminator"]