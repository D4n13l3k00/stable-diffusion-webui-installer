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
    * [Deliberate v2.0](https://civitai.com/models/4823/deliberate)
    * [Deliberate v1.1](https://civitai.com/models/4823?modelVersionId=5616)
    * [Deliberate Inpainting](https://huggingface.co/XpucT/Deliberate/blob/main/Deliberate-inpainting.safetensors)
    * [Reliberate](https://civitai.com/models/79754?modelVersionId=84576)
    * [Reliberate Inpainting](https://huggingface.co/XpucT/Reliberate/blob/main/Reliberate-inpainting.safetensors)
    * [Anything v5](https://civitai.com/models/9409?modelVersionId=90854)
    * [Elysium Anime v3](https://civitai.com/models/8602?modelVersionId=10500)
    * [Waifu Diffusion v1.3](https://civitai.com/models/44?modelVersionId=121)
    * [f222](https://civitai.com/models/1188?modelVersionId=1224)
  * ▶️ Install any LoRA models:
    * [LowRA](https://civitai.com/models/48139/lowra)
    * [Lit](https://civitai.com/models/51145/lit)
    * [FilmGirl / Film Grain LoRA & LoHA](https://civitai.com/models/33208/filmgirl-film-grain-lora-and-loha)
    * [T-Pose](https://civitai.com/models/87017/t-pose-or-1mb-pose-lora)
    * [Gigachad Diffusion](https://civitai.com/models/18177/gigachad-diffusionlora)
    * [Detail Tweaker](https://civitai.com/models/58390/detail-tweaker-lora-lora)
  * ▶️ Install any extensions:
    * [Aspect ratio selector](https://github.com/alemelis/sd-webui-ar)
    * [Canvas Zoom](https://github.com/richrobber2/canvas-zoom)

## 📝 License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](/LICENSE) file for details
