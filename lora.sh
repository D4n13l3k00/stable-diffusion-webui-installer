#!/bin/bash

# AGPL-3.0 License

# Author of this script:
#  github.com/D4n13lk300
#        t.me/D4n13lk300

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BG_RED='\033[41m'
NC='\033[0m'

if [ ! -t 0 ]
then echo -e "${WHITE}${BG_RED}Please run this script directly${NC}"
    exit
fi

if [ "$EUID" -ne 0 ]
then echo -e "${WHITE}${BG_RED}Please run as root${NC}"
    exit
fi

if [ "$(lsb_release -rs)" != "22.04" ]
then echo -e "${WHITE}${BG_RED}This script only works on Ubuntu 22.04${NC}"
    exit
fi

echo -e "${YELLOW}Updating system${NC}"
apt update -y
apt upgrade -y
echo -e "${CYAN}Installing main dependencies${NC}"
apt install -y git curl wget aria2 p7zip-full \
neovim zsh tree \
p7zip-rar python3 \
python3-pip \
python3-setuptools \
python3-venv \
python3-numpy \
dialog \
linux-headers-$(uname -r) \
python3-tk

echo -e "${YELLOW}Changing shell to zsh${NC}"
chsh -s $(which zsh)

if [ ! -f /usr/bin/nvidia-smi ]
then
    echo -e "${GREEN}Downloading CUDA 12 keyring${NC}"
    aria2c https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb -o cuda.deb
    echo -e "${GREEN}Installing CUDA 12 keyring${NC}"
    dpkg -i cuda.deb
    echo -e "${GREEN}Adding CUDA 12 repository${NC}"
    apt update
    echo -e "${GREEN}Installing CUDA 12${NC}"
    apt -y install cuda
    rm cuda.deb
else
    echo -e "${GREEN}Nvidia drivers detected, skipping CUDA installation${NC}"
fi

if [ ! -d $HOME/miniconda ]
then
    echo -e "${GREEN}Installing miniconda${NC}"
    aria2c -x2 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh
    chmod +x miniconda.sh
    ./miniconda.sh -b -p $HOME/miniconda
    rm miniconda.sh
    
    echo -e "${GREEN}Adding miniconda to PATH${NC}"
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.zshrc
    
    echo -e "${GREEN}Installing conda packages${NC}"
    $HOME/miniconda/bin/conda init {zsh,bash}
    $HOME/miniconda/bin/conda config --set auto_activate_base false
    $HOME/miniconda/bin/conda create -n kohya python=3.10 cudatoolkit -y
    rm miniconda.sh
else
    echo -e "${GREEN}Miniconda detected, skipping installation${NC}"
fi

source $HOME/miniconda/etc/profile.d/conda.sh
conda activate kohya

echo -e "${GREEN}Installing kohya_ss${NC}"
git clone https://github.com/bmaltais/kohya_ss
cd kohya_ss
chmod +x setup.sh
./setup.sh

echo -e "${GREEN}Installation complete${NC}"
echo -e "${GREEN}Activate conda environment with \`conda activate kohya\`${NC}"
echo -e "${GREEN}Enter into kohya_ss directory with \`cd kohya_ss\`${NC}"
echo -e "${GREEN}Run \`./gui.sh --share\` to run server${NC}"
