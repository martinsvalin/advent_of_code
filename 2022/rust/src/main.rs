use std::env;
use std::fs::read_to_string;
use std::process::exit;

mod calorie_counting;
mod rock_paper_scissors;

fn main() {
    let arg = env::args_os()
        .nth(1)
        .unwrap_or_else(|| exit_with_usage_instructions());

    match arg.to_str().unwrap().parse::<i32>() {
        Ok(1) => print_solutions("1", calorie_counting::part1, calorie_counting::part2),
        Ok(2) => print_solutions("2", rock_paper_scissors::part1, rock_paper_scissors::part2),

        Ok(n) if n <= 25 => println!("Not implemented yet"),
        _ => exit_with_usage_instructions(),
    };
}

fn exit_with_usage_instructions() -> ! {
    println!("Usage: cargo run <day>, where day in 1-25");
    exit(1);
}

fn print_solutions(day: &str, part1: fn(&String) -> String, part2: fn(&String) -> String) -> () {
    let input = read_to_string(format!("../input/{}", day)).expect("Unable to open input file");
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}
