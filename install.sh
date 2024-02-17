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


if [ "$1" == "-u" ]
then
    echo -e "${YELLOW}Upgrading system${NC}"
    DEBIAN_FRONTEND=noninteractive apt upgrade -y 
else
    echo -e "${YELLOW}Skipping system upgrade${NC}"
fi

echo -e "${CYAN}Installing main dependencies${NC}"
DEBIAN_FRONTEND=noninteractive apt install -y git curl wget aria2 p7zip-full \
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


echo -e "${CYAN}Cloning repository${NC}"
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui sd
cd sd

echo -e "${CYAN}Downloading models${NC}"

CHOICES=(
    "1" "Deliberate v5" on
    "2" "Deliberate v5 Inpainting" on
    "3" "Deliberate v5 (SFW)" off
    "4" "Deliberate v5 (SFW) Inpainting" off
    "5" "Reliberate v3" on
    "6" "Reliberate v3 Inpainting" on
    "7" "Reliberate v2" off
    "8" "Reliberate v2 Inpainting" off
    "9" "Anime v2" on
    "10" "Anime v2 Inpainting" on
    "11" "Anything V5" off
)

makechoice() {
    CHOICE=$(dialog --clear --title "Choose models to download" --checklist " " 0 0 0 "${CHOICES[@]}" 2>&1 >/dev/tty)
    local ERRORCODE=$?
    if [ $ERRORCODE -ne 0 ]; then
        echo "Error: Dialog failed with exit code $ERRORCODE"
        exit $ERRORCODE
    fi
}

makechoice

cd models/Stable-diffusion

download_model() {
    FILENAME="$1"
    TITLE="Downloading $FILENAME"
    URL="$2"
    aria2c -o "$FILENAME" --enable-color=false -x4 "$URL" 2>&1 | \
    dialog --title "$TITLE" --progressbox 40 100
}

if [[ $CHOICE == *"1"* ]]
then
    download_model "Deliberate v5.safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5.safetensors"
fi

if [[ $CHOICE == *"2"* ]]
then
    download_model "Deliberate v5 Inpainting.safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5-inpainting.safetensors"
fi

if [[ $CHOICE == *"3"* ]]
then
    download_model "Deliberate v5 (SFW).safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5 (SFW).safetensors"
fi

if [[ $CHOICE == *"4"* ]]
then
    download_model "Deliberate v5 (SFW) Inpainting.safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5 (SFW)-inpainting.safetensors"
fi

if [[ $CHOICE == *"5"* ]]
then
    download_model "Reliberate v3.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v3.safetensors"
fi

if [[ $CHOICE == *"6"* ]]
then
    download_model "Reliberate v3 Inpainting.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v3-inpainting.safetensors"
fi

if [[ $CHOICE == *"7"* ]]
then
    download_model "Reliberate v2.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v2.safetensors"
fi

if [[ $CHOICE == *"8"* ]]
then
    download_model "Reliberate v2 Inpainting.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v3-inpainting.safetensors"
fi

if [[ $CHOICE == *"9"* ]]
then
    download_model "Anime v2.safetensors" "https://huggingface.co/XpucT/Anime/resolve/main/Anime_v2.safetensors"
fi

if [[ $CHOICE == *"10"* ]]
then
    download_model "Anime v2 Inpainting.safetensors" "https://huggingface.co/XpucT/Anime/resolve/main/Anime_v2-inpainting.safetensors"
fi

if [[ $CHOICE == *"11"* ]]
then
    download_model "Anything V5.safetensors" "https://civitai.com/api/download/models/90854"
fi

cd ../..

clear

LORAS_LIST=(
    "1" "LowRA by XpucT" off
    "2" "Lit by XpucT" off
)

CHOICE=$(dialog --clear --title "Choose LoRAs to install" --checklist " " 0 0 0 "${LORAS_LIST[@]}" 2>&1 >/dev/tty)

for option in $CHOICE; do
    case $option in
        1)
            lora_name="LowRA"
            lora_url="https://civitai.com/api/download/models/63006"
            ;;
        2)
            lora_name="Lit"
            lora_url="https://civitai.com/api/download/models/55665"
            ;;
        *)
            continue
            ;;
    esac

    mkdir -p models/Lora
    cd models/Lora
    FILENAME="$lora_name.safetensors"
    TITLE="Downloading $FILENAME"
    aria2c -o "$FILENAME" --enable-color=false -x4 "$lora_url" 2>&1 | dialog --title "$TITLE" --progressbox 40 100
    cd ../..
done

clear

EXTENSIONS_LIST=(
    "1" "Aspect ratio selector" true
    "2" "Canvas Zoom" true
    "3" "ControlNet (Depth, Inpaint, LineArt, Canny)" false
)


CHOICE=$(dialog --clear --title "Choose extensions to install"  --checklist " " 0 0 0 "${EXTENSIONS_LIST[@]}" 2>&1 >/dev/tty)
local ERRORCODE=$?
if [ $ERRORCODE -ne 0 ]; then
    echo "Error: Dialog failed with exit code $ERRORCODE"
    exit $ERRORCODE
fi

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

    download_model() {
        model_name=$1
        model_url=$2
        config_name=$3
        config_url=$4

        aria2c -o "$model_name" --enable-color=false -x4 "$model_url" 2>&1 | \
            dialog --title "Downloading $model_name" --progressbox 40 100
        aria2c -o "$config_name" --enable-color=false -x4 "$config_url" 2>&1 | \
            dialog --title "Downloading $config_name" --progressbox 40 100
    }

    download_model "control_v11f1p_sd15_depth.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth" \
        "control_v11f1p_sd15_depth.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml"

    download_model "control_v11p_sd15_inpaint.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.pth" \
        "control_v11p_sd15_inpaint.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.yaml"

    download_model "control_v11p_sd15_lineart.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth" \
        "control_v11p_sd15_lineart.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.yaml"

    download_model "control_v11p_sd15_canny.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth" \
        "control_v11p_sd15_canny.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.yaml"

    cd /root/sd/
    clear
    cd extensions
    git clone https://github.com/Mikubill/sd-webui-controlnet
    cd /root/sd/
fi

clear

mkdir -p /root/sd/models/ESRGAN
cd /root/sd/models/ESRGAN

files=(
    "4x_NMKD-Siax_200k.pth:https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_NMKD-Siax_200k.pth"
    "4x-UltraSharp.pth:https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x-UltraSharp.pth"
    "WaifuGAN_v3_30000.pth:https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/WaifuGAN_v3_30000.pth"
    "4x_RealisticRescaler_100000_G.pth:https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_RealisticRescaler_100000_G.pth"
)

for file in "${files[@]}"; do
    IFS=':' read -r -a parts <<< "$file"
    filename="${parts[0]}"
    url="${parts[1]}"
    aria2c -x4 -q -o "$filename" "$url" 2>&1 | dialog --title "Downloading $filename" --progressbox 40 100
done

cd /root/sd

echo -e "${CYAN}Allowing running from root${NC}"
sed -i 's/can_run_as_root=0/can_run_as_root=1/' /root/sd/webui.sh

echo -e "${GREEN}All done!${NC}"
echo -e "${GREEN}Use \`cd sd\` to enter into Stable-Diffusion folder"
echo -e "${GREEN}Run ${CYAN}./webui.sh --listen --xformers${GREEN} to start the webui${NC}"
IP=$(curl -sL ident.me)
echo -e "${CYAN}On first run it will be download some requirements. This may take a while"
echo -e "${GREEN}The address will be http://${IP}:7860/${NC}"
