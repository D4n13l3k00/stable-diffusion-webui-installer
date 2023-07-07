use std::io::stdout;

use clap::{arg, command, Command};
use crossterm::{
    execute,
    style::{Color, Print, ResetColor, SetForegroundColor},
};
use dialoguer::{theme::ColorfulTheme, Confirm};
mod kohya;
mod miniconda;
mod sd;

fn main() {
    let mut stdout = stdout();

    let matches = command!()
        .about("SD and Kohya_ss webuis installer and manager")
        .arg(arg!(
            -d --debug "Debug mode"
        ))
        .subcommand(Command::new("sd").about("Manage Stable-Diffusion-WebUI"))
        .subcommand(Command::new("lora").about("Manage Kohya_ss"))
        .subcommand(Command::new("delete").about("Delete all"))
        .get_matches();
    if let Some(_matches) = matches.subcommand_matches("sd") {
        sd::run_module()
    } else if let Some(_matches) = matches.subcommand_matches("lora") {
        kohya::run_module()
    } else if let Some(_matches) = matches.subcommand_matches("delete") {

        let dirs = ["sd", "kohya_ss", "miniconda_portable"];

        execute!(
            stdout,
            SetForegroundColor(Color::Red),
            Print(format!("Warning: This will delete all ({})\n", dirs.join(", "))),
            ResetColor
        )
        .unwrap();
        if Confirm::with_theme(&ColorfulTheme::default())
            .with_prompt("Do you want to continue?")
            .interact()
            .unwrap()
        {

            for dir in dirs.iter() {
                match std::fs::remove_dir_all(dir) {
                    Ok(_) => execute!(
                        stdout,
                        SetForegroundColor(Color::Green),
                        Print(format!("{} deleted\n", dir)),
                        ResetColor
                    )
                    .unwrap(),
                    Err(_) => {}
                }
            }
            execute!(
                stdout,
                SetForegroundColor(Color::Yellow),
                Print("Done\n"),
                ResetColor
            )
            .unwrap();
        } else {
            execute!(
                stdout,
                SetForegroundColor(Color::Yellow),
                Print("Aborted\n"),
                ResetColor
            )
            .unwrap();
        }
    }
}
