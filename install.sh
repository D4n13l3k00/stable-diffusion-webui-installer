#!/bin/bash

# AGPL-3.0 License

# Author of this script:
#  github.com/D4n13lk300
#        t.me/D4n13lk300

# Define constants for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BG_RED='\033[41m'
NC='\033[0m'

# Function to handle errors and unexpected exit codes
handle_error() {
    local exit_code=$?
    echo -e "${WHITE}${BG_RED}Error: Exiting with status ${exit_code}${NC}"
    exit $exit_code
}

trap handle_error EXIT

# Check for direct run, root permission, and correct Ubuntu version
check_prerequisites() {
    if [ ! -t 0 ]; then
        echo -e "${WHITE}${BG_RED}Please run this script directly${NC}"
        exit 1
    fi

    if [ "$EUID" -ne 0 ]; then
        echo -e "${WHITE}${BG_RED}Please run as root${NC}"
        exit 1
    fi

    if [ "$(lsb_release -rs)" != "22.04" ]; then
        echo -e "${WHITE}${BG_RED}This script only works on Ubuntu 22.04${NC}"
        exit 1
    fi
}

# Function to update system
update_system() {
    echo -e "${YELLOW}Updating system${NC}"
    apt update -y

    if [ "$1" == "-u" ]; then
        echo -e "${YELLOW}Upgrading system${NC}"
        DEBIAN_FRONTEND=noninteractive apt upgrade -y 
    else
        echo -e "${YELLOW}Skipping system upgrade${NC}"
    fi
}

# Function to install main dependencies
install_dependencies() {
    echo -e "${CYAN}Installing main dependencies${NC}"
    DEBIAN_FRONTEND=noninteractive apt install -y \
        git curl wget aria2 p7zip-full neovim zsh tree \
        p7zip-rar python3 python3-pip python3-setuptools \
        python3-venv python3-numpy dialog linux-headers-$(uname -r)
}

# Function to change shell to zsh
change_shell_to_zsh() {
    echo -e "${YELLOW}Changing shell to zsh${NC}"
    chsh -s "$(which zsh)"
}

# Function to install NVIDIA CUDA if not already present
install_cuda_if_needed() {
    if [ ! -f /usr/bin/nvidia-smi ]; then
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
}

# Function to clone repository and navigate into it
clone_repository() {
    echo -e "${CYAN}Cloning repository${NC}"
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui sd
    cd sd
}

# Function to make a dialog choice for models
choose_models_to_download() {
    local choices=(
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

    dialog --clear --title "Choose models to download" --checklist " " 0 0 0 "${choices[@]}" 2>&1 >/dev/tty
}

# Function to download model
download_model() {
    local filename="$1"
    local url="$2"
    local title="Downloading $filename"
    aria2c -o "$filename" --enable-color=false -x4 "$url" 2>&1 | dialog --title "$title" --progressbox 40 100
}

# Function to download selected models
download_selected_models() {
    local choice=$1

    cd models/Stable-diffusion

    [[ $choice == *"1"* ]] && download_model "Deliberate v5.safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5.safetensors"
    [[ $choice == *"2"* ]] && download_model "Deliberate v5 Inpainting.safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5-inpainting.safetensors"
    [[ $choice == *"3"* ]] && download_model "Deliberate v5 (SFW).safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5 (SFW).safetensors"
    [[ $choice == *"4"* ]] && download_model "Deliberate v5 (SFW) Inpainting.safetensors" "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v5 (SFW)-inpainting.safetensors"
    [[ $choice == *"5"* ]] && download_model "Reliberate v3.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v3.safetensors"
    [[ $choice == *"6"* ]] && download_model "Reliberate v3 Inpainting.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v3-inpainting.safetensors"
    [[ $choice == *"7"* ]] && download_model "Reliberate v2.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v2.safetensors"
    [[ $choice == *"8"* ]] && download_model "Reliberate v2 Inpainting.safetensors" "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate_v3-inpainting.safetensors"
    [[ $choice == *"9"* ]] && download_model "Anime v2.safetensors" "https://huggingface.co/XpucT/Anime/resolve/main/Anime_v2.safetensors"
    [[ $choice == *"10"* ]] && download_model "Anime v2 Inpainting.safetensors" "https://huggingface.co/XpucT/Anime/resolve/main/Anime_v2-inpainting.safetensors"
    [[ $choice == *"11"* ]] && download_model "Anything V5.safetensors" "https://civitai.com/api/download/models/90854"

    cd ../..
}

# Function to make a dialog choice for Lora models
choose_loras_to_install() {
    local loras_list=(
        "1" "LowRA by XpucT" off
        "2" "Lit by XpucT" off
    )

    dialog --clear --title "Choose LoRAs to install" --checklist " " 0 0 0 "${loras_list[@]}" 2>&1 >/dev/tty
}

# Function to download selected Lora models
download_selected_loras() {
    local choice=$1

    for option in $choice; do
        case $option in
            1) lora_name="LowRA"; lora_url="https://civitai.com/api/download/models/63006" ;;
            2) lora_name="Lit"; lora_url="https://civitai.com/api/download/models/55665" ;;
            *) continue ;;
        esac

        mkdir -p models/Lora
        cd models/Lora
        download_model "$lora_name.safetensors" "$lora_url"
        cd ../..
    done
}

# Function to make a dialog choice for extensions
choose_extensions_to_install() {
    local extensions_list=(
        "1" "Aspect ratio selector" true
        "2" "Canvas Zoom" true
        "3" "ControlNet (Depth, Inpaint, LineArt, Canny)" false
    )

    dialog --clear --title "Choose extensions to install" --checklist " " 0 0 0 "${extensions_list[@]}" 2>&1 >/dev/tty
}

# Function to install selected extensions
install_selected_extensions() {
    local choice=$1

    [[ $choice == *"1"* ]] && {
        echo -e "${YELLOW} Installing Aspect Ratio selector"
        cd /root/sd/extensions
        git clone https://github.com/alemelis/sd-webui-ar
        cd /root/sd/
    }

    [[ $choice == *"2"* ]] && {
        echo -e "${YELLOW} Installing Canvas Zoom"
        cd /root/sd/extensions
        git clone https://github.com/richrobber2/canvas-zoom
        cd /root/sd/
    }

    [[ $choice == *"3"* ]] && {
        echo -e "${YELLOW}Installing ControlNet"
        mkdir -p /root/sd/models/ControlNet
        cd /root/sd/models/ControlNet

        declare -a controlnet_models
        controlnet_models+=("control_v11f1p_sd15_depth.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"
                            "control_v11f1p_sd15_depth.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml")
        controlnet_models+=("control_v11p_sd15_inpaint.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.pth"
                            "control_v11p_sd15_inpaint.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.yaml")
        controlnet_models+=("control_v11p_sd15_lineart.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth"
                            "control_v11p_sd15_lineart.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.yaml")
        controlnet_models+=("control_v11p_sd15_canny.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth"
                            "control_v11p_sd15_canny.yaml" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.yaml")

        for i in {0..3}; do
            download_model "${controlnet_models[2*i]}" "${controlnet_models[2*i+1]}"
        done

        cd /root/sd/
        clear
        cd extensions
        git clone https://github.com/Mikubill/sd-webui-controlnet
        cd /root/sd/
    }
}

# Function to download ESRGAN models
download_esrgan_models() {
    mkdir -p /root/sd/models/ESRGAN
    cd /root/sd/models/ESRGAN

    declare -a esrgan_files
    esrgan_files+=("4x_NMKD-Siax_200k.pth|https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_NMKD-Siax_200k.pth")
    esrgan_files+=("4x-UltraSharp.pth|https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x-UltraSharp.pth")
    esrgan_files+=("WaifuGAN_v3_30000.pth|https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/WaifuGAN_v3_30000.pth")
    esrgan_files+=("4x_RealisticRescaler_100000_G.pth|https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_RealisticRescaler_100000_G.pth")

    for file in "${esrgan_files[@]}"; do
        IFS='|' read -r filename url <<< "$file"
        download_model "$filename" "$url"
    done

    cd /root/sd
}

# Function to allow running from root
allow_running_as_root() {
    echo -e "${CYAN}Allowing running from root${NC}"
    sed -i 's/can_run_as_root=0/can_run_as_root=1/' /root/sd/webui.sh
}

# Function to display final instructions
display_final_instructions() {
    echo -e "${GREEN}All done!${NC}"
    echo -e "${GREEN}Use \`cd sd\` to enter into Stable-Diffusion folder"
    echo -e "${GREEN}Run ${CYAN}./webui.sh --listen --xformers${GREEN} to start the webui${NC}"
    local ip=$(curl -sL ident.me)
    echo -e "${CYAN}On first run it will download some requirements. This may take a while"
    echo -e "${GREEN}The address will be http://${ip}:7860/${NC}"
}

# Main script execution
main() {
    check_prerequisites
    update_system $1
    install_dependencies
    change_shell_to_zsh
    install_cuda_if_needed
    clone_repository

    local model_choice=$(choose_models_to_download)
    download_selected_models "$model_choice"

    local lora_choice=$(choose_loras_to_install)
    download_selected_loras "$lora_choice"

    local extension_choice=$(choose_extensions_to_install)
    install_selected_extensions "$extension_choice"

    download_esrgan_models
    allow_running_as_root
    
    display_final_instructions
}

main "$@"
