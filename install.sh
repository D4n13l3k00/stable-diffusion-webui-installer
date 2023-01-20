#!/bin/bash

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
                    linux-headers-$(uname -r)

echo -e "${YELLOW}Changing shell to zsh${NC}"
chsh -s $(which zsh)

echo -e "${GREEN}Downloading CUDA 12 keyring${NC}"
aria2c https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
echo -e "${GREEN}Installing CUDA 12 keyring${NC}"
dpkg -i cuda-keyring_1.0-1_all.deb
echo -e "${GREEN}Adding CUDA 12 repository${NC}"
apt update
echo -e "${GREEN}Installing CUDA 12${NC}"
apt -y install cuda

echo -e "${CYAN}Cloning repository${NC}"
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui sd
cd sd

echo -e "${CYAN}Downloading models${NC}"

CHOICES=(
    "1" "Stable-Diffusion 1.5" off
    "2" "Stable-Diffusion 1.5 Inpainting" off
    "3" "Anything-V3.0" off
    "4" "Deliberate (by XpucT)" off
)

CHOICE=$(dialog --clear --title "Choose models to download" --checklist " " 0 0 0 "${CHOICES[@]}" 2>&1 >/dev/tty)

MAGNET_SD_1_5=$(echo "H4sIAAAAAAAAA5WS227DIAyG7/ce7V2sATk0lao9CyROwhIOIlA1ffqxra2qrWqoxIXB/mT7/1G81+j3Hyd/CE7vhZfDnrYcu0IUXck4KXnNu5qUNS9oLQivKtY1eUFLVm1bfTiSrMisCxrbDBU3elqgGa3fencIrd0wvqFdPN7xZkQHxqL+iWPo+pgmjFUxz7U2QTf4l6vBcSd6aIyKb3RH3p8U3zcR0nvjXOx2Ycu6rJ+wt8EiL6kFZ5pxfowN3tt5Fcxz9oBLm3WXsuUVwXCRMi/IyoIwe+STH2CWa12OUiDME6JdpPbo4i/pgobTcv42rWK79QkptBNefU5ZiYDwoEyMow4wulQlzqjMZ5rNN/GkXrKjnV+kBjTjDFGLdMYGMcnmevvVLxFVRsvosvQ5KHwFw1Hq/iVmwimcoJPpxJ23iQR3avlf/fYFCq5qSIMEAAA=" | base64 -d | gunzip)
MAGNET_SD_1_5_INPAINTING=$(echo "H4sIAAAAAAAAA5WT226DMAyG7/ce3R0WCbRApWrPkoApGeSgHLq2T7+wtdPUrSWVcuFgPn77t5Fsr9Bv345+F6zaci+GLV/TgjVYEYY5RVpxWud5hS0jTd6XpGmalrKuI6+d2rkuO5BsnQllmFBeqD20o/Gv3u5CZ1YFW9E+Hm9ZO6IFbVB9xTG0+5gmRVHFPFNKB9XiLdeAZZbHb2oZn9Ga5A9e/i3Chffa2qh2YTfNprlhB+8T4fqR7E9PkRbUgNXt6O4rukWwLIuELq8VYrhYWa7JQpXgPLLJD+DEUlMHwRHchGhOcaxo45L0QcHxdJ6HVhX1coUUugmvc34odgEIcA9SxzjaDqNNxOCMUr/fH/O/5gl1yg7GPUkNqEcH0Yt0xn2waLqcbYAwzktcJS2xCXwS7fX27XuipNGyB4ep9kmtRFwm4UuQmK4iNY7z7/4MM+EUjtCLv8TLJ6viCTyJBAAA" | base64 -d | gunzip)

cd models/Stable-diffusion
if [[ $CHOICE == *"1"* ]]
  then
    echo -e "${CYAN}Downloading Stable-Diffusion 1.5${NC}"
    aria2c --seed-time=0 $MAGNET_SD_1_5 2>&1 | dialog --title "Downloading $(CHOICES[0])" --progressbox 20 70
    
fi

if [[ $CHOICE == *"2"* ]]
  then
    echo -e "${CYAN}Downloading Stable-Diffusion 1.5 Inpainting${NC}"
    aria2c --seed-time=0 $MAGNET_SD_1_5_INPAINTING 2>&1 | dialog --title "Downloading $(CHOICES[1])" --progressbox 20 70
fi

if [[ $CHOICE == *"3"* ]]
  then
    echo -e "${CYAN}Downloading Anything-V3.0${NC}"
    aria2c -x4 https://huggingface.co/Linaqruf/anything-v3.0/resolve/main/Anything-V3.0-pruned.ckpt 2>&1 | dialog --title "Downloading $(CHOICES[2])" --progressbox 20 70

if [[ $CHOICE == *"4"* ]]
  then
    echo -e "${CYAN}Downloading Deliberate (by XpucT)${NC}"
    aria2c -x4 https://civitai.com/api/download/models/5616 2>&1 | dialog --title "Downloading $(CHOICES[3])" --progressbox 20 70
fi
cd ../..

echo -e "${CYAN}Allowing running from root${NC}"
sed -i 's/can_run_as_root=0/can_run_as_root=1/' webui.sh

echo -e "${GREEN}All done!${NC}"
echo -e "${GREEN}Run ${CYAN}./webui.sh --listen${GREEN} to start the webui${NC}"
IP=$(curl -sL ident.me)
echo -e "${GREEN}The address will be http://${IP}:7860/${NC}"
echo -e "${GREEN}Inpainting work on Firefox (I tested Chrome and it doesn't work)${NC}"