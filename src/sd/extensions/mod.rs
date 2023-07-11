use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use dialoguer::theme::ColorfulTheme;
use dialoguer::MultiSelect;
use std::io::stdout;
use std::process::Command;

struct Extension {
    name: String,
    git_url: String,
    folder_name: String,
}

pub fn run_module() {
    let mut stdout = stdout();

    let extensions = vec![
        Extension {
            name: "Aspect Ratio Selector".to_string(),
            git_url: "https://github.com/alemelis/sd-webui-ar".to_string(),
            folder_name: "sd-webui-ar".to_string(),
        },
        Extension {
            name: "Canvas Zoom".to_string(),
            git_url: "https://github.com/richrobber2/canvas-zoom".to_string(),
            folder_name: "canvas-zoom".to_string(),
        },
    ];

    MultiSelect::with_theme(&ColorfulTheme::default())
        .with_prompt("Select extensions to install")
        .items(&extensions.iter().map(|i| &i.name).collect::<Vec<_>>())
        .interact()
        .unwrap()
        .iter()
        .for_each(|i| {
            execute!(
                stdout,
                SetForegroundColor(Color::Green),
                Print(format!("Installing {}...\n", extensions[*i].name)),
                ResetColor
            )
            .unwrap();
            let path = format!("sd/extensions/{}", extensions[*i].folder_name);
            Command::new("git")
                .arg("clone")
                .arg(extensions[*i].git_url.clone())
                .arg(path)
                .spawn()
                .unwrap()
                .wait()
                .unwrap();
        });
}
