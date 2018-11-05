# OpenPose Runtime/Development Docker Image [Linux]
[![N|Solid](http://turlucode.com/wp-content/uploads/2017/10/turlucode_.png)](http://turlucode.com/)

With these docker images you can have an isolated working environment to work on or run the [OpenPose project](https://github.com/CMU-Perceptual-Computing-Lab/openpose).

More info in [this blog post](http://turlucode.com/ros-docker-container-gui-support/).

# Getting Started

## Non-GPU Image

Go to [Build Image](#build-desired-docker-image)

## NVIDIA docker
For machines that are using NVIDIA graphics cards we need to have the [nvidia-docker-plugin].

__IMPORTANT:__ This repo supports `nvidia-docker` version `2.x`!!!

### Install nvidia-docker-plugin 
Assuming the NVIDIA drivers and Docker® Engine are properly installed (see 
[installation](https://github.com/NVIDIA/nvidia-docker/wiki/Installation))

#### _Ubuntu 14.04/16.04/18.04, Debian Jessie/Stretch_
```sh
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

#### _CentOS 7 (docker-ce), RHEL 7.4/7.5 (docker-ce), Amazon Linux 1/2_

If you are __not__ using the official `docker-ce` package on CentOS/RHEL, use the next section.

```sh
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo yum remove nvidia-docker

# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo yum install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

If `yum` reports a conflict on `/etc/docker/daemon.json` with the `docker` package, you need to use the next section instead.

For `docker-ce` on `ppc64le`, look at the [FAQ](https://github.com/nvidia/nvidia-docker/wiki/Frequently-Asked-Questions#do-you-support-powerpc64-ppc64le).

#### _Arch-linux_
```sh
# Install nvidia-docker and nvidia-docker-plugin
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f

sudo rm /usr/bin/nvidia-docker /usr/bin/nvidia-docker-plugin

# Install nvidia-docker2 from AUR and reload the Docker daemon configuration
yaourt -S aur/nvidia-docker
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

#### Proceed only if `nvidia-smi` works

If the `nvidia-smi` test was successful you may proceed. Otherwise please visit the 
[official NVIDIA support](https://github.com/NVIDIA/nvidia-docker).

## Build desired Docker Image

You can either browse to directory of the version you want to install and issue 
manually a `docker build` command or just use the makefile:
````sh
# Prints Help
make

# E.g. Build image with CUDA 10 and cuDNN 7 support
make openpose_cuda10_cudnn7
````
_Note:_ The build process takes a while.

### Running the image (as root)
Once the container has been built, you can issue the following command to run it:
````sh
docker run --rm -it --runtime=nvidia --privileged --net=host --ipc=host \
-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
-v <PATH_TO_YOUR_OPENPOSE_PROJECT>:/root/openpose \
turlucode/openpose:cuda10-cudnn7
````
A terminator window will pop-up and the rest you know it! :)

_Important Remark_: This will launch the container as root. This might have unwanted effects! If you want to run it as the current user, see next section.

### Running the image (as current user)
You can also run the script as the current linux-user by passing the `DOCKER_USER_*` variables like this:
````sh
docker run --rm -it --runtime=nvidia --privileged --net=host --ipc=host \
-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/home/$(id -un)/.Xauthority -e XAUTHORITY=/home/$(id -un)/.Xauthority \
-e DOCKER_USER_NAME=$(id -un) \
-e DOCKER_USER_ID=$(id -u) \
-e DOCKER_USER_GROUP_NAME=$(id -gn) \
-e DOCKER_USER_GROUP_ID=$(id -g) \
-v <PATH_TO_YOUR_OPENPOSE_PROJECT>:/root/openpose \
turlucode/openpose:cuda10-cudnn7
````

_Important Remark_: 

- Please note that you need to pass the `Xauthority` to the correct user's home directory.
- You may need to run `xhost si:localuser:$USER` or worst case `xhost local:root` if get errors like `Error: cannot open display`

## Other options

### Mount the local `openpose` project

To mount your local `openpose` you can just use the following docker feature:
````sh
# for root user
-v $HOME/<some_path>/openpose:/root/openpose
# for local user
-v $HOME/<some_path>/openpose:/home/$(id -un)/openpose
````

### Mount PyCharm

If you use localy [PyCharm](https://www.jetbrains.com/pycharm/download/#section=linux) you can also expose it to your docker image and used inside the container.

````sh
# Mount PyCharm program folder
-v $HOME/<some_path>/pycharm-community:/home/$(id -un)/pycharm-community
# Mount PyCharm config folder
-v $HOME/<some_path>/pycharm_config:/home/$(id -un)/.PyCharmCE2018.2
````
_Important Remark_: Note that depending on the PyCharm version you are using, the mounting point `.PyCharmCE2018.2` might be different. Verify it first in your local machine.

### Mount your ssh-keys
For both root and custom user use:

```sh
-v $HOME/.ssh:/root/.ssh
```
For the custom-user the container will make sure to copy them to the right location.

### Passing a camera device
If you have a virtual device node like `/dev/video0`, e.g. a compatible usb camera, you pass this to the docker container like this:
````sh
--device /dev/video0
````

# Building OpenPose

Assuming you either mounted the OpenPose project or clonned it inside docker, a typical build sequence is:
````sh
cd <openpose_project_root_folder>
mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_PYTHON=ON ..
make -j8 && sudo make install
````
_For more details [check the official instructions](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/installation.md)_

# Base images

The images on this repository are based on the following work:

  - [nvidia-opengl](https://gitlab.com/nvidia/samples/blob/master/opengl/ubuntu14.04/glxgears/Dockerfile)
  - [nvidia-cuda](https://gitlab.com/nvidia/cuda) - Hierarchy is base->runtime->devel

# Issues and Contributing
  - Please let us know by [filing a new 
issue](https://github.com/turlucode/ros-docker-gui/issues/new).
  - You can contribute by [opening a pull 
request](https://github.com/turlucode/ros-docker-gui/compare).


   [nvidia-docker]: https://github.com/NVIDIA/nvidia-docker
   [nvidia-docker-plugin]: 
https://github.com/NVIDIA/nvidia-docker/wiki/nvidia-docker-plugin
