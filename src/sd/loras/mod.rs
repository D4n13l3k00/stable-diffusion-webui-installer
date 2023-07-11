use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use dialoguer::theme::ColorfulTheme;
use dialoguer::MultiSelect;
use std::io::stdout;
use std::process::Command;

struct LoRAModel {
    name: String,
    filename: String,
    url: String,
}

pub fn run_module() {
    let mut stdout = stdout();

    let models = vec![
        LoRAModel {
            name: "LowRA".to_string(),
            filename: "LowRA.safetensors".to_string(),
            url: "https://civitai.com/api/download/models/63006?type=Model&format=SafeTensor"
                .to_string(),
        },
        LoRAModel {
            name: "Lit".to_string(),
            filename: "Lit.safetensors".to_string(),
            url: "https://civitai.com/api/download/models/55665?type=Model&format=SafeTensor"
                .to_string(),
        },
        LoRAModel {
            name: "FilmGirl / Film Grain LoRA & LoHA".to_string(),
            filename: "FilmGirl.safetensors".to_string(),
            url: "https://civitai.com/api/download/models/112969?type=Model&format=SafeTensor"
                .to_string(),
        },
        LoRAModel {
            name: "T-Pose".to_string(),
            filename: "T-Pose.safetensors".to_string(),
            url: "https://civitai.com/api/download/models/92575?type=Model&format=SafeTensor"
                .to_string(),
        },
        LoRAModel {
            name: "Gigachad Diffusion".to_string(),
            filename: "Gigachad Diffusion.safetensors".to_string(),
            url: "https://civitai.com/api/download/models/21518?type=Model&format=SafeTensor&size=full&fp=fp16"
                .to_string(),
        },
        LoRAModel {
            name: "Detail Tweaker".to_string(),
            filename: "Detail Tweaker.safetensors".to_string(),
            url: "https://civitai.com/api/download/models/62833?type=Model&format=SafeTensor"
                .to_string(),
        },
    ];
    MultiSelect::with_theme(&ColorfulTheme::default())
        .with_prompt("Select LoRA models to download")
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
            let models_dir = "sd/models/Lora";
            Command::new("aria2c")
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
