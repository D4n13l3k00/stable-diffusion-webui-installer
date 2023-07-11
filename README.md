# Stable Diffusion Webui and Kohya_SS installer

## About

Installer of SD, Kohya_SS for linux written in Rust

```shell
$ cargo run -q -- -h

SD and Kohya_ss webuis installer and manager

Usage: stable-diffusion-webui-installer [COMMAND]

Commands:
  sd      Manage Stable-Diffusion-WebUI
  lora    Manage Kohya_ss
  nvidia  Install Nvidia drivers (Only for Ubuntu 22.04 LTS)
  delete  Delete all
  help    Print this message or the help of the given subcommand(s)

Options:
  -h, --help     Print help
  -V, --version  Print version
```

## Features

* ▶️ Fully automatic installation
  * Installs all dependencies
  * Installs the latest version of stable-diffusion-webui
  * ▶️ Install any models
    * Deliberate v2.0
    * Deliberate v1.1
    * Deliberate Inpainting
    * Reliberate
    * Reliberate Inpainting
    * Elysium Anime v3
    * Waifu Diffusion v1.3
    * f222
  * ▶️ Install any extensions:
    * Aspect ratio selector
    * Canvas Zoom

## 📝 License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](/LICENSE) file for details
