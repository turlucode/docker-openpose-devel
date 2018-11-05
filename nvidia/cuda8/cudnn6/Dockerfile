FROM turlucode/openpose:cuda8

MAINTAINER Athanasios Tasoglou <athanasios@tasoglou.net>
LABEL Description="OpenPose Image with CUDA 8 and cuDNN 6 support" Vendor="TurluCode" Version="1.0"

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

ENV CUDNN_VERSION 6.0.21
LABEL com.turlucode.openpose.cudnn="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn6=$CUDNN_VERSION-1+cuda8.0 \
            libcudnn6-dev=$CUDNN_VERSION-1+cuda8.0 && \
    rm -rf /var/lib/apt/lists/*

# Launch terminator
CMD ["terminator"]