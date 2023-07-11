use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use dialoguer::theme::ColorfulTheme;
use dialoguer::MultiSelect;
use std::io::stdout;

struct Model {
    name: String,
    filename: String,
    url: String,
}

pub fn run_module() {
    let mut stdout = stdout();

    let models = vec![
        Model {
            name: "Deliberate v2.0".to_string(),
            filename: "Deliberate_v2.safetensors".to_string(),
            url: "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate_v2.safetensors"
                .to_string(),
        },
        Model {
            name: "Deliberate v1.1".to_string(),
            filename: "Deliberate_v1.1.safetensors".to_string(),
            url: "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate.safetensors"
                .to_string(),
        },
        Model {
            name: "Deliberate Inpainting".to_string(),
            filename: "Deliberate-Inpainting.safetensors".to_string(),
            url: "https://huggingface.co/XpucT/Deliberate/resolve/main/Deliberate-inpainting.safetensors"
                .to_string(),
        },
        Model {
            name: "Reliberate".to_string(),
            filename: "Reliberate.safetensors".to_string(),
            url: "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate.safetensors"
                .to_string(),
        },
        Model {
            name: "Reliberate Inpainting".to_string(),
            filename: "Reliberate-Inpainting.safetensors".to_string(),
            url: "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate-inpainting.safetensors"
                .to_string(),
        },
        Model {
            name: "Elysium Anime v3".to_string(),
            filename: "Elysium Anime v3.safetensors".to_string(),
            url: "https://huggingface.co/hesw23168/SD-Elysium-Model/resolve/main/Elysium_Anime_V3.safetensors"
                .to_string(),
        },Model {
            name: "Waifu Diffusion v1.3".to_string(),
            filename: "Waifu Diffusion v1.3.ckpt".to_string(),
            url: "https://huggingface.co/hakurei/waifu-diffusion-v1-3/resolve/main/wd-v1-3-float32.ckpt"
                .to_string(),
        },Model {
            name: "f222".to_string(),
            filename: "f222.safetensors".to_string(),
            url: "https://huggingface.co/acheong08/f222/resolve/main/f222.safetensors"
                .to_string(),
        },
    ];

    MultiSelect::with_theme(&ColorfulTheme::default())
        .with_prompt("Select models to download")
        .items(&models.iter().map(|i| &i.name).collect::<Vec<_>>())
        .interact()
        .unwrap()
        .iter()
        .for_each(|i| {
            execute!(
                stdout,
                SetForegroundColor(Color::Green),
                Print(format!("Downloading {}...\n", models[*i].name)),
                ResetColor
            )
            .unwrap();
            let models_dir = "sd/models/Stable-diffusion";
            std::process::Command::new("aria2c")
                .arg("-x")
                .arg("4")
                .arg("--summary-interval")
                .arg("0")
                .arg(models[*i].url.clone())
                .arg("-o")
                .arg(format!("{}/{}", models_dir, models[*i].filename))
                .spawn()
                .unwrap()
                .wait()
                .unwrap();
        });
}
