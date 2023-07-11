use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use std::io::stdout;
use std::process::Command;

pub fn run_module(force: bool) {
    let mut stdout = stdout();

    let nvidia_smi_installed = std::process::Command::new("nvidia-smi").output().is_ok();
    if nvidia_smi_installed && !force {
        execute!(
            stdout,
            SetForegroundColor(Color::Green),
            Print("Nvidia driver is installed!\n"),
            ResetColor
        )
        .unwrap();
    } else {
        let ubuntu_22_04_lts = Command::new("lsb_release")
            .arg("-r")
            .arg("-s")
            .output()
            .unwrap()
            .stdout;

        let ubuntu_22_04_lts = String::from_utf8(ubuntu_22_04_lts).unwrap();
        execute!(
            stdout,
            SetForegroundColor(Color::Cyan),
            Print("System version: "),
            Print(ubuntu_22_04_lts.clone()),
            ResetColor
        )
        .unwrap();
        let ubuntu_22_04_lts = ubuntu_22_04_lts.trim();
        let ubuntu_22_04_lts = ubuntu_22_04_lts.contains("22.04");
        if ubuntu_22_04_lts {
            execute!(
                stdout,
                SetForegroundColor(Color::Cyan),
                Print("Ubuntu 22.04 LTS detected! Installing Nvidia driver\n"),
                ResetColor
            )
            .unwrap();

            Command::new("aria2c")
                .arg("-x")
                .arg("4")
                .arg("https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb")
                .arg("-o")
                .arg("cuda.deb")
                .spawn()
                .unwrap()
                .wait()
                .unwrap();

            Command::new("sudo")
                .arg("dpkg")
                .arg("-i")
                .arg("cuda.deb")
                .spawn()
                .unwrap()
                .wait()
                .unwrap();

            Command::new("rm")
                .arg("cuda.deb")
                .spawn()
                .unwrap()
                .wait()
                .unwrap();

            Command::new("sudo")
                .arg("apt")
                .arg("update")
                .spawn()
                .unwrap()
                .wait()
                .unwrap();

            Command::new("sudo")
                .arg("apt")
                .arg("install")
                .arg("cuda")
                .arg("-y")
                .spawn()
                .unwrap()
                .wait()
                .unwrap();
        } else {
            execute!(
                stdout,
                SetForegroundColor(Color::Yellow),
                Print("Nvidia driver installation only available on Ubuntu 22.04 LTS\n"),
                ResetColor
            )
            .unwrap();
        }
    }
}
