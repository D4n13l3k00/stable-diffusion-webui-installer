# 😎 SD-webui and Kohya_ss (LoRA training) installers for Ubuntu Server 22.04 LTS

## About

This script was created for Selectel GPU Line, for fast and easy installation of stable-diffusion and Kohya_ss, but this script can be used on any Ubuntu Server 22.04 LTS(idk?)

## Features

* ▶️ Fully automatic installation
  * Installs all dependencies
  * Installs the latest version of [stable-diffusion-webui](/install.sh)
    * ▶️ Install models:
      * Deliberate v5
      * Deliberate v5 Inpainting
      * Deliberate v5 (SFW)
      * Deliberate v5 (SFW) Inpainting
      * Reliberate v3
      * Reliberate v3 Inpainting
      * Reliberate v2
      * Reliberate v2 Inpainting
      * Anime v2
      * Anime v2 Inpainting
      * Anything V5
    * ▶️ Install extensions:
      * Aspect ratio selector
      * Canvas Zoom
      * ControlNet (Depth, Inpaint, LineArt, Canny)
  * Installs the latest version of [Kohya_ss](/lora.sh)

```bash
# For SD
wget https://raw.githubusercontent.com/D4n13l3k00/stable-diffusion-webui-installer/master/install.sh
chmod +x install.sh
./install.sh

# For LoRA
wget https://raw.githubusercontent.com/D4n13l3k00/stable-diffusion-webui-installer/master/lora.sh
chmod +x lora.sh
./lora.sh
```

## 📝 License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE) file for details
