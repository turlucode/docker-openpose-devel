FROM ubuntu:16.04

MAINTAINER Athanasios Tasoglou <athanasios@tasoglou.net>
LABEL Description="OpenPose Base Image" Vendor="TurluCode" Version="1.0"

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

# Install packages
RUN apt-get update && apt-get install -y \
lsb-release \
git \
subversion \
nano \
terminator \
wget \
curl \
htop \
locales \
sudo \
software-properties-common python-software-properties \
gdb valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# OperPose Prerequisites
RUN apt-get update && apt-get install -y \
build-essential \
libatlas-base-dev \
libprotobuf-dev \
libleveldb-dev \
libsnappy-dev \
libhdf5-serial-dev \
protobuf-compiler \
libgflags-dev \
libgoogle-glog-dev \
liblmdb-dev \
cmake \
r-base \
libopencv-dev \
python-pip \
python-opencv && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
libboost-all-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Install new paramiko (solves ssh issues)
RUN apt-add-repository universe
RUN apt-get update && apt-get install -y python-pip python build-essential && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN /usr/bin/yes | pip install --upgrade pip
RUN /usr/bin/yes | pip install --upgrade virtualenv
RUN /usr/bin/yes | pip install --upgrade paramiko
RUN /usr/bin/yes | pip install --upgrade numpy protobuf

# Locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Install OhMyZSH
RUN apt-get update && apt-get install -y zsh && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
RUN chsh -s /usr/bin/zsh root
RUN git clone https://github.com/sindresorhus/pure /root/.oh-my-zsh/custom/pure
RUN ln -s /root/.oh-my-zsh/custom/pure/pure.zsh-theme /root/.oh-my-zsh/custom/
RUN ln -s /root/.oh-my-zsh/custom/pure/async.zsh /root/.oh-my-zsh/custom/
RUN sed -i -e 's/robbyrussell/refined/g' /root/.zshrc

# Terminator Config
RUN mkdir -p /root/.config/terminator/
COPY assets/terminator_config /root/.config/terminator/config 
COPY assets/terminator_background.png /root/.config/terminator/background.png

# Entry script
COPY assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]

# Launch terminator
CMD ["terminator"]
