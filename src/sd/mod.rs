use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use dialoguer::{self, theme::ColorfulTheme, Select};
use std::io::stdout;

use crate::miniconda;
mod extensions;
mod loras;
mod models;

pub fn run_module() {
    let selections = &["Install SD"];

    let selection = Select::with_theme(&ColorfulTheme::default())
        .with_prompt("Select action")
        .default(0)
        .max_length(5)
        .items(&selections[..])
        .interact()
        .unwrap();

    match selection {
        0 => {
            miniconda::install();
            clone_repo();
        }
        _ => return,
    }
}

fn clone_repo() {
    let mut stdout = stdout();

    if !std::path::Path::new("sd").exists() {
        execute!(
            stdout,
            SetForegroundColor(Color::Yellow),
            Print("Cloning Stable-Diffusion-WebUI...\n"),
            ResetColor
        )
        .unwrap();

        std::process::Command::new("git")
            .arg("clone")
            .arg("https://github.com/AUTOMATIC1111/stable-diffusion-webui")
            .arg("sd")
            .spawn()
            .unwrap()
            .wait()
            .unwrap();
    }

    install_additions();
}

fn install_additions() {
    models::run_module();
    extensions::run_module();
    loras::run_module();
}
