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
                    linux-headers-$(uname -r)

echo -e "${YELLOW}Changing shell to zsh${NC}"
chsh -s $(which zsh)

if [ ! -f /usr/bin/nvidia-smi ]
  then
  echo -e "${GREEN}Downloading CUDA 12 keyring${NC}"
  aria2c https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
  echo -e "${GREEN}Installing CUDA 12 keyring${NC}"
  dpkg -i cuda-keyring_1.0-1_all.deb
  echo -e "${GREEN}Adding CUDA 12 repository${NC}"
  apt update
  echo -e "${GREEN}Installing CUDA 12${NC}"
  apt -y install cuda
else
  echo -e "${GREEN}Nvidia drivers detected, skipping CUDA installation${NC}"
fi


echo -e "${CYAN}Cloning repository${NC}"
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui sd
cd sd

echo -e "${CYAN}Downloading models${NC}"

CHOICES=(
    "1" "[O] Stable-Diffusion v1.5" on
    "2" "[O] Stable-Diffusion v1.5 Inpainting" on
    "3" "[A] Anything v5" on
    "4" "[A] Elysium Anime v3" off
    "5" "[A] Waifu Diffusion v1.3" off
    "6" "[U] Deliberate v2.0" on
    "7" "[U] Deliberate v1.1" on
    "8" "[U] Deliberate Inpainting" on
    "9" "[F] f222" off
)

EXTRA_LABEL="[O] - Original\n[A] - Anime\n[U] - Universal\n[F] - Faces"


makechoice() {
    CHOICE=$(dialog --clear --title "Choose models to download" --extra-button --checklist " " 0 0 0 "${CHOICES[@]}" 2>&1 >/dev/tty)
}

makechoice

if [ "$?" = "3" ]; then
  dialog --clear --title "Help" --msgbox "$EXTRA_LABEL" 10 30
  makechoice
fi

MAGNET_SD_1_5=$(echo "H4sIAAAAAAAAA5WS227DIAyG7/ce7V2sATk0lao9CyROwhIOIlA1ffqxra2qrWqoxIXB/mT7/1G81+j3Hyd/CE7vhZfDnrYcu0IUXck4KXnNu5qUNS9oLQivKtY1eUFLVm1bfTiSrMisCxrbDBU3elqgGa3fencIrd0wvqFdPN7xZkQHxqL+iWPo+pgmjFUxz7U2QTf4l6vBcSd6aIyKb3RH3p8U3zcR0nvjXOx2Ycu6rJ+wt8EiL6kFZ5pxfowN3tt5Fcxz9oBLm3WXsuUVwXCRMi/IyoIwe+STH2CWa12OUiDME6JdpPbo4i/pgobTcv42rWK79QkptBNefU5ZiYDwoEyMow4wulQlzqjMZ5rNN/GkXrKjnV+kBjTjDFGLdMYGMcnmevvVLxFVRsvosvQ5KHwFw1Hq/iVmwimcoJPpxJ23iQR3avlf/fYFCq5qSIMEAAA=" | base64 -d | gunzip)
MAGNET_SD_1_5_INPAINTING=$(echo "H4sIAAAAAAAAA5WT226DMAyG7/ce3R0WCbRApWrPkoApGeSgHLq2T7+wtdPUrSWVcuFgPn77t5Fsr9Bv345+F6zaci+GLV/TgjVYEYY5RVpxWud5hS0jTd6XpGmalrKuI6+d2rkuO5BsnQllmFBeqD20o/Gv3u5CZ1YFW9E+Hm9ZO6IFbVB9xTG0+5gmRVHFPFNKB9XiLdeAZZbHb2oZn9Ga5A9e/i3Chffa2qh2YTfNprlhB+8T4fqR7E9PkRbUgNXt6O4rukWwLIuELq8VYrhYWa7JQpXgPLLJD+DEUlMHwRHchGhOcaxo45L0QcHxdJ6HVhX1coUUugmvc34odgEIcA9SxzjaDqNNxOCMUr/fH/O/5gl1yg7GPUkNqEcH0Yt0xn2waLqcbYAwzktcJS2xCXwS7fX27XuipNGyB4ep9kmtRFwm4UuQmK4iNY7z7/4MM+EUjtCLv8TLJ6viCTyJBAAA" | base64 -d | gunzip)

cd models/Stable-diffusion
if [[ $CHOICE == *"1"* ]]
  then
    TITLE="Downloading Stable-Diffusion v1.5"
    aria2c --enable-color=false --seed-time=0 $MAGNET_SD_1_5 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"2"* ]]
  then
    TITLE="Downloading Stable-Diffusion v1.5 Inpainting"
    aria2c --enable-color=false --seed-time=0 $MAGNET_SD_1_5_INPAINTING 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"3"* ]]
  then
    FILENAME="Anything V5.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://civitai.com/api/download/models/90854 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"4"* ]]
  then
    FILENAME="Elysium Anime V3.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://huggingface.co/hesw23168/SD-Elysium-Model/resolve/main/Elysium_Anime_V3.safetensors 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"5"* ]]
  then
    FILENAME="Waifu Diffusion v1.3.ckpt"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://huggingface.co/hakurei/waifu-diffusion-v1-3/resolve/main/wd-v1-3-float32.ckpt 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"6"* ]]
  then
    FILENAME="Deliberate v2.0.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://civitai.com/api/download/models/15236 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"7"* ]]
  then
    FILENAME="Deliberate v1.1.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://civitai.com/api/download/models/5616 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"8"* ]]
  then
    FILENAME="Deliberate Inpainting.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate-inpainting.safetensors 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi

if [[ $CHOICE == *"9"* ]]
  then
    FILENAME="f222.safetensors"
    TITLE="Downloading $TITLE"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://huggingface.co/acheong08/f222/resolve/main/f222.safetensors 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
fi
cd ../..

clear

LORAS_LIST=(
  "1" "LowRA by XpucT" off
  "2" "Lit by XpucT" off
)

CHOICE=$(dialog --clear --title "Choose LoRAs to install"  --checklist " " 0 0 0 "${LORAS_LIST[@]}" 2>&1 >/dev/tty)

if [[ $CHOICE == *"1"* ]]
  then
    mkdir -p models/Lora
    cd -p models/Lora
    FILENAME="LowRA.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://civitai.com/api/download/models/63006 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
    cd ../..
fi
if [[ $CHOICE == *"2"* ]]
  then
    mkdir -p models/Lora
    cd -p models/Lora
    FILENAME="Lit.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 https://civitai.com/api/download/models/55665 2>&1 | \
      dialog --title "$TITLE" --progressbox 40 100
    cd ../..
fi

clear

EXTENSIONS_LIST=(
    "1" "Aspect ratio selector" true
    "2" "Canvas Zoom" true
    "3" "ControlNet + Models" false
    "4" "PoseX (need ControlNet)" false
)


CHOICE=$(dialog --clear --title "Choose extensions to install"  --checklist " " 0 0 0 "${EXTENSIONS_LIST[@]}" 2>&1 >/dev/tty)

if [[ $CHOICE == *"1"* ]]
  then
    echo -e "${YELLOW} Installing Aspect Ratio selector"
    cd /root/sd/extensions
    git clone https://github.com/alemelis/sd-webui-ar
    cd /root/sd/
fi

if [[ $CHOICE == *"2"* ]]
  then
    echo -e "${YELLOW} Installing Canvas Zoom"
    cd /root/sd/extensions
    git clone https://github.com/richrobber2/canvas-zoom
    cd /root/sd/
fi

if [[ $CHOICE == *"3"* ]]
  then
    echo -e "${YELLOW}Installing ControlNet"
    mkdir -p /root/sd/models/ControlNet
    cd /root/sd/models/ControlNet
    aria2c -o "openpose.safetensors" --enable-color=false -x4 https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors 2>&1 | \
        dialog --title "Downloading ControlNet OpenPose model" --progressbox 40 100
    aria2c -o "depth.safetensors" --enable-color=false -x4 https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors 2>&1 | \
        dialog --title "Downloading ControlNet Depth model" --progressbox 40 100
    aria2c -o "canny.safetensors" --enable-color=false -x4 https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors 2>&1 | \
        dialog --title "Downloading ControlNet Canny model" --progressbox 40 100
    cd /root/sd/
    clear
    cd extensions
    git clone https://github.com/Mikubill/sd-webui-controlnet
    cd /root/sd/
fi

if [[ $CHOICE == *"4"* ]]
  then
    echo -e "${YELLOW} Installing PoseX"
    cd extensions
    git clone https://github.com/hnmr293/posex
    cd /root/sd/
fi

clear

echo -e "${CYAN}Allowing running from root${NC}"
sed -i 's/can_run_as_root=0/can_run_as_root=1/' /root/sd/webui.sh

echo -e "${GREEN}All done!${NC}"
echo -e "${GREEN}Use \`cd sd\` to enter into Stable-Diffusion folder"
echo -e "${GREEN}Run ${CYAN}./webui.sh --listen --xformers${GREEN} to start the webui${NC}"
IP=$(curl -sL ident.me)
echo -e "${CYAN}On first run it will be download some requirements. This may take a while"
echo -e "${GREEN}The address will be http://${IP}:7860/${NC}"
echo -e "${GREEN}Inpainting work on Firefox (I tested Chrome and it doesn't work)${NC}"
