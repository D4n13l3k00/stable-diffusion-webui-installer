use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use dialoguer::{self, theme::ColorfulTheme, Select};
use std::io::stdout;
use std::path::Path;

use crate::{miniconda, nvidia};
mod extensions;
mod loras;
mod models;

pub fn run_module() {
    let mut stdout = stdout();
    let selections = &["Install SD", "Install models", "Install extensions"];

    let selection = Select::with_theme(&ColorfulTheme::default())
        .with_prompt("Select action")
        .default(0)
        .max_length(5)
        .items(&selections[..])
        .interact()
        .unwrap();

    match selection {
        0 => {
            nvidia::run_module(false);
            miniconda::install();
            clone_repo();
        }
        1 => {
            if Path::new("sd/models").is_dir() {
                models::run_module()
            } else {
                execute!(
                    stdout,
                    SetForegroundColor(Color::Red),
                    Print("Please, install SD first\n"),
                    ResetColor
                )
                .unwrap();
            }
        }
        2 => {
            if Path::new("sd/models").is_dir() {
                extensions::run_module()
            } else {
                execute!(
                    stdout,
                    SetForegroundColor(Color::Red),
                    Print("Please, install SD first\n"),
                    ResetColor
                )
                .unwrap();
            }
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
    let mut stdout = stdout();
    models::run_module();
    extensions::run_module();
    loras::run_module();
    // print success message
    // activate conda env via conda activate neuro
    // enter into sd folder
    // run ./webui.sh --listen --xformers

    execute!(
        stdout,
        SetForegroundColor(Color::Green),
        Print("Stable-Diffusion-WebUI installed successfully\n"),
        SetForegroundColor(Color::Yellow),
        Print("Please, activate conda env via "),
        SetForegroundColor(Color::Cyan),
        Print("`conda activate neuro`\n"),
        SetForegroundColor(Color::Yellow),
        Print("Then, enter into sd folder "),
        SetForegroundColor(Color::Cyan),
        Print("`cd sd`\n"),
        SetForegroundColor(Color::Yellow),
        Print("And run "),
        SetForegroundColor(Color::Cyan),
        Print("`./webui.sh --listen --xformers`\n"),
        ResetColor
    )
    .unwrap();
}
