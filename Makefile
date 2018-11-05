.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
openpose_base: ## [NVIDIA] Build OpenPose Base (Ubuntu 16.04)
	docker build -t turlucode/openpose:base base
	@printf "\n\033[92mDocker Image: turlucode/openpose:base\033[0m\n"

openpose_cuda8: openpose_base_nvidia ## [NVIDIA] Build OpenPose (CUDA  8 - no cuDNN)
	docker build -t turlucode/openpose:cuda8 nvidia/cuda8
	@printf "\n\033[92mDocker Image: turlucode/openpose:cuda8\033[0m\n"

openpose_cuda8_cudnn5: openpose_cuda8 ## [NVIDIA] Build OpenPose (CUDA  8 - cuDNN 5)
	docker build -t turlucode/openpose:cuda8-cudnn5 nvidia/cuda8/cudnn6
	@printf "\n\033[92mDocker Image: turlucode/openpose:cuda8-cudnn5\033[0m\n"

openpose_cuda8_cudnn6: openpose_cuda8 ## [NVIDIA] Build OpenPose (CUDA  8 - cuDNN 6)
	docker build -t turlucode/openpose:cuda8-cudnn6 nvidia/cuda8/cudnn6
	@printf "\n\033[92mDocker Image: turlucode/openpose:cuda8-cudnn6\033[0m\n"

openpose_cuda8_cudnn7: openpose_cuda8 ## [NVIDIA] Build OpenPose (CUDA  8 - cuDNN 7)
	docker build -t turlucode/openpose:cuda8-cudnn6 nvidia/cuda8/cudnn7
	@printf "\n\033[92mDocker Image: turlucode/openpose:cuda8-cudnn7\033[0m\n"

openpose_cuda10: openpose_base_nvidia ## [NVIDIA] Build OpenPose (CUDA 10 - no cuDNN)
	docker build -t turlucode/openpose:cuda10 nvidia/cuda10
	@printf "\n\033[92mDocker Image: turlucode/openpose:cuda10\033[0m\n"

openpose_cuda10_cudnn7: openpose_cuda10 ## [NVIDIA] Build OpenPose (CUDA 10 - cuDNN 7)
	docker build -t turlucode/openpose:cuda10-cudnn7 nvidia/cuda10/cudnn7
	@printf "\n\033[92mDocker Image: turlucode/openpose:cuda10-cudnn7\033[0m\n"


## Helper TASKS

openpose_nvidia_help: ## [NVIDIA] Prints help and hints on how to run an OpenPose-devel images
	 @printf "  - Make sure the nvidia-docker-plugin (Test it with: docker run --rm --runtime=nvidia nvidia/cuda:9.0-base nvidia-smi)\n  - Command example:\ndocker run --rm -it --runtime=nvidia --privileged --net=host --ipc=host \\ \n-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \\ \n-v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \\ \n-v <PATH_TO_YOUR_OPENPOSE_PROJECT>:/root/openpose \\ \nturlucode/openpose:cuda10-cudnn7\n"
