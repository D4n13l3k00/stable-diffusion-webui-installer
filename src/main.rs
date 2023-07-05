use clap::{arg, command, ArgAction, Command};

fn main() {
    let matches = command!()
        .about("SD and Kohya_ss webuis installer and manager")
        .arg(arg!(
            -d --debug "Debug mode"
        ))
        .subcommand(
            Command::new("sd")
                .about("Manage Stable-Diffusion-WebUI")
        )
        .subcommand(
            Command::new("lora")
                .about("Manage Kohya_ss")
        )
        .get_matches();
    if let Some(_matches) = matches.subcommand_matches("lora") {
        panic!("Not implemented yet")
    }
}
