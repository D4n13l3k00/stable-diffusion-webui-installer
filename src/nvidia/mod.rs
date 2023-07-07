use crossterm::execute;
use crossterm::style::{Color, Print, ResetColor, SetForegroundColor};
use std::io::stdout;

pub fn run_module() {
    let mut stdout = stdout();
    execute!(
        stdout,
        SetForegroundColor(Color::Yellow),
        Print("TODO: install NVidia drivers\n"),
        ResetColor
    )
    .unwrap();
}
