#!/bin/bash

# install.sh

# --
# Setup python environment

conda create -y -n pygunrock_env python=3.7
conda activate pygunrock_env
conda install -y -c pytorch pytorch==1.7.1 cudatoolkit=11.0

pip install scipy

# --
# Clone pybind11

git clone https://github.com/pybind/pybind11

# --
# Build

export ANACONDA_PATH=/home/ubuntu/anaconda3/envs/pygunrock_env/
export PYTORCH_VERSION=pytorch-1.7.1-py3.7_cuda11.0.221_cudnn8.0.5_0 # ls $ANACONDA_PATH/pkgs | fgrep pytorch-1.7.1
./build.sh