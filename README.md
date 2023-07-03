# 😎 Stable-diffusion-webui installer for Ubuntu Server 22.04 LTS

## About

This script was created for Selectel GPU Line, for fast and easy installation of stable-diffusion, but this script can be used on any Ubuntu Server 22.04 LTS(idk?)

## Features

* ▶️ Fully automatic installation
  * Installs all dependencies
  * Installs the latest version of stable-diffusion-webui
  * ▶️ Install any models
    * [O] Stable-Diffusion v1.5
    * [O] Stable-Diffusion v1.5 Inpainting
    * [A] Anything v5
    * [A] Elysium Anime v3
    * [A] Waifu Diffusion v1.3
    * [U] Deliberate latest (by XpucT)
    * [U] Deliberate Inpainting (by XpucT)
    * [F] f222
      * O - Original, A - Anime, U - Universal, F - Faces
  * ▶️ Install any extensions:
    * ControlNet (openpose, depth, canny models)
    * PoseX (Need ControlNet)

```bash
wget https://raw.githubusercontent.com/D4n13l3k00/stable-diffusion-webui-installer/master/install.sh
chmod +x install.sh
./install.sh
```

## 📝 License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE) file for details
