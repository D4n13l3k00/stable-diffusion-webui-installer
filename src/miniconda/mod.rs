use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use reqwest::blocking as rq;
use std::io::stdout;
use std::path::Path;

pub fn install() {
    let mut stdout = stdout();

    let miniconda_installer_url =
        "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh";
    let miniconda_installer_path = "miniconda.sh";

    if Path::new("miniconda").exists() {
        execute!(
            stdout,
            SetForegroundColor(Color::Green),
            Print("Miniconda is already installed.\n"),
            ResetColor
        )
        .unwrap();
        create_env();
        return;
    }

    execute!(
        stdout,
        SetForegroundColor(Color::Yellow),
        Print("Downloading Miniconda installer...\n"),
        ResetColor
    )
    .unwrap();

    let mut response = rq::get(miniconda_installer_url).unwrap();
    let mut file = std::fs::File::create(miniconda_installer_path).unwrap();
    std::io::copy(&mut response, &mut file).unwrap();

    execute!(
        stdout,
        SetForegroundColor(Color::Yellow),
        Print("Installing Miniconda...\n"),
        ResetColor
    )
    .unwrap();
    std::process::Command::new("chmod")
        .arg("+x")
        .arg(miniconda_installer_path)
        .spawn()
        .unwrap()
        .wait()
        .unwrap();

    std::process::Command::new("bash")
        .arg(miniconda_installer_path)
        .arg("-b")
        .arg("-p")
        .arg("miniconda")
        .spawn()
        .unwrap()
        .wait()
        .unwrap();

    std::fs::remove_file(miniconda_installer_path).unwrap();

    execute!(
        stdout,
        SetForegroundColor(Color::Green),
        Print("Miniconda installed!\n"),
        ResetColor
    )
    .unwrap();

    create_env();
}

fn create_env() {
    let mut stdout = stdout();

    if Path::new("miniconda/envs/neuro").exists() {
        execute!(
            stdout,
            SetForegroundColor(Color::Green),
            Print("Environment already created.\n"),
            ResetColor
        )
        .unwrap();
        return;
    }

    execute!(
        stdout,
        SetForegroundColor(Color::Yellow),
        Print("Creating environment...\n"),
        ResetColor
    )
    .unwrap();

    std::process::Command::new("miniconda/bin/conda")
        .arg("create")
        .arg("-n")
        .arg("neuro")
        .arg("-y")
        .arg("python=3.10")
        .arg("pip")
        .arg("setuptools")
        .arg("wheel")
        .arg("cudatoolkit")
        .spawn()
        .unwrap()
        .wait()
        .unwrap();

    // conda init
    std::process::Command::new("miniconda/bin/conda")
        .arg("init")
        .arg("bash")
        .arg("zsh")
        .spawn()
        .unwrap()
        .wait()
        .unwrap();
}
